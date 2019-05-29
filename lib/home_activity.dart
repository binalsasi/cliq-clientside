import 'package:flutter/material.dart';
import 'upload_image_activity.dart';
import 'constants.dart';


class HomeActivity extends StatefulWidget {
  static final String route = Constants.route_HomeActivity;
  static bool photoPosted = false;

  @override
  _HomeActivityState createState() => _HomeActivityState();
}

class _HomeActivityState extends State<HomeActivity> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  void uploadPhoto() async{
    final r = await Navigator.pushNamed(context, UploadImageActivity.route);
    if(r == true){
      scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text(Strings.str_photoPosted)
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: IconTheme(
              data: IconThemeData(
                color: Colors.black87,
              ),
              child: Icon(Icons.add_a_photo)
          ),
          onPressed: (){
            uploadPhoto();
          }
      ),
      appBar: AppBar(
        /*
              bottom: TabBar(tabs: [
              Tab(icon: Icon(Icons.account_box),),
              Tab(icon: Icon(Icons.add_a_photo),),
            ]),
            */
        title: Text(Strings.title_HomeActivity),
      ),
      body: TabBarView(
          children: [
            Container(
              color: Colors.red,
              child: Icon(Icons.calendar_today),
            ),
            Container(
              color: Colors.blue,
              child: Icon(Icons.add_a_photo),
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
              child: Icon(Icons.calendar_today),
            ),
            /*
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(Icons.add_a_photo),
                ),
                */
            Container(
              padding: EdgeInsets.all(10.0),
              child: Icon(Icons.account_box),
            ),
          ],
        ),
      ),
    );
  }
}
