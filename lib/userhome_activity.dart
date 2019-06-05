import 'package:flutter/material.dart';
import 'main_activity.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'feed_item.dart';

class UserHomeActivity extends StatefulWidget {

  @override
  _UserHomeActivityState createState() => _UserHomeActivityState();
}

class _UserHomeActivityState extends State<UserHomeActivity>{
  String _userHome;
  bool _homeLoading = true;
  
  Future<http.Response> ss;
  List<FeedItem> feeds;

  Future<http.Response> fetchMyHome() async{
      return http.post(Constants.url_fetchHome, body: {
        Constants.uUsername : MainActivity.username,
      });
  }

  @override
  void initState(){
    super.initState();
    ss = fetchMyHome();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16.0),
        child: new FutureBuilder(
            future: ss,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                  return new CircularProgressIndicator();
              } else {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting: return new CircularProgressIndicator();
                  default:
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    else {
                      http.Response result = snapshot.data;

                      if(result.body == "E:0x80003")
                        return Center(
                          child: Text("You have not uploaded anything yet"),
                        );

                      final user = jsonDecode(result.body);
                      //print(user);
                      List<FeedItem> feeds = new List();
                      user.forEach((s) => feeds.add(FeedItem.fromJson(s)));

                      return GridView.count(
                        crossAxisCount: 3,
                        children: List.generate(
                            feeds.length,
                                (index){
                              return GestureDetector(
                                onTap: (){
                                  Scaffold.of(context).showSnackBar(new SnackBar(content: Text("Description : "  + feeds[index].description)));
                                },
                                child: Container(
                                    padding: EdgeInsets.all(4.0),
                                    child: Image.memory(feeds[index].imageBytes)
                                ),
                              );
                            }
                        ),
                      );
                    }
                }
              }


            }
        )
    );
  }

}