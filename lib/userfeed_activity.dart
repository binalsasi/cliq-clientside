import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'feed_item.dart';
import 'constants.dart';
import 'main_activity.dart';
import 'dart:convert';
import 'postdetails_activity.dart';

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

    final response = await http.post(Constants.url_fetchFeeds, body: {
      Constants.uUsername: MainActivity.username,
      Constants.uTimestamp: timestamp,
    });

    print(response.body);

    if(response.body == Constants.ecode_noFeeds){
      // No feed to show. : do something
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
                    return MainFeedWidget(item : feeds[position]);
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


class MainFeedWidget extends StatelessWidget{
  FeedItem item;

  MainFeedWidget({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, PostDetailsActivity.route,arguments: item.pid);
      },
      child: Container(
          margin: EdgeInsets.only(bottom: 10.0),
          padding: EdgeInsets.all(10.0),
          child: Container(
            decoration: new BoxDecoration(
                border: new Border.all(color: Colors.white)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10.0),
                  color: Colors.white,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RichText(
                          text: new TextSpan(
                            text: item.username,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,

                            ),
                          )
                      )

                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                          height: MediaQuery.of(context).size.width*0.7,
                          width: MediaQuery.of(context).size.width*0.7,
                          child: SizedBox.expand(
                            child:Image.memory(item.imageBytes),
                          )
                      )
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(10.0),
                    color: Colors.white,
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(item.description),
                      ],
                    )
                ),
              ],
            ),
          )
      ),
    );
  }
}