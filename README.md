# SurfBoard 🌊

Surfing the web is for boomers. Surf some boards and find cool shit to do.

## Why? 🤔

Need something to do today? Create boards with your favorite activities! Or better yet, find someone else's board to find something new.
Have trouble choosing? SurfBoard will pick activities at random so you dont have to!
Connect with friends and make collaborative boards!

## How it works: 🔍

Create and share activities by creating a post!
Create and share collections of your favorite activites via boards.
Find an activity you like? Add it to the board of your choosing.
Find a board you like? Like it and add it to you library of boards.


## Running the Project: 📲

clone the repo and run the following scripts

To download the dependencies:
```bash
# Find all pubspec.yaml files in the project
find . -name "pubspec.yaml" | while read -r file; do
  # Navigate to the directory containing the pubspec.yaml
  dir=$(dirname "$file")
  echo "Running 'dart pub get' in $dir"
  (cd "$dir" && dart pub get)
done
```

To generate the data models:
```bash
# Find all pubspec.yaml files in the project
find . -name "models.dart" | while read -r file; do
  # Navigate to the directory containing the pubspec.yaml
  dir=$(dirname "$file")
  echo "Running 'dart pub get' in $dir"
  (cd "$dir" && flutter pub run build_runner build)
done
```

## Project Structure: 📁

lib/ for the implemented features of the app
packages/ handling the apps structure (data, api calls, UI data, strings, etc.)

### Lib:
The main app file which includes initializing and debugging the app as well as the main app state handler.

Implementations of the packages directory (The UI).

Uses cubits to interact with the data.

```
lib/
  |-- app/ for the main app logic
  |
  |-- pages/ for the implemented features of the app
  |
  |-- theme/ for the theme cubit
  |
  |-- firebase_options.dart - firebase app keys
  |
  |-- main.dart - entry point for the app
```

### Packages:

The backend/backbone of the project.

```
packages/
      |-- app_core/ for the core functions of the project. the main backbone for the backend
      |
      |-- api_client/ for all references to the apis such as firebase storage and firestore
      |
      |-- app_ui/ for all ui elements including theme, commonlly used widgets, and constants
      |
      |-- user_repository/ to handle user data and its interaction with firestore functions
      |
      |-- post_repository/ to handle post data and its interaction with firestore functions
      |
      |-- board_repositroy/ to handle board data and its interaction with firestore funcitons
```

## Handling Data and State: 💾

This app uses cubits to handle state along side the work done in the backend.

`UI <--> Cubit <--> Repository`

UI -> the end point for the user

Cubit -> emits and handles state changes

Repositories -> handle requests and responses to the API's

## Data Structure:

Scalability: Sharded subcollections help manage large lists and ensure that you stay within Firestore’s document size limits.

Efficiency: Using composite keys and arrays allows for efficient querying and data retrieval.

Simplified Data Management: Keeping separate collections for likes and saves ensures that data is not duplicated and is easy to manage.

Composite Indexes: Implemented composite indexes in place for efficient querying.

Pagination: Implemented pagination to handle data efficiently on the client side.

```
users/
  {userId}/
    posts/
      {shardId1}/
        posts: [postId1, postId2, ...]
      {shardId2}/
        posts: [postId1, postId2, ...]
    boards/
      {shardId1}/
        posts: [boardId1, boardId2, ...]
      {shardId2}/
        posts: [boardId1, boardId2, ...]
    tags: [tagId1, tagId2, ...]
    friends: number

friends/
  {userId1}_{userId2}/
    userId1: userId1
    userId2: userId2
    timestamp: timestamp

usernames/
  {userId}/
    userId: userId
    username: username

posts/
  {postId}/
    authorId: userId
    likes: number
    tags: [tagId1, tagId2, ...]

likes/
  {postId}_{userId}/
    postId: postId
    userId: userId
    timestamp: timestamp

boards/
  {boardId}/
    authorId: userId
    saves: number
    posts/
      {shardId1}/
        posts: [postId1, postId2, ...]
      {shardId2}/
        posts: [postId1, postId2, ...]
    tags: [tagId1, tagId2, ...]

saves/
  {boardId}_{userId}/
    boardID: postId
    userId: userId
    timestamp: timestamp

tags/
  {tagId}/
    usageCount: number
    users: [userId1, userId2, ...]
    posts/
      {shardId1}/
        posts: [postId1, postId2, ...]
      {shardId2}/
        posts: [postId1, postId2, ...]
    boards/
      {shardId1}/
        posts: [boardId1, boardId2, ...]
      {shardId2}/
        posts: [boardId1, boardId2, ...]
```