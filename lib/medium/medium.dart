import 'package:flutter/material.dart';
import 'package:toto/medium/medium_item_model.dart';
import 'package:toto/medium/medium_item_repository.dart';
import 'package:toto/medium/medium_item_tile.dart';

class Medium extends StatefulWidget {
  @override
  _MediumState createState() => _MediumState();
}

class _MediumState extends State<Medium> {
  List<MediumItem> items = [];
  bool _isLoading = false;
  MediumItemRepository itemRepository = MediumItemRepository();

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
        content: Text('Unable to fetch popular posts from Medium!'),
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
            return MediumItemTile(
              item: items[i],
            );
          },
        ),
      ),
    );
  }
}
