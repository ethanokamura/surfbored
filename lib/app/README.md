# App:

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
    └── app.dart                  # Exports view/app.dart and bootstrap
```