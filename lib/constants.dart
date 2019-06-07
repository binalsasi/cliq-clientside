/*
  Constants class

  - for central handling of keys
  - for internal functioning
*/
class Constants{
  static final String spref_username = "username";
  static final String spref_key      = "key";

  static final String hostname = "https://zinc-advice-242819.appspot.com";

  static final String url_registration = hostname + "/cliq_backend/register";
  static final String url_imageUpload  = hostname + "/cliq_backend/image_upload";
  static final String url_fetchHome    = hostname + "/cliq_backend/fetch_home";
  static final String url_fetchFeeds   = hostname + "/cliq_backend/fetch_feeds";

  static final String uUsername = "username";
  static final String uImage = "image";
  static final String uDescription = "description";

  static final String dUsername = "username";
  static final String dKey      = "lastkey";
  static final String dPath = "path";
  static final String dDescription = "description";
  static final String dBase64String = "b64string";



  static final String route_MainActivity = "/";
  static final String route_RegistrationActivity = "/RegistrationActivity";
  static final String route_HomeActivity = "/HomeActivity";
  static final String route_UploadImageActivity = "/HomeActivity/UploadImageActivity";
  static final String route_FinalizePhotoActivity = "/HomeActivity/UploadImageActivity/FinalizePhoto";

  static final String image_selectImage = "assets/images/select_image.png";

  static final String ok = "ok";

  static final String ecode_noFeeds = "E:0x80003";
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
  static final String str_noHomeFeeds = "You have not uploaded anything yet";
  static final String str_noFeeds = "There is no feed to show";
}