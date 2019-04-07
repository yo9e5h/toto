import 'dart:async';

import 'package:flutter/material.dart';
import 'package:toto/hackernews/models/item.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

class HackerNews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ItemsList();
  }
}

class ItemsList extends StatefulWidget {
  @override
  _ItemsListState createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  List<Item> items = [];
  bool _isLoading = false;

  @override
  void initState() {
    _fetchTopStories();
    super.initState();
  }

  _fetchTopStories() async {
    setState(() {
      _isLoading = true;
    });

    Dio().get('https://hacker-news.firebaseio.com/v0/topstories.json')
      .then((response) {
        _getItems(response.data.sublist(0, 24)).then(_appendItems);
      })
      .catchError((error) {
        print(error);
      });
  }

  Future<List<Item>> _getItems(List<dynamic> list) async {
    Completer<List<Item>> completer = new Completer<List<Item>>();

    Future.wait(
      list.map((id) => Dio().get('https://hacker-news.firebaseio.com/v0/item/$id.json')
        .then((response) => Item.fromJson(response.data)))
    ).then((value) => completer.complete(value));

    return completer.future;
  }

  _appendItems(List<Item> value) {
    setState(() {
      items.addAll(value);
      print(items.length);
      _isLoading = false;
    });
  }

  Future _refreshItems() async {
    Future.delayed(Duration(seconds: 1));
    await _fetchTopStories();
  }

  @override
  Widget build(BuildContext context) {
    if (items == null || _isLoading == true) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshItems,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, i) {
          Item item = items[i];

          return ListTile(
            contentPadding: EdgeInsets.all(10.0),
            title: Padding(padding: EdgeInsets.only(bottom: 8.0), child: Text(item.title),),
            subtitle: Text("${item.by} (${item.time})", style: TextStyle(fontSize: 12.0),),
            trailing: Column(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.comment, color: Colors.deepOrange,),
                  onPressed: () async {
                    var url = "https://news.ycombinator.com/item?id=${item.id}";
                    if (await canLaunch(url)) {
                      await launch(url, forceWebView: true, forceSafariVC: true);
                    } else {
                      print('Can not launch $url');
                    }
                  },
                ),
                Text(item.descendants)
              ],
            ),
            onTap: () async {
              if (await canLaunch(item.url)) {
                await launch(item.url, forceWebView: true, forceSafariVC: true);
              } else {
                print('Can not launch ${item.url}');
              }
            },
          );
        },
      ),
    );
  }
}