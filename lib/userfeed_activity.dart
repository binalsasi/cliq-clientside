import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'feed_item.dart';
import 'constants.dart';
import 'main_activity.dart';
import 'dart:convert';
import 'feed_widget.dart';

class UserFeedActivity extends StatefulWidget {
  @override
  _UserFeedActivityState createState() => _UserFeedActivityState();
}

class _UserFeedActivityState extends State<UserFeedActivity> with AutomaticKeepAliveClientMixin{
  bool wantKeepAlive = true;
  List<FeedItem> feeds;
  final GlobalKey<RefreshIndicatorState> feedRefreshKey = new GlobalKey<RefreshIndicatorState>();


  Future<List<FeedItem>> fetchMyFeeds(String timestamp) async {
    if(timestamp == null)
      timestamp = "null";

    print("username" + Constants.getCode("uUsername"));
    print("timesatmp" + Constants.getCode("uTimestamp"));

    final response = await http.post(Constants.url_fetchFeeds, body: {
      Constants.getCode("uUsername") : MainActivity.myProfile.profileId,
      Constants.getCode("uTimestamp") : timestamp,
    });

    print("REEESS");
    print(response.body);

    if(response.body == Constants.getCode("ecode_noFeeds")){
      // No feed to show. : do something
      return null;
    }

    try{
      final json = jsonDecode(response.body);
      print(json);


    print("dpostid " + Constants.getCode("dPostId"));
      print("dpath " + Constants.getCode("dPath"));
      print("ddesc " + Constants.getCode("dDescription"));
      print("duser " + Constants.getCode("dUsername"));
      print("db64s " + Constants.getCode("dBase64String"));
      print("db64s " + Constants.getCode("dBase64String"));
      print("dtime " + Constants.getCode("dTimestamp"));

      List<FeedItem> _feeds = new List();
      json.forEach((s) => _feeds.add(FeedItem.fromJson(s)));

      return _feeds;

    } on FormatException catch(e){
      // not json string.
      print('UserFeed data was not JSON. Exception : ' + e.toString());
      print(response.body);
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => feedRefreshKey.currentState.show());
  }

  Future<Null> _refresh(){
    return fetchMyFeeds(null).then((listOfItems){
      setState((){
        if(feeds == null)
          feeds = listOfItems;
        else
          feeds.addAll(listOfItems);
      });
    });
  }

  void fetchMore(String timestamp){
    fetchMyFeeds(timestamp).then((listOfItems){
      setState((){
        if(listOfItems != null) {
          if (feeds == null)
            feeds = listOfItems;
          else
            feeds.addAll(listOfItems);
        }
        else{
          Scaffold.of(context).showSnackBar(new SnackBar(content: Text("No more feeds to show")));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(5.0),
      child: RefreshIndicator(
          key: feedRefreshKey,
          onRefresh: _refresh,
          child: feeds == null ?
              ListView(
                  children: [
                    Center(
                      child: Container(
                        child: Text(Strings.str_noFeeds),
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(top:50.0),
                      ),
                    )
                  ]
              ) :
              ListView.builder(
                itemCount: feeds.length + 1,
                itemBuilder: (context, position){
                  if(position == feeds.length)
                    return Container(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: FetchMoreWidget(item : feeds[position - 1], fetchMore: fetchMore,),
                    );
                  else
                    return FeedWidget(item : feeds[position]);
                }
              ),

      ),
    );
  }
}

class FetchMoreWidget extends StatelessWidget{
  FeedItem item;
  Function fetchMore;

  FetchMoreWidget({Key key, this.item, this.fetchMore}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Center(
        child: RaisedButton(
          child: Text("Show More"),
            onPressed: () {
              fetchMore(item.timestamp);
            }
    ),
    ),
    );
    }

}

