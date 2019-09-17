import 'package:flutter/material.dart';
import 'package:toto/reddit/reddit_item_model.dart';
import 'package:toto/reddit/reddit_item_repository.dart';
import 'package:toto/reddit/reddit_item_tile.dart';

class Reddit extends StatefulWidget {
  @override
  _RedditState createState() => _RedditState();
}

class _RedditState extends State<Reddit> {
  List<RedditItem> items = [];
  bool _isLoading = false;
  RedditItemRepository itemRepository = RedditItemRepository();

  @override
  void initState() {
    _fetchPopularePosts();
    super.initState();
  }

  _fetchPopularePosts() async {
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
        content: Text('Unable to fetch popular posts from Reddit!'),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future _refreshItems() async {
    Future.delayed(Duration(seconds: 1));
    await _fetchPopularePosts();
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
            return RedditItemTile(
              item: items[i],
            );
          },
        ),
      ),
    );
  }
}
