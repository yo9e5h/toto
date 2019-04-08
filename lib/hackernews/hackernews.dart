import 'dart:async';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

import 'package:flutter/material.dart';
import 'package:toto/hackernews/models/item.dart';
import 'package:dio/dio.dart';

class HackerNews extends StatefulWidget {
  @override
  _HackerNews createState() => _HackerNews();
}

class _HackerNews extends State<HackerNews> {
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
      _isLoading = false;
    });
  }

  Future _refreshItems() async {
    Future.delayed(Duration(seconds: 1));
    await _fetchTopStories();
  }

  @override
  Widget build(BuildContext context) {
    if (items == null || items.length <= 0 || _isLoading == true) {
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
            subtitle: Text("${item.by} - ${item.time}", style: TextStyle(fontSize: 12.0),),
            trailing: Transform.translate(
              offset: Offset(5, 0),
                child: IconButton(
                padding: EdgeInsets.all(0),
                icon: Column(
                  children: <Widget>[
                    Icon(Icons.comment,),
                    Text(item.descendants)
                  ],
                ),
                onPressed: () async {
                  var url = "https://news.ycombinator.com/item?id=${item.id}";
                  try {
                    await launch(url, option: CustomTabsOption(
                      toolbarColor: Color(0xFF222222),
                      showPageTitle: true,
                    ));
                  } catch (e) {
                  }
                },
              ),
            ),
            onTap: () async {
              try {
                await launch(item.url, option: CustomTabsOption(
                  toolbarColor: Color(0xFF222222),
                  showPageTitle: true,
                ));
              } catch (e) {
              }
            },
          );
        },
      ),
    );
  }
}