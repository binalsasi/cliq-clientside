/*
*
*   UserSearchActivity is the page for searching for users.
*
 */

import 'package:flutter/material.dart';
import 'constants.dart';
import 'userprofile.dart';
import 'profile_activity.dart';
import 'package:http/http.dart' as http;
import 'main_activity.dart';
import 'dart:convert';

class UserSearchActivity extends StatefulWidget{
  static final String route = Constants.route_UserSearchActivity;

  @override
  _UserSearchActivityState createState() => _UserSearchActivityState();
}

class _UserSearchActivityState extends State<UserSearchActivity>{
  TextEditingController searchBox = new TextEditingController();

  List<UserProfile> results;

  // send username to server to search
  // returns a list of usernames
  // set the returned list of usernames to `results`.
  void searchUsername(String username) async{
    http.post(Constants.url_searchUsername, body: {
      Constants.getCode("uUsername") : MainActivity.myProfile.profileId,
      Constants.getCode("uProfileId") : username,
    }).then((response){
      print('response of search');
      print(response);

      // handle errors.

      final listjson = jsonDecode(response.body);
      print('list json');
      print(listjson);

      List<UserProfile> searchlist = new List();

      listjson.forEach((result){
        UserProfile profile = new UserProfile();
        profile.profileId = result;
        searchlist.add(profile);
      });

      setState(() {
        results = searchlist;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.title_UserSearchActivity),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
            }
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text("Enter Username to search"),
            ),

            Row(
              children: <Widget>[
                Container(
                  child: Flexible(
                    child: TextFormField(
                      controller: searchBox,
                    ),
                  )
                ),

                Container(
                  child: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: (){
                        searchUsername(searchBox.text);
                      }
                  ),
                )
              ],
            ),

            // if the results variable is not initialized (not searched for anything)
            (results == null) ?
            Container(
              child: Text("Search something"),
            )
                :
            (
                // if results is initialised but no results, then no search results.
                (results.length == 0) ?
                    Container(
                      child: Text("0 search results found"),
                    )
                :

            // if there are search results
            SizedBox(
              height: MediaQuery.of(context).size.height*0.5,
              child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, position){
                    return Container(
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          child: Text(results[position].profileId),
                          onTap: (){
                            Navigator.pushNamed(context, ProfileActivity.route, arguments: results[position].profileId);
                          },
                        ),
                      ],
                    ),
                  );
                  }
              ),
            )

            )

          ],
        ),

      ),

    );
  }
}