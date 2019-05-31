import 'package:flutter/material.dart';
import 'main_activity.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;

class UserHomeActivity extends StatefulWidget {

  @override
  _UserHomeActivityState createState() => _UserHomeActivityState();
}

class _UserHomeActivityState extends State<UserHomeActivity>{
  String _userHome;
  bool _homeLoading = true;
  Future<String> ss;

  Future a() async{
  String a;
    http.post(Constants.url_fetchHome, body: {
      Constants.fetchHome_uUsername : MainActivity.username,
    }).then((res) {
      print(res.statusCode);
      if(res.statusCode == 200){
        a = res.body;
        setState(() {
          _homeLoading = false;
          _userHome = res.body;
        });
        print(a);
        return a;
      }
      else{
        Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text(Strings.str_errorWhileFetchingHome)
        ));
      }
      print(res.body);
    }).catchError((err) {
      print(err);
    });

  }

  void fetchMyHome() async{

      ss = await a();
      print('asd');
      print(ss);
  }

  @override
  void initState(){
    super.initState();
    fetchMyHome();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16.0),
        child: new FutureBuilder(
            future: a(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              /*
              if (snapshot.hasData) {
                if (snapshot.data!=null) {
                  return new Column (
                    children: <Widget>[
                      new Expanded(
                          child: new ListView(
                            children: _getData(snapshot),
                          ))
                    ],
                  );
                } else {
                  return new CircularProgressIndicator();
                }
              }
              */
              switch (snapshot.connectionState) {
                case ConnectionState.waiting: return new Text('Loading....');
             default:
                 if (snapshot.hasError)
                   return new Text('Error: ${snapshot.error}');
                 else
                   return new Text('Result: ${snapshot.data}');
              }

            }
        )
    );



  }

}
