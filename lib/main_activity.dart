import 'package:flutter/material.dart';
import 'dart:async';
import 'registration_activity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_activity.dart';
import 'constants.dart';
import 'profile_activity.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'userprofile.dart';

/*
  MainActivity, where app functionality starts.

  - checks for registration in the shared prefs
  - sends user to registration page for registration
  - loads the home page if registered or already registered

 */
class MainActivity extends StatefulWidget{
  static final String route = Constants.route_MainActivity;

  // the user object
  // it contains the details of the user
  static UserProfile myProfile = new UserProfile();

  // get code base
  Future<http.Response> getCodes() async{
    return http.post(Constants.url_fetchCodeBase);
  }


  // get list of followers and update user object
  static void getFollowers() async{
    http.post(Constants.url_getFollowers, body: {
      Constants.getCode("uUsername") : MainActivity.myProfile.profileId,
      Constants.getCode("uProfileId"): MainActivity.myProfile.profileId,
    }).then((response){
      print(response.body);
      if(response.body == Constants.getCode("ecode_noSuchUser")){
        // do nothing?
      }
      else if(response.body == Constants.getCode("ecode_noFollowers")){
        // do nothing?
      }
      else if(response.body == Constants.getCode("ecode_notPost")){
        // do nothing?
      }
      else{
        final list = jsonDecode(response.body);

        list.forEach((item){
          UserProfile aProfile = new UserProfile();
          aProfile.followStatus = item[Constants.getCode("dFollowStatus")];
          aProfile.profileId    = item[Constants.getCode("dFollower")];
          MainActivity.myProfile.addFollower(aProfile);
        });
      }
    });
  }

  // get list of followings and add to user object
  static void getFollowings() async{
    http.post(Constants.url_getFollowings, body: {
      Constants.getCode("uUsername") : MainActivity.myProfile.profileId,
      Constants.getCode("uProfileId"): MainActivity.myProfile.profileId,
    }).then((response){
      print(response.body);
      if(response.body == Constants.getCode("ecode_noSuchUser")){
        // do nothing?
      }
      else if(response.body == Constants.getCode("ecode_noFollowers")){
        // do nothing?
      }
      else if(response.body == Constants.getCode("ecode_notPost")){
        // do nothing?
      }
      else{
        final list = jsonDecode(response.body);

        list.forEach((item){
          UserProfile aProfile = new UserProfile();
          aProfile.followStatus = item[Constants.getCode("dFollowStatus")];
          aProfile.profileId    = item[Constants.getCode("dFollowee")];
          MainActivity.myProfile.addFollowing(aProfile);
        });
      }
    });
  }

  @override
  _MainActivityState createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity>{

  // check if user is registered. if not goto RegistrationActivity
  Future<Null> checkUser() async{
    SharedPreferences.getInstance().then((pref){
      String username = pref.get(Constants.spref_username);
      int key         = pref.getInt(Constants.spref_key);

      if(username == null || username == ""){
        Navigator.pushReplacementNamed(context, RegistrationActivity.route);
      }
      else{
        MainActivity.myProfile.profileId = username;
        MainActivity.myProfile.ukey = key;
        MainActivity.getFollowers();
        MainActivity.getFollowings();
      }
    });
  }

  Future<http.Response> codeStatus;

  @override
  void initState(){
    super.initState();
    codeStatus = widget.getCodes();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: codeStatus,
      builder: (BuildContext context, AsyncSnapshot snapshot){

        if (!snapshot.hasData) {
          return new CircularProgressIndicator();
        } else {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return new CircularProgressIndicator();
            default:
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else {
                http.Response result = snapshot.data;
                print("DDDDD");
                print(result.body);
                if(result.body == "E:0x80004")
                  return Center(
                    child: Text("404x Profile Not Found"),
                  );

                final codeJson = jsonDecode(result.body);
                Constants.setCodeBase(codeJson);

                return HomeActivity();
              }
          }
        }
      },
    );
  }
}
