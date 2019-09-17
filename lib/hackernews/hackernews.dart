import 'dart:async';
import 'package:flutter/material.dart';
import 'package:toto/hackernews/hn_item_model.dart';
import 'package:toto/hackernews/hn_item_repository.dart';

import 'hn_item_tile.dart';

class HackerNews extends StatefulWidget {
  @override
  _HackerNews createState() => _HackerNews();
}

class _HackerNews extends State<HackerNews> {
  List<HNItem> items = [];
  bool _isLoading = false;
  HNItemRepository itemRepository = HNItemRepository();

  @override
  void initState() {
    _fetchTopStories();
    super.initState();
  }

  _fetchTopStories() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var response = await itemRepository.getItems();
      setState(() {
        items = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      final snackBar = SnackBar(
        content: Text('Unable to fetch stories from HackerNews!'),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future _refreshItems() async {
    Future.delayed(Duration(seconds: 1));
    await _fetchTopStories();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading == true) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (items == null || items.length <= 0) {
      return RefreshIndicator(
        onRefresh: _refreshItems,
        child: Scrollbar(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              child: Center(
                child: Text('There are no stories available!'),
              ),
              height: MediaQuery.of(context).size.height - 100,
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshItems,
      child: Scrollbar(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, i) {
            return HNItemTile(
              item: items[i],
            );
          },
        ),
      ),
    );
  }
}
