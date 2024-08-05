# lib

The main repository for the application’s code.

The main app file which includes initializing and debugging the app as well as the main app state handler.

Implementations of the packages directory (The UI).

Uses cubits to interact with the data.

```
lib/
  ├── app/                       # Main app logic
  ├── features/                  # Implemented features of the app
  ├── theme/                     # Theme cubit
  ├── firebase_options.dart      # Firebase app keys
  └── main.dart                  # Entry point for the app
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
    ├── app_bloc_observer.dart    # Observes app changes and errors
    ├── app_bootstrap.dart        # Wrapper for the app to handle debugging
    ├── app.dart                  # Exports view/app.dart and bootstrap
    ├── generate_pages.dart       # Defines features to generate
    ├── view/
    │   └── app.dart              # Main app file
    └── cubit/
        ├── app_cubit.dart        # Main app cubit
        └── app_state.dart        # Main app state
```

### Features:

Implementations of the packages directory (The UI).
Uses cubits to interact with the data.

```
lib/features/
    ├── login/                    # Handles user login page
    ├── registration/             # Handles user registration
    ├── home/                     # Handles the main navigation logic, including the bottom nav bar
    ├── posts/                    # Handles the posts features such as viewing or editing a post
    ├── boards/                   # Handles the boards features such as viewing or editing a board
    ├── profile/                  # Handles user features such as viewing or editing your profile
    └── create/                   # Handles creating an activity or board
```
