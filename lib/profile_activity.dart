/*
*
*   ProfileActivity shows a user profile.
*   The users posts and the follow button.
*
 */
import 'package:flutter/material.dart';
import 'main_activity.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'userprofile.dart';
import 'postdetails_activity.dart';

class ProfileActivity extends StatefulWidget {
  static final String route = Constants.route_ProfileActivity;

  @override
  _ProfileActivityState createState() => _ProfileActivityState();
}

class _ProfileActivityState extends State<ProfileActivity> with AutomaticKeepAliveClientMixin{
  bool wantKeepAlive = true;
  bool privateUser = true;

  Future<http.Response> ss;
  UserProfile profile;

  Future<http.Response> fetchProfile(String username) async{
    return http.post(Constants.url_fetchProfile, body: {
      Constants.getCode("uUsername") : MainActivity.myProfile.profileId,
      Constants.getCode("uProfileId") : username,
    });
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profileId = ModalRoute.of(context).settings.arguments;
    ss = fetchProfile(profileId);
    UserProfile temp = MainActivity.myProfile.inFollowings(profileId);
    if(temp == null){
      buttonState = "none";
    }
    else if (temp.followStatus == "requested"){
      buttonState = "sent";
    }
    else if (temp.followStatus == "following"){
      buttonState = "following";
    }
    else{
      buttonState = "none";
    }

    return new Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
            }
        ),
        title: Text(profileId.toString()),
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

                    print(result.body);
                    print(Constants.getCode("ecode_notFollowing"));
                    if(result.body == Constants.getCode("ecode_notFollowing")) {
                      privateUser = true;
                      profile = new UserProfile();
                      profile.profileId = profileId;
                    }
                    else {
                      privateUser = false;

                      final user = jsonDecode(result.body);
                      print(user);

                      profile = UserProfile.fromJson(user);
                    }

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(20.0),
                          child:makeFollowButton(),
                        ),

                        privateUser ?
                            Center(
                              child: Text("This user is private. Send a follow request to see their posts"),
                            ) :
                        SizedBox(
                          height: MediaQuery.of(context).size.height*0.7,
                          child: GridView.count(
                            crossAxisCount: 3,
                            children: List.generate(
                                profile.imageList == null ? 0 : profile.imageList.length,
                                    (index){
                                  return GestureDetector(
                                    onTap: (){
                                      Navigator.pushNamed(context, PostDetailsActivity.route, arguments: profile.imageList[index].pid);
                                    },
                                    child: Container(
                                        padding: EdgeInsets.all(4.0),
                                        child: Image.memory(profile.imageList[index].imageBytes)
                                    ),
                                  );
                                }
                            ),
                          ),
                        )
                      ],
                    );
                  }
              }
            }
          }
      ),
    );
  }

  String buttonState = "none";

  // make correct button based on state
  Widget makeFollowButton(){
    print("makefollow button state " + buttonState);
    // TODO use enum
    if(buttonState == "sending"){
      return RaisedButton(
        child: Text("processing"),
      );
    }
    else if(buttonState == "sent"){
      return RaisedButton(
        child: Text("Request Sent"),
      );
    }
    else {
      print(MainActivity.myProfile.followers);
      if (buttonState == "none") {
        return new RaisedButton(
          child: Text("Follow"),
          onPressed: () {
            follow(true);
          },
        );
      }
      else if(buttonState == "following"){
        return new RaisedButton(
          child: Text("UnFollow"),
          onPressed: () {
            follow(false);
          },
        );
      }
    }
  }

  // send follow request to server (or unfollow)
  void follow(bool follow) async{
    setState(() {
      buttonState = "sending";
    });
    String url;
    if(follow)
      url = Constants.url_followRequest;
    else
      url = Constants.url_unfollowRequest;

    http.post(url, body: {
      Constants.getCode("uUsername") : MainActivity.myProfile.profileId,
      Constants.getCode("uFollowee") : profile.profileId,
    }).then((response){
      final body = response.body;
      if(body == Constants.getCode("ecode_noSuchUser")){
        Scaffold.of(context).showSnackBar(new SnackBar(content: Text(Strings.str_noSuchUser)));
      }
      else if(body == Constants.getCode("ecode_unableFollow")){
        Scaffold.of(context).showSnackBar(new SnackBar(content: Text(Strings.str_unableToFollow)));
      }
      else if(body == Constants.getCode("ecode_notFollowed")){
        Scaffold.of(context).showSnackBar(new SnackBar(content: Text(Strings.str_notFollowed)));
      }
      else if(body == Constants.getCode("ecode_alreadyFollow")){
        Scaffold.of(context).showSnackBar(new SnackBar(content: Text(Strings.str_alreadyFollowed)));
      }
      else if(body == Constants.getCode("ecode_notPost")){
        Scaffold.of(context).showSnackBar(new SnackBar(content: Text(Strings.str_notPost)));
      }
      else{
        setState(() {
          if(follow) {
            buttonState = "sent";
            profile.followStatus = "requested";
            MainActivity.myProfile.addFollowing(profile);
          }
          else {
            buttonState = "none";
            MainActivity.myProfile.removeFollowing(profile.profileId);
          }
        });
      }
    });
  }

}
