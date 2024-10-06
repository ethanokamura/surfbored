import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// constants
const double defaultPadding = 10;
const double defaultSpacing = 10;
const double defaultRadius = 5;
const BorderRadius defaultBorderRadius =
    BorderRadius.all(Radius.circular(defaultRadius));
const String defaultDarkImage = AppStrings.darkModeIcon;
const String defaultLightImage = AppStrings.lightModeIcon;

class DateFormatter {
  static String formatTimestamp(DateTime dateTime) {
    // Convert Timestamp to DateTime
    // final dateTime = timestamp.toDate();

    // Define the format
    final dateFormat = DateFormat('MMMM dd, yyyy');

    // Format the DateTime to a String
    return dateFormat.format(dateTime);
  }
}

class AppStrings {
  static const String appTitle = 'SurfBored';
  static const String darkModeIcon = 'assets/images/dark_mode_face.png';
  static const String lightModeIcon = 'assets/images/light_mode_face.png';

  // auth
  static const String searchText = 'Search for something new';
  static const String createPage = 'Create Something!';
  static const String isPublic = 'Public';
  static const String isPrivate = 'Private';
  static const String emptyTags = 'No tags yet!';

  // auth error
  static const String phoneNumberPrompt = 'Enter phone number.';
  static const String invalidPhoneNumber = 'Invalid phone number.';
  static const String otpPrompt = 'Enter OTP.';
  static const String invalidOtp = 'Invalid OTP.';

  static const String authFailure = 'Failure to authenticate.';
  static const String unknownFailure = 'Unknown failure occured';
  static const String phoneSignInFailureMessage =
      'Failed signing in with phone.';
  static const logOut = 'Logout';

  // pages
  static const String inbox = 'Inbox';
  static const String userSettings = 'User Settings';
  static const String pageNotFoundTitle = 'Error 404';
  static const String pageNotFound = 'Page Not Found.';

  // buttons
  static const String share = 'Share';
  static const String shuffle = 'Shuffle';
  static const String goBack = 'Return';
  static const String shuffledPosts = 'Shuffled Posts';
  static const String create = 'Create';
  static const String signIn = 'Sign In';
  static const String sendCode = 'Send Code';
  static const String confirm = 'Confirm';
  static const String edit = 'Edit';
  static const String delete = 'Delete';
  static const String last = 'Last';
  static const String next = 'Next';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String enterField = 'Enter new';
  static const String darkMode = 'Dark Mode';
  static const String lightMode = 'Light Mode';

  // images
  static const String selectMedia = 'Select Media';
  static const String camera = 'Camera';
  static const String photoLibrary = 'Library';

  // tags
  static const String addTags = 'Add Tags';
  static const String editTags = 'Edit Tags';
  static const String addTag = 'Add Tag';

  // numbers
  static const String saves = 'saves';
  static const String friends = 'friends';

  // general data
  static const String createSuccess = 'Successfully created!';
  static const String fetchFailure = 'Something went wrong.';

  // misc
  static const String theme = 'Theme';
  static const String nullData = 'Unable to get data.';

  // user
  static const String createUsername = 'Create Username';
  static const String username = 'Username';
  static const String editProfile = 'Edit Profile';
  static const String toggleBlock = 'Block/Unblock';
  static const String interests = 'interests';
  static const String aboutMe = 'about me';
  static const String joined = 'joined';
  static const String emptyFriends = 'No friends yet!';

  // friends
  static const String noFriendRequests = 'No friend requests';
  static const String myFriends = 'My Friends';
  static const String friendRequestSent = 'Request Sent';
  static const String acceptFriendRequest = 'Accept Request';
  static const String removeFriend = 'Remove Friend';
  static const String addFriend = 'Add Friend';
  static const String loadingFriends = 'Loading Friends';

  // posts
  static const String editPost = 'Edit Post';
  static const String emptyPost = 'No post found';
  static const String emptyPosts = 'No posts found';
  static const String deletePost = 'Delete post';
  static const String updatedPost = 'Post was updated successfully!';
  static const String changedPosts = 'Posts were changed. Reloading!';
  static const String addOrRemove = 'Add or remove';

  // comments
  static const String emptyComments = 'Be the first to leave a comment!';

  // boards
  static const String editBoard = 'Edit Board';
  static const String emptyBoards = 'No boards found';
  static const String deleteBoard = 'Delete Board';
  static const String updatedBoard = 'Board was updated successfully!';
  static const String changedBoards = 'Boards were changed. Reloading!';
  static const String deletedBoard = 'Board was deleted.';
  static const String addActivity = 'Add Activity To A Board';
}
