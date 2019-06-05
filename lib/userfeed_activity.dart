import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'feed_item.dart';
import 'constants.dart';
import 'main_activity.dart';
import 'dart:convert';

class UserFeedActivity extends StatefulWidget {
  @override
  _UserFeedActivityState createState() => _UserFeedActivityState();
}

class _UserFeedActivityState extends State<UserFeedActivity> {
  Future<http.Response> mainFeedsFuture;
  List<FeedItem> feeds;

  Future<http.Response> fetchMyFeeds() async {
    return http.post(Constants.url_fetchFeeds, body: {
      Constants.uUsername: MainActivity.username,
    });
  }

  @override
  void initState() {
    super.initState();
    mainFeedsFuture = fetchMyFeeds();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(5.0),
      child: new FutureBuilder(
          future: mainFeedsFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return new CircularProgressIndicator();
            } else {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new CircularProgressIndicator();
                default:
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  else {
                    http.Response result = snapshot.data;
                    if(result.body == "E:0x80003")
                      return Center(
                        child: Text("There is no feed to show"),
                      );

                    final json = jsonDecode(result.body);
                    print(json);
                    feeds = new List();
                    json.forEach((s) => feeds.add(FeedItem.fromJson(s)));

                    return ListView.builder(
                        itemCount: feeds.length,
                        itemBuilder: (context, position){
                          return MainFeedWidget(item : feeds[position]);
                        }
                    );
                  }
              }
            }
          }),
    );
  }
}


class MainFeedWidget extends StatelessWidget{
  FeedItem item;

  MainFeedWidget({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
        );
  }
}