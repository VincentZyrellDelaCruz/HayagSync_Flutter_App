import 'package:hayagsync_app/models/user.dart';

class Inbox {
  final int id;

  final String senderId;
  final String receiverId;

  final String title;
  final String message;

  final bool isRead;

  final DateTime createdAt;
  final DateTime updatedAt;

  final User? sender;
  final User? receiver;

  Inbox({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
    this.sender,
    this.receiver,
  });

  factory Inbox.fromJson(Map<String, dynamic> json) {
    return Inbox(
      id: json['id'],

      senderId: json['sender_id'],
      receiverId: json['receiver_id'],

      title: json['title'] ?? '',
      message: json['message'] ?? '',

      isRead: json['is_read'] == 1 || json['is_read'] == true,

      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),

      sender: json['sender'] != null
          ? User.fromJson(json['sender'])
          : null,

      receiver: json['receiver'] != null
          ? User.fromJson(json['receiver'])
          : null,
    );
  }
}