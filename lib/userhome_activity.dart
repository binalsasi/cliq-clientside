import 'package:flutter/material.dart';
import 'main_activity.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'feed_item.dart';

class UserHomeActivity extends StatefulWidget {

  @override
  _UserHomeActivityState createState() => _UserHomeActivityState();
}

class _UserHomeActivityState extends State<UserHomeActivity>{
  List<FeedItem> _feeds;
  final GlobalKey<RefreshIndicatorState> _refreshKey = new GlobalKey<RefreshIndicatorState>();

  Future<List<FeedItem>> fetchMyHome() async{
      final response = await http.post(Constants.url_fetchHome, body: {
        Constants.uUsername : MainActivity.username,
      });

      print(response.body);

      if(response.body == Constants.ecode_noFeeds){
        // There was no item
        return null;
      }

      try{
        final json = jsonDecode(response.body);
        print(json);

        List<FeedItem> _feeds = new List();
        json.forEach((s) => _feeds.add(FeedItem.fromJson(s)));

        return _feeds;

      } on FormatException catch(e){
        // not json string.
        print('UserHome data was not JSON. Exception : ' + e.toString());
        print(response.body);
      }

      return null;
  }

  Future<Null> _refresh(){
    return fetchMyHome().then((listOfItems){
      setState(() {
        _feeds = listOfItems;
      });
    });
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16.0),
        child: RefreshIndicator(
            onRefresh: _refresh,
            key: _refreshKey,
            child: _feeds == null ?
              ListView(
                children: <Widget>[
                  Center(
                    child: Container(
                      child: Text(Strings.str_noHomeFeeds),
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top:50.0),
                    ),
                  )
                ],
              ) :
            GridView.count(
              crossAxisCount: 3,
              children: List.generate(
                  _feeds.length,
                      (index){
                    return GestureDetector(
                      onTap: (){
                        Scaffold.of(context).showSnackBar(new SnackBar(content: Text("Description : "  + _feeds[index].description)));
                      },
                      child: Container(
                          padding: EdgeInsets.all(4.0),
                          child: Image.memory(_feeds[index].imageBytes)
                      ),
                    );
                  }
              ),
            )
          ,
        ),
    );
  }

}