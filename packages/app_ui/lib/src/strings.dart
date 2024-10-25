/// TODO(Ethan): I18n
class AppStrings {
  /// App
  static const String appTitle = 'SurfBored';
  static const String darkModeIcon = 'assets/images/dark_mode_face.png';
  static const String lightModeIcon = 'assets/images/light_mode_face.png';
  static const String lightMode = 'light mode';
  static const String darkMode = 'dark mode';

  /// Misc
  static const String board = 'board';
  static const String boards = 'boards';
  static const String post = 'post';
  static const String posts = 'posts';
  static const String errorPage = 'uh oh...';

  /// CRUD buttons
  static const String save = 'save';
  static const String next = 'continue';
  static const String public = 'public';
  static const String private = 'private';
  static const String invalid = 'invalid';
  static const String previous = 'back';
  static const String uploadImage = 'upload image';
  static const String share = 'share';
  static const String addOrRemove = 'add or remove';
  static const String edit = 'edit';
  static const String blockUser = 'block user';
  static const String unblockUser = 'unblock user';

  /// Failures
  static const String fromGetUser = 'failure to get user info';

  /// Unknown
  static const String pageNotFoundTitle = 'error 404';
  static const String pageNotFound = 'page not found.';
  static const String empty = 'data not found.';

  // Profile
  static const String settingsPage = 'settings';
  static const String editProfilePage = 'edit profile';
  static const String delete = 'delete profile';
  static const String username = 'username';
  static const String interests = 'interests';
  static const String joined = 'joined';
  static const String about = 'about me';
  static const String bio = 'bio';
  static const String displayName = 'name';
  static const String interestsPrompt = 'interests?';

  // Notifications
  static const String inbox = 'inbox';

  // Create
  static const String create = 'create something';
  static const String createPostPage = 'create a post';
  static const String createBoardPage = 'create a board';
  static const String confirmCreatePage = "How's this look?";
  static const String skip = '(or skip)';
  static const String createPost = 'create post';
  static const String createBoard = 'create board';
  static const String title = 'name?';
  static const String description = 'description?';
  static const String tagsPrompt = 'tags?';
  static const String postFailure = 'failed to create post';
  static const String boardFailure = 'failed to create board';

  // Posts
  static const String addToBoard = 'add to board';

  // Boards
  static const String shuffledPosts = 'shuffled posts';
  static const String shuffle = 'shuffle';

  // Comments
  static const String createComment = 'create comment';
  static const String deleteComment = 'delete comment';
  static const String emptyComments = 'be the first to leave a comment!';

  // Tags
  static const String createTags = 'add tags';
  static const String createTag = 'add tag';
  static const String editTags = 'edit tags';
  static const String emptyTags = 'no tags yet!';

  // Explore
  static const String explorePage = 'explore';

  // Search
  static const String search = 'search';
  static const String searchPrompt = 'discover something new...';

  // Image
  static const String selectMedia = 'select media';
  static const String camera = 'camera';
  static const String library = 'library';

  // Auth
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
