/*
  Constants class

  - for central handling of keys
  - for internal functioning
*/
class Constants{
  static final String spref_username = "username5";
  static final String spref_key      = "key";

  static final String url_registration = "http://192.168.0.112:8000/cliq_backend/register";
  static final String url_imageUpload  = "http://192.168.0.112:8000/cliq_backend/image_upload";
  static final String url_fetchHome    = "http://192.168.0.112:8000/cliq_backend/fetch_home";

  static final String registration_uUsername = "username";
  static final String registration_dUsername = "username";
  static final String registration_dKey      = "lastkey";

  static final String imageUpload_uImage = "image";
  static final String imageUpload_uDescription = "description";
  static final String imageUpload_uUsername = "username";

  static final String fetchHome_uUsername = "username";

  static final String route_MainActivity = "/";
  static final String route_RegistrationActivity = "/RegistrationActivity";
  static final String route_HomeActivity = "/HomeActivity";
  static final String route_UploadImageActivity = "/HomeActivity/UploadImageActivity";
  static final String route_FinalizePhotoActivity = "/HomeActivity/UploadImageActivity/FinalizePhoto";

  static final String image_selectImage = "assets/images/select_image.png";

  static final String ok = "ok";
}

/*
  Strings class

  - for localization
 */
class Strings{
  static final String title_App = "Cliq";
  static final String title_RegistrationActivity = "First Time Registration";
  static final String title_FinalizePhotoActivity = "Finalize Photo";
  static final String title_UploadImageActivity = "Post Photo";
  static final String title_HomeActivity = "Cliq";

  static final String str_signup = "Sign Up";
  static final String str_tryPhotoUploadAgain = "There was an error while posting the photo. Try again?";
  static final String str_post = "Post";
  static final String str_photoPosted = "Photo posted!";

  static final String str_errorWhileFetchingHome = "There was an error while fetching home";
}