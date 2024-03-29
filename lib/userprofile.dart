/*
*
*   UserProfile class is a placeholder
*   for user profile.
*
 */
import 'feed_item.dart';
import 'constants.dart';


class UserProfile{
  String profileId;
  List<FeedItem> imageList;
  int imageCount;
  String followStatus;
  List<UserProfile> followers;
  List<UserProfile> followings;
  int follower_count;
  int following_count;
  int ukey;

  UserProfile.fromJson(Map<String, dynamic> json){
    profileId = json[Constants.getCode("dProfileId")];
    final imglist = json[Constants.getCode("dThumbs")];
    if(imglist == Constants.getCode("ecode_noFeeds")){
      imageList = null;
      imageCount = 0;
    }
    else{
      imageList = new List();
      imglist.forEach((imgdata){
        imageList.add(FeedItem.fromJson(imgdata));
      });

      imageCount = imageList.length;
    }
  }

  UserProfile(){
    profileId = "";
    imageList = new List();
    imageCount = 0;
    followers = new List();
    followings = new List();
    followStatus = "";
    follower_count = 0;
    following_count = 0;
    ukey = 0;
  }

  void addFollower(UserProfile profile){
    followers.add(profile);
    ++follower_count;
  }

  void addFollowing(UserProfile profile){
    followings.add(profile);
    ++following_count;
  }

  UserProfile inFollowers(String profileId){
    UserProfile found = null;
    for(int i = 0; i < followers.length; ++i){
      if(followers[i].profileId == profileId){
        found = followers[i];
        break;
      }

    }
    return found;
  }

  UserProfile inFollowings(String profileId){
    UserProfile found = null;
    for(int i = 0; i < followings.length; ++i){
      if(followings[i].profileId == profileId){
        found = followings[i];
        break;
      }

    }
    return found;
  }

  bool removeFollowing(String profileId){
    bool removed = false;
    for(int i = 0; i < followings.length; ++i){
      if(followings[i].profileId == profileId){
        followings.removeAt(i);
        removed = true;
        break;
      }
    }

    return removed;
  }

  bool removeFollower(String profileId){
    bool removed = false;
    for(int i = 0; i < followers.length; ++i){
      if(followers[i].profileId == profileId){
        followers.removeAt(i);
        removed = true;
        break;
      }
    }

    return removed;
  }
}