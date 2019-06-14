import 'package:flutter/material.dart';
import 'main_activity.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'userprofile.dart';
import 'postdetails_activity.dart';
import 'profile_activity.dart';

class RequestsActivity extends StatefulWidget {
  static final String route = Constants.route_RequestsActivity;

  @override
  _RequestsActivityState createState() => _RequestsActivityState();
}

class _RequestsActivityState extends State<RequestsActivity> with AutomaticKeepAliveClientMixin{
  bool wantKeepAlive = true;

  Future<http.Response> ss;
  List<UserProfile> requests;

  Future<http.Response> fetchRequests() async{
    return http.post(Constants.url_fetchRequests, body: {
      Constants.uUsername : MainActivity.myProfile.profileId,
    });
  }

  @override
  void initState(){
    super.initState();
    ss = fetchRequests();
  }

  Future sendRequestAction(String profileId, String action) async{
    print("a");
    http.post(Constants.url_followRequestAction, body: {
      Constants.uUsername :  MainActivity.myProfile.profileId,
      Constants.uProfileId:  profileId,
      Constants.uAction:    action,
    }).then((response){
      print(response.body);
      if(response.body == "ok"){
        print("ad");
        print(requests);
        setState(() {
          for (int i = 0; i < requests.length; ++i) {
            if (requests[i].profileId == profileId) {
              requests.removeAt(i);
              break;
            }
          }
          ss = fetchRequests();
        });
        //Scaffold.of(context).showSnackBar(new SnackBar(content: Text(action + " successful")));
        return true;
      }
      else{
        //Scaffold.of(context).showSnackBar(new SnackBar(content: Text(action + " not successful")));
        return false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
            }
        ),
        title: Text(Strings.title_RequestsActivity),
      ),
      body: new FutureBuilder(
          future: ss,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
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

                    final rqlist = jsonDecode(result.body);
                    requests = new List();
                    rqlist.forEach((request){
                      UserProfile temp = new UserProfile();
                      temp.profileId = request[Constants.dFollower];
                      temp.followStatus = request[Constants.dFollowStatus];
                      requests.add(temp);
                    });


                    return ListView.builder(
                        itemCount: requests.length,
                        itemBuilder: (context, position){
                          return Container(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                GestureDetector(
                                  child: Text(requests[position].profileId),
                                  onTap: (){
                                    Navigator.pushNamed(context, ProfileActivity.route, arguments: requests[position].profileId);
                                  },
                                ),
                                Row(
                                  children: <Widget>[
                                    RaisedButton(
                                      child: Text("Accept"),
                                      onPressed: (){
                                        sendRequestAction(requests[position].profileId, "accept");
                                      },
                                    ),
                                    RaisedButton(
                                      child: Text("Decline"),
                                      onPressed: (){
                                        sendRequestAction(requests[position].profileId, "decline");
                                      },
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        }
                    );
                  }
              }
            }
          }
      ),
    );
  }
}
