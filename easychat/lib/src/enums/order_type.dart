/// Order type for sorting the chat room list after the login user opens(sees) the chat room.
/// This is for the login user only.
///
/// - [OpenOrderType.lastMessage] is to sort the chat list by the last message sent to the chat room.
/// - [OpenOrderType.lastSeen] is to sort the chat list by the last seen time of the chat room.
enum OpenOrderType {
  lastMessage,
  lastSeen,
}
