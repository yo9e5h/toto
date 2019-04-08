import 'package:flutter/material.dart';
import 'package:toto/dribbble/dribbble.dart';

import 'package:toto/font_icons.dart';
import 'package:toto/github/github.dart';
import 'package:toto/hackernews/hackernews.dart';
import 'package:toto/medium/medium.dart';
import 'package:toto/producthunt/producthunt.dart';
import 'package:toto/reddit/reddit.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _index = 0;

  final _screens = [
    HackerNews(),
    Reddit(),
    Medium(),
    ProductHunt(),
    GitHub(),
    Dribbble()
  ];

  final _titles = [
    "HackerNews",
    "Reddit",
    "Medium",
    "ProductHunt",
    "GitHub",
    "Dribbble"
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF222222)
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(_titles.elementAt(_index)),
        ),
        body: _screens.elementAt(_index),
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Color(0xFF999999),
          currentIndex: _index,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(TotoApp.hacker_news),
              title: SizedBox.shrink(),
            ),
            BottomNavigationBarItem(
              icon: Icon(TotoApp.reddit_alien),
              title: SizedBox.shrink(),
            ),
            BottomNavigationBarItem(
              icon: Icon(TotoApp.medium),
              title: SizedBox.shrink(),
            ),
            BottomNavigationBarItem(
              icon: Icon(TotoApp.product_hunt),
              title: SizedBox.shrink(),
            ),
            BottomNavigationBarItem(
              icon: Icon(TotoApp.github_circled),
              title: SizedBox.shrink(),
            ),
            BottomNavigationBarItem(
              icon: Icon(TotoApp.dribbble),
              title: SizedBox.shrink(),
            ),
          ],
          onTap: (int index) {
            setState(() {
              _index = index;
            });
          },
        ),
      ),
    );
  }
}
