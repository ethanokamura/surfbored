# boards
Directory for all things boards!

```
lib/features/boards/
  ├── cubit/
  │    ├── board_cubit.dart       # Main board cubit
  │    └── board_state.dart       # Main board state
  ├── view/
  │    └── app.dart              # Main app file
  ├── app_bloc_observer.dart    # Observes app changes and errors
  ├── app_bootstrap.dart        # Wrapper for the app to handle debugging
  └── app.dart                  # Exports view/app.dart and bootstrap
```