/*
  *
  *   FeedWidget is a widget that displays the details of a feed.
  *
 */


import 'package:flutter/material.dart';
import 'profile_activity.dart';
import 'feed_item.dart';
import 'postdetails_activity.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'main_activity.dart';
import 'dart:convert';
import 'comment_item.dart';


class FeedWidget extends StatefulWidget {
  FeedItem item;

  FeedWidget({Key key, this.item}) : super(key: key);

  @override
  _FeedWidgetState createState() => _FeedWidgetState();

}

class _FeedWidgetState extends State<FeedWidget>{
  TextEditingController commentController = new TextEditingController();
  bool showComments = false;

  // send like request to server (or unlike)
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

  // fetch comments and update the widget.item.comments
  void fetchComments(String postId) async{
    http.post(Constants.url_getComments, body: {
      Constants.getCode("uUsername") : MainActivity.myProfile.profileId,
      Constants.getCode("uPostId")   : postId,
    }).then((response){
      // check errors
      print("check comments");
      print(response.body);

      if(response.body == Constants.getCode("ecode_noComments")){
        widget.item.commentCount = 0;
      }
      else {
        final commentJson = jsonDecode(response.body);
        setState(() {
          widget.item.setComments(commentJson);
        });
      }
    });

  }

  // send comment to the server, update the widget.item.comments
  void sendComment(String postId, String comment) async{
    http.post(Constants.url_addComment, body: {
      Constants.getCode("uUsername") : MainActivity.myProfile.profileId,
      Constants.getCode("uPostId")   : postId,
      Constants.getCode("uText")     : comment,
    }).then((response){
      final body = response.body;
      print("add comment");
      print(body);
      setState(() {
          widget.item.addComment(body, MainActivity.myProfile.profileId, comment, "just now");
          Scaffold.of(context).showSnackBar(new SnackBar(content: Text("Comment Posted!")));
      });

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


              // username section
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

              // post image section
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

              // the like & comment button section
              Container(
                color: Colors.white70,
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[


                    // the like button
                    GestureDetector(
                      onTap: (){
                          likePost(widget.item.pid, !widget.item.isLiked());
                      },
                      child: Container(
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
                              margin: EdgeInsets.only(left: 10.0),
                                child: Text(widget.item.likeCount.toString()),
                            )
                          ],
                        ),
                      ),
                    ),


                    // the comments button
                    GestureDetector(
                      onTap: (){
                        if(showComments) {
                          setState(() {
                            showComments = false;
                          });
                        }
                        else {
                          fetchComments(widget.item.pid);
                          showComments = true;
                        }
                      },
                      child: Container(
                        color:  Colors.white,
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: IconTheme(
                                  data: IconThemeData(
                                    color: showComments ? Colors.green : Colors.black54,
                                  ),
                                  child: Icon(Icons.comment),
                              )
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),



              // the description section
              Container(
                  padding: EdgeInsets.all(15.0),
                  color: Colors.white,
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 10.0),
                        child: Text(
                          widget.item.username + " : ",
                          style: TextStyle(
                              fontSize: 17.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          widget.item.description,
                          style: TextStyle(
                              fontSize: 17.0,
                            fontStyle: FontStyle.italic
                          ),
                        ),
                      )
                    ],
                  )
              ),



              // the comments section. shown only if comment button is pressed
              showComments ?

              widget.item.comments == null ?
              Container(height: 0,width: 0,)
                  :
              Container(
                padding: EdgeInsets.all(10.0),
                color: Colors.black12,
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(widget.item.commentCount.toString() + " comments"),
                    ],
                  ),
              )

              :
                  Container(height: 0, width: 0,)
              ,

              showComments ?
              widget.item.comments == null ?
              Container(height: 0,width: 0,)
                  :
              Container(
                padding: EdgeInsets.all(10.0),
                color: Colors.black12,
                child: createCommentColumn(),
              )

                  :
                  Container(height: 0, width: 0,),

              // The comment input section
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[

                    // comment input
                    Container(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextFormField(
                          controller: commentController,
                        ),
                      ),
                    ),


                    // send button
                    Container(
                      child: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: (){
                            sendComment(widget.item.pid, commentController.text);
                          }
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
    );
  }

  // creates a comment section
  Widget createCommentColumn(){
    List<Widget> children = new List();
    widget.item.comments.forEach((comment){
      children.add(GestureDetector(
          onTap: (){
            Navigator.pushNamed(context, ProfileActivity.route,arguments: widget.item.username);
          },
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: CommentBox(comment: comment,),
          )
      ));
    });

    return new Column(children: children,);
  }
}


// comment widget. Displays the comment.
class CommentBox extends StatelessWidget{
  CommentItem comment;

  CommentBox({Key key, this.comment}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[


        // username of comment
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          margin: EdgeInsets.only(right: 20.0),
          child: Text(
            comment.username + " : ",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16.0
            ),
          ),
        ),


        // comment body
        Container(
          margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
          child: Text(
            comment.comment,
            style: TextStyle(
              color: Colors.black54,
              fontStyle: FontStyle.italic,
              fontSize: 16.0,

            ),
          ),
        ),


        // timestamp
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0 , top: 5.0),
              child: Text(
                comment.timestamp,
                style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                    fontSize: 12.0
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}