import 'dart:developer';

import 'package:art_elevate/chats/imageToChat.dart';
import 'package:art_elevate/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUserStream() {
    final String currentUserID = _auth.currentUser!.uid;
    return _firestore
        .collection('users')
        .snapshots()
        .asyncMap((snapshot) async {
      List<Map<String, dynamic>> filteredUsers = [];

      // Iterate through each user
      for (var doc in snapshot.docs) {
        final user = doc.data() as Map<String, dynamic>?;
        if (user == null || doc.id == currentUserID) {
          continue; // Skip the current user
        }

        final userID = doc.id;

        String chatRoomID = getChatRoomID(currentUserID, userID);

        // Fetch chatrooms associated with the user (we are interested in either direction)
        List<String> ids = [currentUserID, userID];
        ids.sort();

        // Check if there is a chatroom where either you or the other user have sent a message
        final chatRoomSnapshot = await _firestore
            .collection('chat_rooms')
            .doc(getChatRoomID(currentUserID, userID))
            .collection('messages')
            .where('senderID', isEqualTo: currentUserID)
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        final chatRoomSnapshotReverse = await _firestore
            .collection('chat_rooms')
            .doc(getChatRoomID(currentUserID, userID))
            .collection('messages')
            .where('senderID', isEqualTo: userID)
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        Timestamp lastMessageTimestamp = chatRoomSnapshot.docs.isNotEmpty
            ? chatRoomSnapshot.docs.first['timestamp']
            : Timestamp.fromMillisecondsSinceEpoch(0);
        // If either snapshot has messages, the user should appear in the list
        if (chatRoomSnapshot.docs.isNotEmpty ||
            chatRoomSnapshotReverse.docs.isNotEmpty) {
          filteredUsers.add({
            'user': user,
            'chatRoomID': chatRoomID,
            'lastMessageTimestamp': lastMessageTimestamp
          }); // Add the user to the list if there's a chat interaction
        }
      }
      filteredUsers.sort((a, b) {
        // Safely compare the timestamps, ensure both are valid
        Timestamp? timestampA = a['lastMessageTimestamp'] as Timestamp?;
        Timestamp? timestampB = b['lastMessageTimestamp'] as Timestamp?;

        if (timestampA == null) return 1; // Handle null timestamps
        if (timestampB == null) return -1;

        return timestampB.compareTo(timestampA); // Sort in descending order
      });

      log("Filtered Users List: $filteredUsers");
      return filteredUsers; // Return the filtered users who have communicated with the current user
    });
  }

  String getChatRoomID(String currentUserID, String otherUserID) {
    List<String> ids = [currentUserID, otherUserID];
    ids.sort();
    return ids.join('_');
  }

  

  Future<String> sendMessage(String recieverID, message) async {
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    if (currentUserID == recieverID) {
      throw Exception("Sender and receiver cannot be the same.");
    }

    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      recieverID: recieverID,
      message: message,
      timestamp: timestamp,
      isRead: false,
      imageUrl: '',
    );

    List<String> ids = [currentUserID, recieverID];
    ids.sort();
    String chatRoomID = ids.join('_');
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .add(newMessage.toMap());

    await _firestore.collection('users').doc(currentUserID).update({
      'lastMessageTimestamp': timestamp,
    });

    await _firestore.collection('users').doc(recieverID).update({
      'lastMessageTimestamp': timestamp,
    });

    return chatRoomID;
  }

  Future<String> getMessageID(
      String chatRoomID, String message, Timestamp timestamp) async {
    log(message);
    log(chatRoomID);
    var querySnapshot = await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .where('message', isEqualTo: message)
        .where('timestamp', isEqualTo: timestamp)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String messageID = querySnapshot.docs.first.id;
      log(messageID);
      return messageID;
    } else {
      throw Exception('Message not found');
    }
  }

  Future<Timestamp> getMessageTimestamp(
      String chatRoomID, String messageID) async {
    var docSnapshot = await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .doc(messageID)
        .get();

    if (docSnapshot.exists) {
      var data = docSnapshot.data();
      if (data != null) {
        return data['timestamp'];
      }
    }
    return Timestamp.fromMillisecondsSinceEpoch(0);
  }

  Future<void> deleteMessage(String chatRoomID, String messageID) async {
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .doc(messageID)
        .delete();
  }

  Future<void> deleteImage(String chatRoomID, String imageUrl) async {
    log(imageUrl);
    log("chatroom$chatRoomID");
    if (imageUrl.isEmpty) {
      throw Exception("Image Url cannot be empty");
    }
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('chat_rooms')
          .doc(chatRoomID)
          .collection('messages')
          .where('imageUrl', isEqualTo: imageUrl)
          .get();

      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }
        Fluttertoast.showToast(
          msg: 'Image deleted successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0,
        );
      } else {
        // If no documents were found with the specified imageUrl
        Fluttertoast.showToast(
          msg: 'No image found with the specified URL',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error deleting image: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0,
      );
      throw Exception("Error deleting image: $e");
    }
  }

  Future<void> markMessageAsRead(String senderID, String receiverID) async {
    try {
      QuerySnapshot messageSnapshot = await _firestore
          .collection('chat_rooms')
          .doc(getChatRoomID(senderID, receiverID))
          .collection('messages')
          .where('receiverID', isEqualTo: senderID)
          .where('isRead', isEqualTo: false)
          .get();

      if (messageSnapshot.docs.isEmpty) {
        log("No unread messages found.");
        return; // Early return if no unread messages are found
      }

      for (var doc in messageSnapshot.docs) {
        await doc.reference.update({'isRead': true});
      }
    } catch (e) {
      log("Error marking messages as read: $e");
    }
  }

  Future<void> sendImageToChat(String recieverID, imageUrl) async {
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();
    log('message');

    if (currentUserID == recieverID) {
      throw Exception("Sender and receiver cannot be the same.");
    }
    if (imageUrl.isEmpty) {
      throw Exception("Image URL is empty.");
    }

    UploadImage image = UploadImage(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      recieverID: recieverID,
      imageUrl: imageUrl,
      timestamp: timestamp,
      isRead: false,
      message: '',
    );
    List<String> ids = [currentUserID, recieverID];
    ids.sort();
    String chatRoomID = ids.join('_');
    log('message');
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .add(image.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<void> deleteChatRoom(String chatRoomID) async {
    try {
      QuerySnapshot messageSnapshot = await _firestore
          .collection('chat_rooms')
          .doc(chatRoomID)
          .collection('messages')
          .get();

      for (var doc in messageSnapshot.docs) {
        await doc.reference.delete();
      }
      log('Current user UID: ${FirebaseAuth.instance.currentUser?.uid}');

      await _firestore.collection('chat_rooms').doc(chatRoomID).delete();

      Fluttertoast.showToast(
          msg: 'Chat deleted successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error deleting chat: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0,
      );
      throw Exception("Error deleting chat room: $e");
    }
  }
}
