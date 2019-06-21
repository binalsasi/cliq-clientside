/*
*
*   PostDetailsActivity shows details of post
*
 */

import 'package:flutter/material.dart';
import 'constants.dart';
import 'feed_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'feed_widget.dart';

class PostDetailsActivity extends StatefulWidget{
  static final String route = Constants.route_PostDetailsActivity;

  @override
  _PostDetailsActivityState createState() => _PostDetailsActivityState();
}

class _PostDetailsActivityState extends State<PostDetailsActivity>{
  String _pid;
  Future<FeedItem> _item;

  // fetch post details and set in the `_item` variable
  Future<FeedItem> _fetchItem() async{
    final response = await http.post(Constants.url_fetchPost, body: {
      Constants.getCode("uPostId") : _pid,
    });

    print(response.body);

    if(response.body == Constants.getCode("ecode_noSuchPost")){
      // no such post exists
      return null;
    }

    try{

      final json = jsonDecode(response.body);
      FeedItem item = FeedItem.fromJson(json);
      return item;

    } on FormatException catch(e){
      // invalid json
      print("Post JSON was invalid. Exception : " + e.toString());
    }

    return null;
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _pid = ModalRoute.of(context).settings.arguments;
    _item = _fetchItem();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
            }
        ),
        title: Text(Strings.title_PostDetails),
      ),
      body: new FutureBuilder(
          future: _item,
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if (!snapshot.hasData) {
              return new Center(child:CircularProgressIndicator());
            } else {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Center(child:CircularProgressIndicator());
                default:
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  else {
                    FeedItem item = snapshot.data;
                    if(item == null){
                      return Text(Strings.str_noSuchPost);
                    }

                    // display the details as a FeedWidget item
                    return ListView(
                      children: <Widget>[
                        FeedWidget(item: item)
                      ],
                    );
                  }
              }
            }

          }
      ),
    );
  }
}