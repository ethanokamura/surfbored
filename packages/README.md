# Packages Directory:

The backend/backbone of the project.
  - handles the apps structure (data, api calls, UI data, strings, etc.)

```
packages/
  ├── api_client/                # References to API's such as Firebase Storage and Firestore
  ├── app_core/                  # Core functions of the project; main backbone for the backend
  ├── app_ui/                    # UI elements including theme, commonly used widgets, and constants
  ├── board_repository/          # Handles board data and its interaction with API's
  ├── comment_repository/        # Handles the interaction between comments and the API's
  ├── friend_repository/         # Handles the interaction between users and the API's
  ├── post_repository/           # Handles post data and its interaction with API's
  ├── tag_repository/            # Handles the interaction between tags and the API's
  └── user_repository/           # Handles user data and its interaction with API's
```
