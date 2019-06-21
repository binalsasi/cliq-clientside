/*
*
*   FeedItem place holder
*
 */

import 'dart:convert';
import 'dart:typed_data';
import 'constants.dart';
import 'userprofile.dart';
import 'main_activity.dart';
import 'comment_item.dart';

class FeedItem{
  String pid;
  String path;
  String description;
  String username;
  String b64string;
  String timestamp;
  Uint8List imageBytes;
  List<UserProfile> likes;
  bool liked = false;
  int likeCount = 0;
  List<CommentItem> comments;
  int commentCount = 0;

  FeedItem.fromJson(Map<String, dynamic> json){
    pid = json[Constants.getCode("dPostId")].toString();
    path = json[Constants.getCode("dPath")];
    description = json[Constants.getCode("dDescription")];
    username = json[Constants.getCode("dUsername")];
    b64string = json[Constants.getCode("dBase64String")];
    imageBytes = base64Decode(json[Constants.getCode("dBase64String")]);
    timestamp = json[Constants.getCode("dTimestamp")];
    final x = json[Constants.getCode("dLikes")];
    if(x != null && x != "") {
      likes = new List();
      x.forEach((user) {
        UserProfile a = new UserProfile();
        a.profileId = user;
        likes.add(a);

        if (user == MainActivity.myProfile.profileId)
          like(true);
      });

      print(
          "likes " + likeCount.toString() + "  len " + likes.length.toString());
      likeCount = likes.length;
    }
  }

  void setComments(final commentJson){
    if(comments == null)
        comments = new List();
    else
        comments.clear();

    commentJson.forEach((s) => comments.add(CommentItem.fromJson(s)));

    commentCount = comments.length;
  }

  void addComment(String commentId, String username, String comment, String timestamp){
    if(comments == null)
      comments = new List();
    CommentItem c = new CommentItem(commentId: commentId, username: username, comment: comment, timestamp: timestamp);
    comments.add(c);
    ++commentCount;
  }

  void like(bool val){
    liked = val;
    if(val)
      ++likeCount;
    else
      --likeCount;
  }

  bool isLiked(){
    return liked;
  }
}
