import 'dart:convert';
import 'dart:typed_data';
import 'constants.dart';

class FeedItem{
  String pid;
  String path;
  String description;
  String username;
  String b64string;
  String timestamp;
  Uint8List imageBytes;

  FeedItem.fromJson(Map<String, dynamic> json)
      : pid = json[Constants.getCode("dPostId")].toString(),
        path = json[Constants.getCode("dPath")],
        description = json[Constants.getCode("dDescription")],
        username = json[Constants.getCode("dUsername")],
        b64string = json[Constants.getCode("dBase64String")],
        imageBytes = base64Decode(json[Constants.getCode("dBase64String")]),
        timestamp = json[Constants.getCode("dTimestamp")];
}
