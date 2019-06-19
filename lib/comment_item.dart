import 'package:flutter/material.dart';
import 'constants.dart';

class CommentItem{
  String commentId;
  String username;
  String comment;
  String timestamp;

  CommentItem.fromJson(Map<String, dynamic> json){
    commentId = json[Constants.getCode("dCommentId")].toString();
    username  = json[Constants.getCode("dUsername")];
    comment   = json[Constants.getCode("dText")];
    timestamp = json[Constants.getCode("dTimestamp")];
  }

  CommentItem({Key key, this.commentId, this.username, this.comment, this.timestamp});
}