# SurfBoard

Surfing the web is for boomers. Surf some boards and find cool shit to do.

## Why?

Need something to do today? Create boards with your favorite activities! Or better yet, find someone else's board to find something new.
Have trouble choosing? SurfBoard will pick activities at random so you dont have to!
Connect with friends and make collaborative boards!

## How it works

Create and share activities by creating a post!
Create and share collections of your favorite activites via boards.
Find an activity you like? Add it to the board of your choosing.
Find a board you like? Like it and add it to you library of boards.


# Running the Project:

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

# Project Structure:

lib/app/ for the main app logic
lib/features/ for the implemented features of the app
packages/ handling the apps structure (data, api calls, UI data, strings, etc.)

## App:

The main app file which includes initializing and debugging the app as well as the main app state handler.

```
lib/app/
      |-- app_bloc_observer.dart - observes app changes and errors
      |
      |-- app_bootstrap.dart - wrapper for the app to handle debugging
      |
      |-- app.dart - exports view/app.dart and bootstrap
      |
      |-- generate_pages.dart - defines features to generate
      |
      |-- view/app.dart - main app file
      |
      |-- cubit/
            |-- app_cubit.dart - main app cubit
            |
            |-- app_state.dart - main app state
```

## Features:

Implementations of the packages directory (The UI).
Uses cubits to interact with the data.

```
lib/features/
      |-- login/ to handle user login page
      |
      |-- registration/ to handle user registration
      |
      |-- home/ to handle the main navigation logic this contains the bottom nav bar
      |
      |-- posts/ to handle the posts features such as viewing or editing a post
      |
      |-- boards/ to handle the boards features such as viewing or editing a board
      |
      |-- profile/ to handle the user features such as viewing or editing your profile
      |
      |-- create/ to handle the creating an activity or board
```


## Packages:

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
      |-- packages/post_repository/ to handle post data and its interaction with firestore functions
      |
      |-- packages/board_repositroy/ to handle board data and its interaction with firestore funcitons
```

# Handling Data and State:

This app uses cubits to handle state along side the work done in the backend.

`UI <--> Cubit <--> Repository`

UI - the end point for the user

Cubit - emits and handles state changes

Repositories - handle requests and responses to the API's