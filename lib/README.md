# lib

The main repository for the application’s code.

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

## Handling Data and State: 💾

This app uses cubits to handle state along side the work done in the backend.

`UI <--> Cubit <--> Repository`

UI -> the end point for the user

Cubit -> emits and handles state changes

Repositories -> handle requests and responses to the API's



### App:

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

### Features:

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
