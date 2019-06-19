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
                    ),
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
                        color: showComments ? Colors.green : Colors.white,
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[

                            Container(
                              child: Icon(Icons.comment),
                            ),
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
              showComments ?

              widget.item.comments == null ?
              Container(height: 0,width: 0,)
                  :
              Container(
                padding: EdgeInsets.all(10.0),
                color: Colors.white,
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
                color: Colors.white,
                child: createCommentColumn(),
              )

                  :
                  Container(height: 0, width: 0,),

              Container(
                color: Colors.white,
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextFormField(
                          controller: commentController,
                        ),
                      ),
                    ),
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

  Widget createCommentColumn(){
    List<Widget> children = new List();
    widget.item.comments.forEach((comment){
      children.add(Container(
        padding: EdgeInsets.all(10.0),
        child: CommentBox(comment: comment,),
      ));
    });

    return new Column(children: children,);
  }
}

class CommentBox extends StatelessWidget{
  CommentItem comment;

  CommentBox({Key key, this.comment}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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