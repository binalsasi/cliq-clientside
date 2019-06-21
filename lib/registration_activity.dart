/*
*
*   RegistrationActivity is the registration page
*   TODO add google sign in authentication
*   TODO fix the google_sign_in , image_picker dependency conflict
*   this conflict is the reason I couldn't integrate google_sign_in.
*   This caused, dex archive merge error.
*
 */

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'main_activity.dart';
import 'home_activity.dart';
import 'constants.dart';

class RegistrationActivity extends StatefulWidget {
  static String route = Constants.route_RegistrationActivity;
  @override
  _RegistrationActivity createState() => _RegistrationActivity();
}

class _RegistrationActivity extends State<RegistrationActivity> {
  final usernameController = TextEditingController();

  void signup() async{
    String username = usernameController.text;

    // send username to server,
    // on success save username, and the key to shared preferences.
    http.post(Constants.url_registration, body: {
      Constants.getCode("uUsername")  : username,
    }).then((res) async{
      print(res.statusCode);
      if(res.statusCode == 200) {
        final body = json.decode(res.body);
        String user1 = body[Constants.getCode("dUsername")];
        int lk1   = body[Constants.getCode("dKey")];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(Constants.spref_username, user1);
        prefs.setInt(Constants.spref_key, lk1);

        MainActivity.myProfile.profileId = user1;
        MainActivity.myProfile.ukey = lk1;

        Navigator.pushReplacementNamed(context, HomeActivity.route);
      }
    }).catchError((err) {
      print(err);
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.title_RegistrationActivity),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
         // Image.asset("assets/image/logo"),
          Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text(
                  Strings.str_signup,
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
                TextFormField(
                  controller: usernameController,
                  //TODO check for invalid characters
                ),
                RaisedButton(
                  child: Text(Strings.str_signup),
                  onPressed: signup,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}