import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

import 'reddit_item_model.dart';

class RedditItemTile extends StatelessWidget {
  final RedditItem item;

  RedditItemTile({this.item});

  _launchURL(String url) async {
    try {
      await launch(
        url,
        option: CustomTabsOption(
          toolbarColor: Color(0xFF222222),
          showPageTitle: true,
          enableDefaultShare: true,
        ),
      );
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    var uri = Uri.parse(item.url);
    return ListTile(
      contentPadding: EdgeInsets.all(10.0),
      title: Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Text(
                    "+${item.score}",
                    style: TextStyle(
                      fontSize: 11.0,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Icon(
                      Icons.watch_later,
                      color: Color(0xFF999999),
                      size: 6.0,
                    ),
                  ),
                  Text(
                    item.subreddit,
                    style: TextStyle(
                      fontSize: 11.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Icon(
                      Icons.watch_later,
                      color: Color(0xFF999999),
                      size: 6.0,
                    ),
                  ),
                  Text(
                    "${item.created}",
                    style: TextStyle(
                      fontSize: 11.0,
                      color: Color(0xFF888888),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              item.title,
              style: TextStyle(
                fontSize: 15.0,
              ),
            )
          ],
        ),
      ),
      subtitle: Text(
        "/u/${item.author}  −  ${uri.host}",
        style: TextStyle(fontSize: 12.0),
      ),
      trailing: Column(
        children: <Widget>[
          Transform.translate(
            offset: Offset(8, 0),
            child: IconButton(
              padding: EdgeInsets.all(0),
              icon: Column(
                children: <Widget>[
                  Icon(
                    Icons.comment,
                  ),
                  Text(
                    item.comments,
                    style: TextStyle(
                      fontSize: 12.0,
                    ),
                  )
                ],
              ),
              onPressed: () async {
                await _launchURL(
                    "https://news.ycombinator.com/item?id=${item.id}");
              },
            ),
          ),
        ],
      ),
      onTap: () async {
        await _launchURL(item.url);
      },
    );
  }
}
