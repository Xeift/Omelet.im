import 'package:meta/meta.dart';

@immutable
class MessageData {
  const MessageData(
      {required this.senderName,
      required this.remoteUid,
      required this.message,
      required this.messageDate,
      required this.dateMessage,
      required this.profilePicture});

  final String senderName;
  final String remoteUid; //對方uid
  final String message;
  final DateTime messageDate;
  final String dateMessage;
  final String profilePicture;
}

class NotificationData {
  const NotificationData({
    required this.title,
    required this.message,
    required this.type,
    required this.notifyDate,
  });
  final String title;
  final String message;
  final String type;
  final DateTime notifyDate;
}
class FriendsListData{
  const FriendsListData({
    required this.friendsUid,
    required this.friendsPicture,
    required this.addDate,
  });
  final String friendsUid;
  final String friendsPicture;
  final DateTime addDate;
}
