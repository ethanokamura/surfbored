# Packages Directory:

The backend/backbone of the project.
  - handles the apps structure (data, api calls, UI data, strings, etc.)

```
packages/
  ├── api_client/                # References to API's such as Firebase Storage and Firestore
  ├── app_core/                  # Core functions of the project; main backbone for the backend
  ├── app_ui/                    # UI elements including theme, commonly used widgets, and constants
  ├── board_repository/          # Handles board data and its interaction with API's
  ├── post_repository/           # Handles post data and its interaction with API's
  └── user_repository/           # Handles user data and its interaction with API's
```

## Data Structure

Scalability: Sharded subcollections help manage large lists and ensure that you stay within Firestore’s document size limits.

Efficiency: Using composite keys and arrays allows for efficient querying and data retrieval.

Simplified Data Management: Keeping separate collections for likes and saves ensures that data is not duplicated and is easy to manage.

Composite Indexes: Implemented composite indexes in place for efficient querying.

Pagination: Implemented pagination to handle data efficiently on the client side.

```
users/
  {userId}/
    uid: string
    photoURL: string
    username: string
    name: string
    bio: string
    friends: number
    posts: [postId1, postId2, ...]
    boards: [boardId1, boardId2, ...]
    tags: [tagId1, tagId2, ...]
    memberSince: timestamp

usernames/
  {userId}/
    uid: string
    username: string

posts/
  {postId}/
    uid: string
    id: string
    title: string
    description: string
    likes: number
    tags: [tagId1, tagId2, ...]
    createdAt: timestamp

tags/
  {tagId}/
    name: string
    usageCount: number

userTags/
  {tagId}/
    users: [userId1, userId2, ...]

postTags/
  {tagId}/
    posts: [postId1, postId2, ...]

boardTags/
  {tagId}/
    boards: [boardId1, boardId2, ...]

boards/
  {boardId}/
    uid: string
    id: string
    title: string
    description: string
    likes: number
    posts: [postId1, postId2, ...]
    tags: [tagId1, tagId2, ...]
    createdAt: timestamp

friends/
  {userId1}_{userId2}/
    userId1: string
    userId2: string
    timestamp: timestamp

friend_requests/
  {userId1}_{userId2}/
    sender: string
    reciever: string
    timestamp: timestamp

likes/
  {postId}_{userId}/
    postId: string
    userId: string
    timestamp: timestamp

saves/
  {boardId}_{userId}/
    boardID: string
    userId: string
    timestamp: timestamp
```