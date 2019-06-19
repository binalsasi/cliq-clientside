import 'package:flutter/material.dart';
import 'profile_activity.dart';
import 'feed_item.dart';
import 'postdetails_activity.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'main_activity.dart';


class FeedWidget extends StatefulWidget {
  FeedItem item;

  FeedWidget({Key key, this.item}) : super(key: key);

  @override
  _FeedWidgetState createState() => _FeedWidgetState();

}

class _FeedWidgetState extends State<FeedWidget>{

  void likePost(String id, bool value) async{
    String url;
    if(value)
      url = Constants.url_likePost;
    else
      url = Constants.url_unlikePost;

    http.post(url, body: {
      Constants.getCode("uUsername") : MainActivity.myProfile.profileId,
      Constants.getCode("uPostId")   : widget.item.pid,
    }).then((response){
      final body = response.body;
      print(body);

      if(body == Constants.getCode("OK")){
        setState(() {
          widget.item.like(value);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("widget lke co " + widget.item.likeCount.toString());
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
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, ProfileActivity.route,arguments: widget.item.username);
                },
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  color: Colors.white,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RichText(
                          text: new TextSpan(
                            text: widget.item.username,
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
              ),
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, PostDetailsActivity.route,arguments: widget.item.pid);
                },
                child:Container(
                  padding: EdgeInsets.all(10.0),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                          height: MediaQuery.of(context).size.width*0.7,
                          width: MediaQuery.of(context).size.width*0.7,
                          child: SizedBox.expand(
                            child:Image.memory(widget.item.imageBytes),
                          )
                      )
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                          likePost(widget.item.pid, !widget.item.isLiked());
                      },
                      child: Container(
                        //color: widget.item.isLiked()? Colors.green : Colors.white,
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[

                            Container(
                              child: IconTheme(
                                data: IconThemeData(
                                  color: widget.item.isLiked()? Colors.green : Colors.black54,
                                ),
                                child: Icon(Icons.thumb_up),
                              ),
                            ),
                            Container(
                                child: Text(widget.item.likeCount.toString()),
                            )
                          ],
                        ),
                      ),
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
                      Text(widget.item.description),
                    ],
                  )
              ),
            ],
          ),
        )
    );
  }
}