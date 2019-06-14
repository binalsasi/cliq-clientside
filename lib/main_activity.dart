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

  static UserProfile myProfile = new UserProfile();


  static void getFollowers() async{
    http.post(Constants.url_getFollowers, body: {
      Constants.uUsername : MainActivity.myProfile.profileId,
      Constants.uProfileId: MainActivity.myProfile.profileId,
    }).then((response){
      print(response.body);
      if(response.body == Constants.ecode_noSuchUser){
        // do nothing?
      }
      else if(response.body == Constants.ecode_noFollowers){
        // do nothing?
      }
      else if(response.body == Constants.ecode_notPost){
        // do nothing?
      }
      else{
        final list = jsonDecode(response.body);

        list.forEach((item){
          UserProfile aProfile = new UserProfile();
          aProfile.followStatus = item[Constants.dFollowStatus];
          aProfile.profileId    = item[Constants.dFollower];
          MainActivity.myProfile.addFollower(aProfile);
        });
      }
    });
  }

  static void getFollowings() async{
    http.post(Constants.url_getFollowings, body: {
      Constants.uUsername : MainActivity.myProfile.profileId,
      Constants.uProfileId: MainActivity.myProfile.profileId,
    }).then((response){
      print(response.body);
      if(response.body == Constants.ecode_noSuchUser){
        // do nothing?
      }
      else if(response.body == Constants.ecode_noFollowers){
        // do nothing?
      }
      else if(response.body == Constants.ecode_notPost){
        // do nothing?
      }
      else{
        final list = jsonDecode(response.body);

        list.forEach((item){
          UserProfile aProfile = new UserProfile();
          aProfile.followStatus = item[Constants.dFollowStatus];
          aProfile.profileId    = item[Constants.dFollowee];
          MainActivity.myProfile.addFollowing(aProfile);
        });
      }
    });
  }

  @override
  _MainActivityState createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity>{

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



  @override
  void initState(){
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return HomeActivity();
  }
}
