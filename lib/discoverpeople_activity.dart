import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;
import 'main_activity.dart';
import 'dart:convert';
import 'userprofile.dart';
import 'profile_activity.dart';

class DiscoverPeopleActivity extends StatefulWidget{
  static final String route = Constants.route_DiscoverPeopleActivity;

  @override
  _DiscoverPeopleActivityState createState() => _DiscoverPeopleActivityState();
}

class _DiscoverPeopleActivityState extends State<DiscoverPeopleActivity>{

  Future<http.Response> response;
  List<UserProfile> people;

  Future<http.Response> discoverPeople() async{
    return http.post(Constants.url_discoverPeople, body: {
      Constants.getCode("uUsername") : MainActivity.myProfile.profileId,
    });
  }

  @override
  void initState(){
    super.initState();

    response = discoverPeople();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
            }
        ),
        title: Text(Strings.title_DiscoverPeopleActivity),
      ),

      body: Container(
        child: FutureBuilder(
            future: response,
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

                      people = new List();

                      final list = jsonDecode(result.body);
                      list.forEach((user){
                        UserProfile temp = new UserProfile();
                        temp.profileId = user;
                        people.add(temp);
                      });


                      return Container(
                        padding: EdgeInsets.all(30.0),
                        child: ListView.builder(
                            itemCount: people.length,
                            itemBuilder: (context, position){
                              return Container(
                                padding: EdgeInsets.only(bottom: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GestureDetector(
                                      child: Text(
                                        people[position].profileId,
                                        style: TextStyle(
                                          fontSize: 18.0
                                        ),
                                      ),
                                      onTap: (){
                                        Navigator.pushNamed(context, ProfileActivity.route, arguments: people[position].profileId);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
                        ),
                      );
                    }
                }
              }
            }
        ),
      ),
    );
  }
}