import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class RedditItem {
  final String id;
  final String title;
  final String subreddit;
  final String url;
  final String score;
  final String author;
  final String domain;
  final String comments;
  final String created;

  RedditItem({
    this.id,
    this.title,
    this.subreddit,
    this.url,
    this.score,
    this.author,
    this.domain,
    this.comments,
    this.created,
  });

  factory RedditItem.fromJson(Map<String, dynamic> json) {
    var data = json['data'];

    var created = DateTime.fromMillisecondsSinceEpoch(
        int.parse(data['created_utc'].toString().substring(0, 10)) * 1000);
    var score = NumberFormat.compact().format(data['score']);
    var comments = NumberFormat.compact().format(data['num_comments']);

    return RedditItem(
      id: data['id'] as String,
      title: data['title'] as String,
      subreddit: data['subreddit'] as String,
      url: data['url'] as String,
      score: score,
      author: data['author'] as String,
      domain: data['domain'] as String,
      comments: comments,
      created: timeago.format(created),
    );
  }
}
