/*
*
*   FinalizePhotoActivity is where photo is finalized and sent to server
*   TODO make the upload function static, or move it to some static class
*   TODO as at the moment, the app hangs for a few moments until it is  uploaded
*
 */


import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'main_activity.dart';
import 'constants.dart';
import 'home_activity.dart';
import 'package:image/image.dart' as Img;

class FinalizePhotoActivity extends StatefulWidget {
  static String route = Constants.route_FinalizePhotoActivity;
  @override
  _FinalizePhotoActivityState createState() => _FinalizePhotoActivityState();
}


// PhotoArg class is used as a placeholder for passing data from the UploadImageActivity
class PhotoArg{
  File image;
  GlobalKey<ScaffoldState> scaffoldKey;

  PhotoArg({Key key, this.image, this.scaffoldKey});
}

class _FinalizePhotoActivityState extends State<FinalizePhotoActivity> {
  PhotoArg arg;

  @override
  Widget build(BuildContext context) {
    arg = ModalRoute.of(context).settings.arguments;

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
        arg: arg,
      ),
    );
  }
}

// The upload form
class FinalizePhotoForm extends StatefulWidget {
  PhotoArg arg;

  FinalizePhotoForm({Key key, this.arg}) : super(key: key);

  @override
  _FinalizePhotoFormState createState() => _FinalizePhotoFormState();
}

class _FinalizePhotoFormState extends State<FinalizePhotoForm> {
  final _formkey = GlobalKey<FormState>();

  final descController = TextEditingController();


  // send image, description to the server to finalize the post
  Future _sendImage() async{
    if(widget.arg.image == null) return false;

    final img = Img.decodeImage(widget.arg.image.readAsBytesSync());
    Img.Image cropped = Img.copyResizeCropSquare(img, 1024);

    String base64Image = base64Encode(Img.encodeJpg(cropped));

    //String base64Image = base64Encode(widget.image.readAsBytesSync());
    String description = descController.text;
    http.post(Constants.url_imageUpload, body: {
      Constants.getCode("uImage") : base64Image,
      Constants.getCode("uDescription")  : description,
      Constants.getCode("uUsername") : MainActivity.myProfile.profileId,
    }).then((res) {
      print(res.statusCode);
      if(res.statusCode == 200) {
        //   HomeActivity.photoUpload(true, "");
        widget.arg.scaffoldKey.currentState.showSnackBar(
            new SnackBar(content: new Text(Strings.str_photoPosted)));
      }
      else{
        widget.arg.scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(Strings.str_tryPhotoUploadAgain)));
      }
      debugPrint(res.body);
    }).catchError((err) {
      debugPrint(err);
      widget.arg.scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(Strings.str_tryPhotoUploadAgain)));
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
                        child: Image.file(widget.arg.image),
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
                        // TODO handle validation
                        validator: (value) {
                          return Constants.getCode("OK");
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
                        /*
                          When post button is presed,
                          navigate back to the home page,
                          while uploading in the background.
                          Finally show a snack bar containing the result
                          message.

                          At the moment this isn't working as expected.
                          The post button hangs until the photo is uploaded.
                          It could be because the _sendImage() is not static.
                          And thus needs an object of this class to remain
                          in memory for it to work. Which could explain why
                          the screen is not navigated back to the home page.

                         */
                        onPressed: (){
                          Navigator.pop(context);
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
