/*
  Constants class

  - for central handling of keys
  - for internal functioning
*/
class Constants{
  static final String spref_username = "usernamex1";
  static final String spref_key      = "key";

  //static final String hostname = "https://zinc-advice-242819.appspot.com";
  static final String hostname = "http://192.168.0.133:8000";

  static final String url_fetchCodeBase       = hostname + "/cliq_backend/fetch_code_base";
  static final String url_registration        = hostname + "/cliq_backend/register";
  static final String url_imageUpload         = hostname + "/cliq_backend/image_upload";
  static final String url_fetchHome           = hostname + "/cliq_backend/fetch_home";
  static final String url_fetchFeeds          = hostname + "/cliq_backend/fetch_feeds";
  static final String url_fetchPost           = hostname + "/cliq_backend/fetch_post";
  static final String url_fetchProfile        = hostname + "/cliq_backend/fetch_profile";
  static final String url_followRequest       = hostname + "/cliq_backend/follow_request";
  static final String url_unfollowRequest     = hostname + "/cliq_backend/unfollow_request";
  static final String url_getFollowers        = hostname + "/cliq_backend/get_followers_list";
  static final String url_getFollowings       = hostname + "/cliq_backend/get_followings_list";
  static final String url_fetchRequests       = hostname + "/cliq_backend/fetch_requests";
  static final String url_followRequestAction = hostname + "/cliq_backend/follow_request_action";
  static final String url_searchUsername      = hostname + "/cliq_backend/search_username";

  static dynamic codebase;
  static dynamic defaultCodeBase = {
    "uUsername": "username",
    "uProfileId": "profileId",
    "ecode_noSuchUser": "E:0x80004",
    "ecode_noFollowers": "E:0x80008",
    "ecode_notPost": "E:0x90001",
    "dFollowStatus": "status",
    "dFollower": "follower",
    "dFollowee": "followee",
    "uTimestamp": "timestamp",
    "ecode_noFeeds": "E:0x80003",
  };

  static void setCodeBase(dynamic codes){
    codebase = codes;
  }

  static String getCode(String type){

    if(codebase == null)
      return defaultCodeBase[type];

    return codebase[type];
  }

  static final String route_MainActivity = "/";
  static final String route_RegistrationActivity = "/RegistrationActivity";
  static final String route_HomeActivity = "/HomeActivity";
  static final String route_UploadImageActivity = "/HomeActivity/UploadImageActivity";
  static final String route_FinalizePhotoActivity = "/HomeActivity/UploadImageActivity/FinalizePhoto";
  static final String route_PostDetailsActivity = "/HomeActivity/PostDetailsActivity";
  static final String route_ProfileActivity = "/HomeActivity/ProfileActivity";
  static final String route_RequestsActivity = "/HomeActivity/RequestsActivity";
  static final String route_UserSearchActivity = "/HomeActivity/UserSearchActivity";

  static final String image_selectImage = "assets/images/select_image.png";
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
  static final String title_PostDetails = "Post Details";
  static final String title_RequestsActivity = "Follow Requests you've got";
  static final String title_UserSearchActivity = "Search Users";

  static final String str_signup = "Sign Up";
  static final String str_tryPhotoUploadAgain = "There was an error while posting the photo. Try again?";
  static final String str_post = "Post";
  static final String str_photoPosted = "Photo posted!";

  static final String str_errorWhileFetchingHome = "There was an error while fetching home";
  static final String str_noHomeFeeds = "You have not uploaded anything yet";
  static final String str_noFeeds = "There is no feed to show";
  static final String str_noSuchPost = "We couldn't find the post you were looking for";
  static final String str_noSuchUser = "We couldn't find the user you were looking for";
  static final String str_unableToFollow = "We couldn't process your follow request at the moment.";
  static final String str_notFollowed = "You are not following this user";
  static final String str_alreadyFollowed = "You are already following this user";
  static final String str_notPost = "Something went wrong. No data was found / invalid request.";
}