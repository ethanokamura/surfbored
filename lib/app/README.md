# App:

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