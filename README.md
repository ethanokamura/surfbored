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
# run_pub_get.sh
# Find all pubspec.yaml files in the project
find . -name "pubspec.yaml" | while read -r file; do
  # Navigate to the directory containing the pubspec.yaml
  dir=$(dirname "$file")
  echo "Installing packages in $dir"
  (cd "$dir" && dart pub get)
done
```

To generate the data models:
```bash
# create_models.sh
# Find all the data models files in the project
find . -name "models.dart" | while read -r file; do
  # Navigate to the directory containing the data models
  dir=$(dirname "$file")
  echo "Building data model files in $dir"
  (cd "$dir" && flutter pub run build_runner build)
done
```

## Project Structure: 📁

lib/ for the implemented features of the app
packages/ handling the apps structure (data, api calls, UI data, strings, etc.)

```
lib/
  ├── app/                       # Main app logic
  ├── features/                  # Implemented features of the app
  ├── theme/                     # Theme cubit
  ├── firebase_options.dart      # Firebase app keys
  └── main.dart                  # Entry point for the app

packages/
  ├── api_client/                # References to API's such as Firebase Storage and Firestore
  ├── app_core/                  # Core functions of the project; main backbone for the backend
  ├── app_ui/                    # UI elements including theme, commonly used widgets, and constants
  ├── board_repository/          # Handles board data and its interaction with API's
  ├── post_repository/           # Handles post data and its interaction with API's
  ├── tag_repository/            # Handles tag data and its interaction with API's
  └── user_repository/           # Handles user data and its interaction with API's

```

## Handling Data and State: 💾

This app uses cubits to handle state along side the work done in the backend.

`UI <--> Cubit <--> Repository`

UI -> the end point for the user

Cubit -> emits and handles state changes

Repositories -> handle requests and responses to the API's
