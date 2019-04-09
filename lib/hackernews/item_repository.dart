import 'dart:async';
import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:toto/hackernews/item_model.dart';

class ItemRepository {
  HashMap<int, Item> _cachedItems;

  ItemRepository() {
    _cachedItems = HashMap<int, Item>();
  }

  getItems() async {
    var response = await Dio().get('https://hacker-news.firebaseio.com/v0/topstories.json');

    return _parseItems(response.data.sublist(0, 24));
  }

  Future<List<Item>> _parseItems(List<dynamic> list) async {
    Completer<List<Item>> completer = new Completer<List<Item>>();

    Future.wait(
      list.map((id) async {
        if (!_cachedItems.containsKey(id)) {
          var response = await Dio().get('https://hacker-news.firebaseio.com/v0/item/$id.json');
          _cachedItems[id] = Item.fromJson(response.data);
          return _cachedItems[id];
        } else {
          return _cachedItems[id];
        }
      })
    ).then((value) => completer.complete(value));

    return completer.future;
  }
}

