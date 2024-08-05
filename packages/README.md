# Packages Directory:

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

## Data Structure

Scalability: Sharded subcollections help manage large lists and ensure that you stay within Firestore’s document size limits.

Efficiency: Using composite keys and arrays allows for efficient querying and data retrieval.

Simplified Data Management: Keeping separate collections for likes and saves ensures that data is not duplicated and is easy to manage.

Composite Indexes: Implemented composite indexes in place for efficient querying.

Pagination: Implemented pagination to handle data efficiently on the client side.

```
users/
  {userId}/
    posts/
      {shardId1}/
        posts: [postId1, postId2, ...]
      {shardId2}/
        posts: [postId1, postId2, ...]
    boards/
      {shardId1}/
        posts: [boardId1, boardId2, ...]
      {shardId2}/
        posts: [boardId1, boardId2, ...]
    tags: [tagId1, tagId2, ...]
    friends: number

friends/
  {userId1}_{userId2}/
    userId1: userId1
    userId2: userId2
    timestamp: timestamp

usernames/
  {userId}/
    userId: userId
    username: username

posts/
  {postId}/
    authorId: userId
    likes: number
    tags: [tagId1, tagId2, ...]

likes/
  {postId}_{userId}/
    postId: postId
    userId: userId
    timestamp: timestamp

boards/
  {boardId}/
    authorId: userId
    saves: number
    posts/
      {shardId1}/
        posts: [postId1, postId2, ...]
      {shardId2}/
        posts: [postId1, postId2, ...]
    tags: [tagId1, tagId2, ...]

saves/
  {boardId}_{userId}/
    boardID: postId
    userId: userId
    timestamp: timestamp

tags/
  {tagId}/
    usageCount: number
    users: [userId1, userId2, ...]
    posts/
      {shardId1}/
        posts: [postId1, postId2, ...]
      {shardId2}/
        posts: [postId1, postId2, ...]
    boards/
      {shardId1}/
        posts: [boardId1, boardId2, ...]
      {shardId2}/
        posts: [boardId1, boardId2, ...]
```