import 'package:meta/meta.dart';

@immutable
class MessageData{
  const MessageData({
    required this.senderName, 
    required this.senderUid,
    required this.remoteUid,
    required this.message, 
    required this.messageDate, 
    required this.dateMessage, 
    required this.profilePicture});

  final String senderName;
  final String senderUid;//我方uid
  final String remoteUid;//對方uid
  final String message;
  final DateTime messageDate;
  final String dateMessage;
  final String profilePicture;
  



}
