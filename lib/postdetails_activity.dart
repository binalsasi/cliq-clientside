import 'package:flutter/material.dart';
import 'constants.dart';
import 'feed_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostDetailsActivity extends StatefulWidget{
  static final String route = Constants.route_PostDetailsActivity;

  @override
  _PostDetailsActivityState createState() => _PostDetailsActivityState();
}

class _PostDetailsActivityState extends State<PostDetailsActivity>{
  String _pid;
  Future<FeedItem> _item;

  Future<FeedItem> _fetchItem() async{
    final response = await http.post(Constants.url_fetchPost, body: {
      Constants.uPostId : _pid,
    });

    print(response.body);

    if(response.body == Constants.ecode_noSuchPost){
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

                    return FeedItemDetails(item: item);
                  }
              }
            }

          }
      ),
    );
  }
}

class FeedItemDetails extends StatelessWidget{
  FeedItem item;
  FeedItemDetails({Key key, this.item}) : super(key : key);

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
            //mainAxisAlignment: MainAxisAlignment.center,
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