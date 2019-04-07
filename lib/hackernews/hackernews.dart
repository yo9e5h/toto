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
    _fetchItems();
    super.initState();
  }

  _fetchItems() async {
    setState(() {
      _isLoading = true;
    });

    Dio().get('https://hacker-news.firebaseio.com/v0/topstories.json')
      .then((response) {
        for (var i = 0; i < 24; i++) {
          Dio().get('https://hacker-news.firebaseio.com/v0/item/${response.data[i]}.json')
          .then((response) {
            List<Item> newItems = items;
            newItems.add(Item.fromJson(response.data));
            setState(() {
              items = newItems;
            });
          })
          .catchError((error) {
            print(error);
          });
        }

        setState(() {
          _isLoading = false;
        });
      })
      .catchError((error) {
        print(error);
      });
  }

  Future _refreshItems() async {
    Future.delayed(Duration(seconds: 1));
    await _fetchItems();
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