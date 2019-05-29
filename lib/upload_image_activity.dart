import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'finalize_photo_activity.dart';
import 'constants.dart';

class UploadImageActivity extends StatefulWidget {
  static final String route = Constants.route_UploadImageActivity;
  @override
  _UploadImageActivityState createState() => _UploadImageActivityState();
}

class _UploadImageActivityState extends State<UploadImageActivity> {
  File _image;

  Future getImage(source) async {
    var image = await ImagePicker.pickImage(source: source);

    setState(() {
      _image = image;
    });
  }

  void finalizePhoto() async{
    final r = await Navigator.pushNamed(context, FinalizePhotoActivity.route, arguments: _image);
    Navigator.pop(context, r);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, false);
            }),
        title: Text(Strings.title_UploadImageActivity),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 0,
                height: 0,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width / 3,
                child: _image == null
                    ? Image.asset(Constants.image_selectImage)
                    : Image.file(_image),
              ),
              _image == null
                  ? Container(
                      width: 0,
                      height: 0,
                    )
                  : IconButton(
                      icon: Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                          finalizePhoto();
                      })
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                child: RaisedButton(
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Icon(Icons.add_a_photo),
                    ),
                    onPressed: () {
                      getImage(ImageSource.camera);
                    }),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: RaisedButton(
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Icon(Icons.photo_library),
                    ),
                    onPressed: () {
                      getImage(ImageSource.gallery);
                    }),
              ),
            ],
          )
        ],
      ),
    );
  }
}
