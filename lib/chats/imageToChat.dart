import 'package:cloud_firestore/cloud_firestore.dart';

class UploadImage {
  final String senderID;
  final String senderEmail;
  final String recieverID;
  final String imageUrl;
  final Timestamp timestamp;
  final bool isRead;
  final String message;

  UploadImage({
    required this.message,
    required this.isRead,
    required this.senderID,
    required this.senderEmail,
    required this.recieverID,
    required this.imageUrl,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderEmail': senderEmail,
      'receiverID': recieverID,
      'imageUrl': imageUrl,
      'timestamp': timestamp,
      'isRead': false,
      'message':''
    };
  }
}
