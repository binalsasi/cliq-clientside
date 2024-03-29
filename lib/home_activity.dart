/*
*
*   The home page (after loading/registration)
*   This page contains the two sliding tabs - feeds and user posts pages.
*
 */

import 'package:flutter/material.dart';
import 'upload_image_activity.dart';
import 'userhome_activity.dart';
import 'userfeed_activity.dart';
import 'requests_activity.dart';
import 'usersearch_activity.dart';
import 'discoverpeople_activity.dart';

import 'constants.dart';

class HomeActivity extends StatefulWidget {
  static final String route = Constants.route_HomeActivity;
  static bool photoPosted = false;

  @override
  _HomeActivityState createState() => _HomeActivityState();
}

class _HomeActivityState extends State<HomeActivity> with AutomaticKeepAliveClientMixin{
  bool wantKeepAlive = true;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  // goto the UploadImageActivity
  void uploadPhoto() async {
    Navigator.pushNamed(context, UploadImageActivity.route, arguments: scaffoldKey);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          key: scaffoldKey,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.white,
              child: IconTheme(
                  data: IconThemeData(
                    color: Colors.black87,
                  ),
                  child: Icon(Icons.add_a_photo)),
              onPressed: () {
                uploadPhoto();
              }),
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.person_add),
                onPressed: (){
                  Navigator.pushNamed(context, RequestsActivity.route);
                },
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: (){
                  Navigator.pushNamed(context, UserSearchActivity.route);
                },
              ),
              IconButton(
                icon: Icon(Icons.accessibility_new),
                onPressed: (){
                  Navigator.pushNamed(context, DiscoverPeopleActivity.route);
                },
              )
            ],
            title: Text(Strings.title_HomeActivity),
          ),
          body: TabBarView(children: [
            Container(
              child: UserFeedActivity(),
            ),
            Container(
              child: UserHomeActivity(),
            ),
          ]),
          bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            color: Colors.white,
            child: TabBar(
              indicatorColor: Colors.red,
              tabs: <Widget>[
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(Icons.home),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(Icons.account_circle),
                ),
              ],
            ),
          ),
        ));
  }
}


