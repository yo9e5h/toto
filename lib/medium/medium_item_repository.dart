import 'dart:convert';

import 'package:http/http.dart' as http;

import 'medium_item_model.dart';

class MediumItemRepository {
  getItems() async {
    var response =
        await http.get('https://medium.com/topic/popular?format=json');

    // Medium prefixes with a while loop to prevent javascript eval attacks, so
    // skip to the first open curly brace
    var fixedJson = response.body.replaceAll('])}while(1);</x>', '');
    var parsedPosts = jsonDecode(fixedJson)['payload']['references']['Post'];
    var parsedUsers = jsonDecode(fixedJson)['payload']['references']['User'];

    List<MediumItem> posts = [];

    parsedPosts.forEach((key, value) {
      value['author'] = parsedUsers[value['creatorId']]['name'];

      MediumItem item = MediumItem.fromJson(value);

      posts.add(item);
    });

    return posts;
  }
}
