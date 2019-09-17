import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:toto/reddit/reddit_item_model.dart';

class RedditItemRepository {
  getItems() async {
    var response =
        await http.get('https://www.reddit.com/r/popular.json?limit=30');

    var posts = json.decode(response.body)['data']['children'];

    return posts.map<RedditItem>((post) => RedditItem.fromJson(post)).toList();
  }
}
