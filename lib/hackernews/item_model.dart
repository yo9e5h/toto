import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

class Item {
  final int id;
  final String title;
  final String by;
  final String url;
  final String score;
  final String time;
  final String descendants;

  Item({this.id, this.title, this.by, this.url, this.score, this.time, this.descendants});

  factory Item.fromJson(Map json) {
    var datetime = DateTime.fromMillisecondsSinceEpoch(json['time'] * 1000);
    var score = NumberFormat.compact().format(json['score']);

    return Item(
      id: json['id'] as int,
      title: json['title'] as String,
      by: json['by'] as String,
      url: json['url'] as String,
      score: score,
      time: timeago.format(datetime),
      descendants: "${json['descendants'] ?? 0}",
    );
  }
}