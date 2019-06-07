import 'package:flutter/material.dart';

import 'upload_image_activity.dart';
import 'registration_activity.dart';
import 'main_activity.dart';
import 'home_activity.dart';
import 'finalize_photo_activity.dart';
import 'postdetails_activity.dart';
import 'constants.dart';


void main() => runApp(MyApp());


/*
    MyApp is where this application starts.

    Initially user arrives at MainActivity where shared preferences is checked
    for initial registration. If not registered, user is taken to the
    RegistrationActivity.

    Registration Activity is where user registers with server. After registration
    and saving of the username and key to the shared preferences, user returns to
    MainActivity, where HomeActivity is already loaded.

    HomeActivity is the home page. It consists of a two page tabbed user interface :
    one is the feeds and one is the user home page. The floating action button in
    the center can be clicked to get to the photo uploading page, which is the
    Upload Image Activity.

    The UploadImageActivity allows users to choose to either take a fresh photo for
    upload, or one from the android gallery. After selection user can proceed to
    finalize the photo with the FinalizePhotoActivity.

    The FinalizePhotoActivity asks for a short description for the photo. The button
    in the page allows the user to send the image to the server. On successful upload
    user returns to the home page, with a SnackBar saying "PhotoPosted".

    --(31-05-2019)
 */
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.title_App,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      initialRoute: MainActivity.route,
      routes: {
        MainActivity.route:          (context) => MainActivity(),
        HomeActivity.route:          (context) => HomeActivity(),
        UploadImageActivity.route:   (context) => UploadImageActivity(),
        RegistrationActivity.route:  (context) => RegistrationActivity(),
        FinalizePhotoActivity.route: (context) => FinalizePhotoActivity(),
        PostDetailsActivity.route:   (context) => PostDetailsActivity(),
      },
    );
  }
}
