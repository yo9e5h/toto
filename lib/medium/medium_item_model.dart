import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class MediumItem {
  final String id;
  final String title;
  final String url;
  final String score;
  final String author;
  final String comments;
  final String created;

  MediumItem({
    this.id,
    this.title,
    this.url,
    this.score,
    this.author,
    this.comments,
    this.created,
  });

  factory MediumItem.fromJson(Map<String, dynamic> data) {
    var created = DateTime.fromMillisecondsSinceEpoch(data['createdAt']);
    var score = NumberFormat.compact().format(data['virtuals']['recommends']);
    var comments = NumberFormat.compact()
        .format(data['virtuals']['responsesCreatedCount']);

    return MediumItem(
      id: data['id'] as String,
      title: data['title'] as String,
      url: data['uniqueSlug'] as String,
      score: score,
      author: data['author'] as String,
      comments: comments,
      created: timeago.format(created),
    );
  }
}
