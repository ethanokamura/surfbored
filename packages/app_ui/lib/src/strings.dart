/// TODO(Ethan): I18n
class AppStrings {
  static const String appTitle = 'SurfBored';
  static const String darkModeIcon = 'assets/images/dark_mode_face.png';
  static const String lightModeIcon = 'assets/images/light_mode_face.png';
  static const String theme = 'Theme';

  static const String myFriends = 'my friends';
  static const String boards = 'boards';
  static const String posts = 'posts';
  static const String board = 'board';
  static const String post = 'post';
  static const String saveChanges = 'save changes';
  static const String invalidChanges = 'invalid changes';
  static const String success = 'success';
  static const String next = 'continue';
  static const String skip = '(or skip)';
  static const String previous = 'back';

  // crud
  static const String create = 'Create';
  static const String update = 'Update';
  static const String edit = 'Edit';
  static const String delete = 'Delete';
}

/// new
class PageStrings {
  static const String explorePage = 'explore';
  static const String createPostPage = 'create a post';
  static const String createBoardPage = 'create a board';
  static const String settingsPage = 'settings';
  static const String editProfilePage = 'edit profile';
  static const String errorPage = 'uh oh...';
  static const String confirmCreatePage = "How's this look?";
}

class DataStrings {
  static const String loading = 'Loading';

  // failure
  static const String emptyFailure = 'Failure to retrieve data';
  static const String fromCreateFailure = 'Failure to create new post';
  static const String fromGetFailure = 'Failure to get data';
  static const String fromUpdateFailure = 'Failure to update data';
  static const String fromDeleteFailure = 'Failure to delete data';
  static const String fromUnknownFailure = 'Something went wrong.';

  static const String fromAddLikeFailure = 'Failure to like';
  static const String fromRemoveLikeFailure = 'Failure to unlike';
  static const String fromAddSaveFailure = 'Failure to save board';
  static const String fromRemoveSaveFailure = 'Failure to unsave board';

  // success
  static const String empty = 'No data found';
  static const String fromCreate = 'Successfully created';
  static const String fromGet = 'Successfully fetched';
  static const String fromUpdate = 'Successfully updated';
  static const String fromDelete = 'Successfully deleted';
}

class PromptStrings {
  static const String enter = 'Enter new';
  static const String search = 'Discover something new...';
}

class AppBarStrings {
  static const String shuffledPosts = 'Shuffled Posts';
  static const String inbox = 'Inbox';
  static const String create = 'Create Something';
  static const String addToBoard = 'Add To Your Boards';
}

class ButtonStrings {
  static const String darkMode = 'Dark Mode';
  static const String lightMode = 'Light Mode';
  static const String isPublic = 'Public';
  static const String isPrivate = 'Private';
  static const String addOrRemove = 'Add/Remove';
  static const String toggleBlock = 'Block/Unblock';

  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String share = 'Share';
  static const String create = 'Create';
  static const String update = 'Update';
  static const String edit = 'Edit';
  static const String delete = 'Delete';
  static const String confirm = 'Confirm';
  static const String continueText = 'Continue';
  static const String next = 'Next';
  static const String last = 'Last';
  static const String shuffle = 'Shuffle';
}

class UnknownStrings {
  static const String pageNotFoundTitle = 'Error 404';
  static const String pageNotFound = 'Page Not Found.';
  static const String empty = 'Data not found.';
}

class ImageStrings {
  static const String selectMedia = 'Select Media';
  static const String camera = 'Camera';
  static const String photoLibrary = 'Library';
}

class AuthStrings {
  // auth error
  static const String signIn = 'Sign in';
  static const String signInPrompt = 'Welcome to SurfBored 🥳';
  static const String phoneNumberPrompt = "What's your number?";
  static const String otpPrompt = 'Verify your number';
  static const String otpHint = '6 digit code';
  static const String invalidPhoneNumber = 'Invalid phone number.';
  static const String invalidOtp = 'Invalid OTP.';

  static const String authFailure = 'Failure to authenticate.';
  static const String unknownFailure = 'Unknown failure occured';
  static const String signInFailure = 'Failed to sign in.';
  static const String signOutFailure = 'Failed to sign out.';
  static const logOut = 'Logout';
}

class UserStrings {
  // user
  static const String createUsername = 'Create Username';
  static const String settings = 'User Settings';
  static const String editProfile = 'Edit Profile';
  static const String delete = 'Delete Profile';
  static const String username = 'username';
  static const String interests = 'interests';
  static const String joined = 'joined';
  static const String about = 'about me';
  static const String bio = 'bio';
  static const String displayName = 'name';
  static const String interestsPrompt = 'interests?';
  static const String failure = DataStrings.fromUnknownFailure;
}

class FriendStrings {
  // friends
  static const String addFriend = 'Add Friend';
  static const String acceptRequest = 'Accept Request';
  static const String requestSent = 'Request Sent';
  static const String removeFriend = 'Remove Friend';
  static const String noRequests = 'No friend requests';
  static const String myFriends = 'My Friends';
  static const String loadingFriends = 'Loading Friends';
  static const String empty = 'No friends yet!';
  static const String friends = 'friends';

  static const String toggleBlock = 'Block/Unblock';
  static const String failure = DataStrings.fromUnknownFailure;
}

class BoardStrings {
  // CRUD
  static const String create = 'Create Board';
  static const String edit = 'Edit Board';
  static const String delete = 'Delete Board';
  static const String empty = 'No boards yet!';
  static const String saves = 'saves';
  static const String failure = DataStrings.fromUnknownFailure;
}

class PostStrings {
  // CRUD
  static const String create = 'Create Post';
  static const String edit = 'Edit Post';
  static const String delete = 'Delete Post';
  static const String empty = 'No posts yet!';
  static const String failure = DataStrings.fromUnknownFailure;
}

class CreateStrings {
  static const String titlePrompt = 'What do you call it? 🤔';
  static const String descriptionPrompt = "What's it all about? 🧐";
  static const String linkPrompt = 'Any links? 🤓';
  static const String usernamePrompt = 'What should we call you? 🤠';
  static const String invalidUsername = 'Invalid username 💀';

  /// new
  static const String create = 'create something!';
  static const String createPost = 'create post';
  static const String createBoard = 'create board';
  static const String title = 'name?';
  static const String description = 'description?';
  static const String tagsPrompt = 'tags?';
  static const String interestsPrompt = 'interests?';
  static const String postFailure = 'failed to create post';
  static const String boardFailure = 'failed to create board';
  static const String unknownFailure = 'failure during creation';
  static const String imageUploadPrompt = "Show us what it's about";
}

class CommentStrings {
  // CRUD
  static const String create = 'Create Comment';
  static const String edit = 'Edit Comment';
  static const String delete = 'Delete Comment';
  static const String empty = 'Be the first to leave a comment!';
  static const String failure = DataStrings.fromUnknownFailure;
}

class TagStrings {
  // tags
  static const String create = 'Add Tags';
  static const String createSingle = 'Add Tag';
  static const String edit = 'Edit Tags';
  static const String empty = 'No tags yet!';
  static const String failure = DataStrings.fromUnknownFailure;
}
