import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String senderEmail;
  final String recieverID;
  final String message;
  final Timestamp timestamp;
  final bool isRead;
  final String imageUrl;

  Message({
    required this.imageUrl,
    required this.isRead,
    required this.senderID,
    required this.senderEmail,
    required this.recieverID,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderEmail': senderEmail,
      'receiverID': recieverID,
      'message': message,
      'timestamp': timestamp,
      'isRead': false,
      'imageUrl':''
    };
  }
}

