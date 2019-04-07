import 'package:flutter/material.dart';
import 'package:toto/hackernews/models/item.dart';
import 'package:dio/dio.dart';

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
  List<Item> items;

  @override
  void initState() {
    _fetchItems();
    super.initState();
  }

  _fetchItems() {
    Dio().get('https://hacker-news.firebaseio.com/v0/topstories.json')
      .then((response) {
        print(response.data);
      })
      .catchError((error) {
        print(error.response.data);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}