import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'hn_item_model.dart';

class HNItemRepository {
  HashMap<int, HNItem> _cachedItems;

  HNItemRepository() {
    _cachedItems = HashMap<int, HNItem>();
  }

  getItems() async {
    var response =
        await http.get('https://hacker-news.firebaseio.com/v0/topstories.json');

    return _parseItems(json.decode(response.body).sublist(0, 24));
  }

  Future<List<HNItem>> _parseItems(List<dynamic> list) async {
    Completer<List<HNItem>> completer = new Completer<List<HNItem>>();

    Future.wait(list.map((id) async {
      if (!_cachedItems.containsKey(id)) {
        var response = await http
            .get('https://hacker-news.firebaseio.com/v0/item/$id.json');
        _cachedItems[id] = HNItem.fromJson(json.decode(response.body));
        return _cachedItems[id];
      } else {
        return _cachedItems[id];
      }
    })).then((value) => completer.complete(value));

    return completer.future;
  }
}
