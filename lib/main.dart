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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.orange
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('The Toto App'),
        ),
        body: _screens.elementAt(_index),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          onTap: (int index) {
            setState(() {
              _index = index;
            });
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              backgroundColor: Colors.orange,
              icon: Icon(TotoApp.hacker_news),
              title: Text('HackerNews'),
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.orange,
              icon: Icon(TotoApp.reddit_alien),
              title: Text('Reddit'),
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.orange,
              icon: Icon(TotoApp.medium),
              title: Text('Medium'),
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.orange,
              icon: Icon(TotoApp.product_hunt),
              title: Text('ProductHunt'),
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.orange,
              icon: Icon(TotoApp.github_circled),
              title: Text('GitHub'),
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.orange,
              icon: Icon(TotoApp.dribbble),
              title: Text('Dribbble'),
            ),
          ],
        ),
      ),
    );
  }
}
