import 'dart:developer';

import 'package:art_elevate/chats/chat_services.dart';
import 'package:art_elevate/chats/messagepage.dart';
import 'package:art_elevate/chats/usertile.dart';
import 'package:art_elevate/views/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:art_elevate/l10n/app_localizations.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatServices _chatServices = ChatServices();
  User? user = FirebaseAuth.instance.currentUser;

  // getChatRoomID(String senderEmail, String receiverEmail) async {
  //   try {
  //     String chatRoomId =
  //         await _chatServices.getChatRoomID(senderEmail, receiverEmail);
  //     setState(() {
  //       chatRoomID = chatRoomId;
  //     });
  //   } catch (e) {
  //     throw Exception('Error fetching chat room ID: $e');
  //   }
  // }

  Future<void> _refreshUserList() async {
    setState(() {
      _buildUserList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: kprimaryColor,
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.chats,
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.chat_outlined,
                color: Colors.black,
              ),
            )
          ],
          titleTextStyle: GoogleFonts.poppins(
              color: Colors.black, fontSize: 21, fontWeight: FontWeight.w500),
        ),
        body: RefreshIndicator(
            onRefresh: _refreshUserList, child: _buildUserList()));
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatServices.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Shimmer(
            gradient:
                const LinearGradient(colors: [Colors.black26, Colors.white70]),
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  height: 70,
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.all(15),
                );
              },
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text(
            AppLocalizations.of(context)!.noChatsFound,
            style: GoogleFonts.poppins(color: Colors.black, fontSize: 20),
          ));
        }
        List<Map<String, dynamic>> sortedUsers = List.from(snapshot.data!);
        sortedUsers.sort((a, b) {
          // Ensure we check that 'lastMessageTimestamp' is not null before comparing
          Timestamp? timestampA = a['lastMessageTimestamp'] as Timestamp?;
          Timestamp? timestampB = b['lastMessageTimestamp'] as Timestamp?;

          if (timestampA != null && timestampB != null) {
            return timestampB.compareTo(
                timestampA); // Sorting in descending order (latest first)
          }
          return 0;
        });
        return ListView(
          children: snapshot.data!
              .map((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData['user']['email'] != user?.email) {
      String chatRoomID = userData['chatRoomID'];
      return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat_rooms')
            .doc(chatRoomID)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .snapshots(),
        builder: (context, messageSnapshot) {
          if (messageSnapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.black), // Progress color
                backgroundColor: Colors.white, // Background color of the circle
                strokeWidth: 5.0);
          }
          if (!messageSnapshot.hasData || messageSnapshot.data!.docs.isEmpty) {
            return Container();
          }
          var lastestMessage = messageSnapshot.data!.docs.first;

          bool isNewMessage = false;

          if (lastestMessage['senderID'] != user?.uid) {
            if (lastestMessage.data().containsKey('isRead')) {
              var isRead = lastestMessage['isRead'];
              if (isRead is bool) {
                isNewMessage = !isRead;
              }
            }
          }

          return UserTile(
            isNewMessage: isNewMessage,
            refreshUserList: _refreshUserList,
            chatRoomID: chatRoomID,
            text: userData['user']['email'],
            onTap: () async {
              String senderID = user!.uid;
              await _chatServices.markMessageAsRead(
                  senderID, userData['user']['uid']);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessagePage(
                    receiverID: userData['user']['uid'],
                    receiverEmail: userData['user']['email'],
                  ),
                ),
              );
            },
          );
        },
      );
    } else {
      return Container();
    }
  }
}
