import 'dart:async';
import 'package:flutter/material.dart';
import 'package:toto/hackernews/item_model.dart';
import 'package:toto/hackernews/item_repository.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

class HackerNews extends StatefulWidget {
  @override
  _HackerNews createState() => _HackerNews();
}

class _HackerNews extends State<HackerNews> {
  ItemRepository itemRepository = ItemRepository();
  List<Item> items = [];
  bool _isLoading = false;

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

      final snackBar = SnackBar(content: Text('Unable to fetch stories from HackerNews!'),);
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
            return ItemTile(item: items[i],);
          },
        ),
      ),
    );
  }
}

class ItemTile extends StatelessWidget {
  final Item item;

  ItemTile({this.item});

  _launchURL(String url) async {
    try {
      await launch(url, option: CustomTabsOption(
        toolbarColor: Color(0xFF222222),
        showPageTitle: true,
        enableDefaultShare: true
      ));
    } catch (e) {
    }
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
                  Text("+${item.score}", style: TextStyle(fontSize: 11.0, color: Colors.black,)),
                  Padding(padding: EdgeInsets.only(left:8.0, right: 8.0), child: Icon(Icons.watch_later, color: Color(0xFF999999), size: 6.0,),),
                  Text("${item.time}", style: TextStyle(fontSize: 11.0, color: Color(0xFF888888),)),
                ],
              ),
            ),
            Text(item.title)
          ],
        ),
      ),
      subtitle: Text("${item.by}  −  ${uri.host}", style: TextStyle(fontSize: 12.0),),
      trailing: Transform.translate(
        offset: Offset(8, 0),
          child: IconButton(
          padding: EdgeInsets.all(0),
          icon: Column(
            children: <Widget>[
              Icon(Icons.comment,),
              Text(item.descendants)
            ],
          ),
          onPressed: () async {
            await _launchURL("https://news.ycombinator.com/item?id=${item.id}");
          },
        ),
      ),
      onTap: () async {
        await _launchURL(item.url);
      },
    );
  }
}