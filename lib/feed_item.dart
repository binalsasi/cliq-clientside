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
      : pid = json[Constants.dPostId].toString(),
        path = json[Constants.dPath],
        description = json[Constants.dDescription],
        username = json[Constants.dUsername],
        b64string = json[Constants.dBase64String],
        imageBytes = base64Decode(json[Constants.dBase64String]),
        timestamp = json[Constants.dTimestamp];
}
