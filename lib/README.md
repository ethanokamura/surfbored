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
    ├── cubit/
    │    ├── app_cubit.dart       # Main app cubit
    │    └── app_state.dart       # Main app state
    ├── view/
    │   └── app.dart              # Main app file
    ├── app_bloc_observer.dart    # Observes app changes and errors
    ├── app_bootstrap.dart        # Wrapper for the app to handle debugging
    ├── app.dart                  # Exports view/app.dart and bootstrap
    └── generate_pages.dart       # Defines features to generate
```

### Features:

Implementations of the packages directory (The UI).
Uses cubits to interact with the data.

```
lib/features/
    ├── boards/                   # Handles the boards features such as viewing or editing a board
    ├── create/                   # Handles the ability to post
    ├── explore/                  # Handles the user's explore page / search
    ├── home/                     # Handles the main navigation logic
    ├── inbox/                    # Handles user inbox page
    ├── login/                    # Handles user login and registration pages
    ├── posts/                    # Handles the posts features such as viewing or editing a post
    ├── profile/                  # Handles user features such as viewing or editing your profile
    ├── reroutes/                 # Handles unexpected routing
    ├── search/                   # Handles search
    └── tags/                     # Handles tags
```
