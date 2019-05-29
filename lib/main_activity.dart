import 'package:flutter/material.dart';
import 'dart:async';
import 'registration_activity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_activity.dart';
import 'constants.dart';

/*
  MainActivity, where app functionality starts.

  - checks for registration in the shared prefs
  - sends user to registration page for registration
  - loads the home page if registered or already registered

 */
class MainActivity extends StatefulWidget{
  static final String route = Constants.route_MainActivity;

  static String username;
  static int ukey;

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
        MainActivity.username = username;
        MainActivity.ukey = key;
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
    return DefaultTabController(
        length: 2,
        child: HomeActivity()
    );
  }
}
