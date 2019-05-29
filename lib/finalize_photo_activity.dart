import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'main_activity.dart';
import 'constants.dart';

class FinalizePhotoActivity extends StatefulWidget {
  static String route = Constants.route_FinalizePhotoActivity;
  @override
  _FinalizePhotoActivityState createState() => _FinalizePhotoActivityState();
}

class _FinalizePhotoActivityState extends State<FinalizePhotoActivity> {
  File _selectedImage;

  @override
  Widget build(BuildContext context) {
    _selectedImage = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(Strings.title_FinalizePhotoActivity),
      ),
      body: FinalizePhotoForm(
        image: _selectedImage,
      ),
    );
  }
}

class FinalizePhotoForm extends StatefulWidget {
  File image;

  FinalizePhotoForm({Key key, this.image}) : super(key: key);

  @override
  _FinalizePhotoFormState createState() => _FinalizePhotoFormState();
}

class _FinalizePhotoFormState extends State<FinalizePhotoForm> {
  final _formkey = GlobalKey<FormState>();

  final descController = TextEditingController();

  bool _sendImage(){
    if(widget.image == null) return false;

    String base64Image = base64Encode(widget.image.readAsBytesSync());
    String description = descController.text;
    http.post(Constants.url_imageUpload, body: {
      Constants.imageUpload_uImage : base64Image,
      Constants.imageUpload_uDescription  : description,
      Constants.imageUpload_uUsername : MainActivity.username,
    }).then((res) {
      print(res.statusCode);
      if(res.statusCode == 200){
        Navigator.pop(context, true);
      }
      else{
        Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text(Strings.str_tryPhotoUploadAgain)
        ));
      }
      print(res.body);
    }).catchError((err) {
      print(err);
    });

  }

  @override
  void dispose(){
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Container(
          padding: EdgeInsets.all(40.0),
          child:
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width / 3,
                        child: Image.file(widget.image),
                      )
                    ],
                  ),
                  Flexible(
                    child: Theme(
                      data: ThemeData(
                        colorScheme: ColorScheme.dark(),
                      ),
                      child: TextFormField(
                        autofocus: true,
                        controller: descController,
                        validator: (value) {
                          return Constants.ok;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child:RaisedButton(
                        child: Text(Strings.str_post),
                        onPressed: (){
                          _sendImage();
                        },
                      )
                  ),
                ],
              )
            ],
          )
      ),
    );
  }
}
