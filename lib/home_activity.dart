import 'package:flutter/material.dart';
import 'upload_image_activity.dart';
import 'userhome_activity.dart';
import 'userfeed_activity.dart';

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

  void uploadPhoto() async {
    final r = await Navigator.pushNamed(context, UploadImageActivity.route);
    if (r == true) {
      scaffoldKey.currentState.showSnackBar(
          new SnackBar(content: new Text(Strings.str_photoPosted)));
    }
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
            /*
              bottom: TabBar(tabs: [
              Tab(icon: Icon(Icons.account_box),),
              Tab(icon: Icon(Icons.add_a_photo),),
            ]),
            */
            title: Text(Strings.title_HomeActivity),
          ),
          body: TabBarView(children: [
            Container(
              //color: Colors.red,
              child: UserFeedActivity(),
            ),
            Container(
              //color: Colors.blue,
              /*
              child: Icon(Icons.add_a_photo),
              */
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


