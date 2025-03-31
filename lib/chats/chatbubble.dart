import 'dart:developer';

import 'package:art_elevate/chats/chat_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Chatbubble extends StatefulWidget {
  final String? message;
  final bool isCurrentUser;
  final String? imageUrl;
  final String receiverID;
  final String senderID;
  final Timestamp timestamp;

  const Chatbubble(
      {super.key,
      this.message = '',
      required this.isCurrentUser,
      this.imageUrl = '',
      required this.receiverID,
      required this.senderID,
      required this.timestamp});

  @override
  State<Chatbubble> createState() => _ChatbubbleState();
}

class _ChatbubbleState extends State<Chatbubble> {
  void delete() async {
    try {
      Timestamp timeStamp = widget.timestamp;
      String chatRoomID =
          ChatServices().getChatRoomID(widget.senderID, widget.receiverID);

      String messageID = await ChatServices()
          .getMessageID(chatRoomID, widget.message!, timeStamp);
      log(messageID);
      log(chatRoomID);
      await ChatServices().deleteMessage(
        chatRoomID,
        messageID,
      );
    } catch (e) {
      log('Error $e');
    }
  }

  void deleteImage(String imageUrl) async {
    String chatRoomID =
        ChatServices().getChatRoomID(widget.senderID, widget.receiverID);
    try {
      if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
        await ChatServices().deleteImage(chatRoomID, imageUrl);
      }
    } catch (e) {
      log('Error deleting image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
          GestureDetector(
            onLongPress: () {
              showDialog(
                barrierDismissible: true,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    actionsOverflowButtonSpacing: 20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: Colors.white,
                    title: const Text(
                      "Delete image?",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    actions: [
                      TextButton(
                        style: TextButton.styleFrom(overlayColor: Colors.black),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.anekBangla(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(overlayColor: Colors.black),
                        onPressed: () {
                          deleteImage(widget.imageUrl!);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Delete',
                          style: GoogleFonts.anekBangla(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              height: 200,
              width: 200,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: GestureDetector(
                onTap: () {
                  // Show the image in a dialog on tap
                  showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            // child: Image.network(
                            //   widget.imageUrl!,
                            //   fit: BoxFit.cover,
                            // ),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: widget.imageUrl!,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black), // Progress color
                                    backgroundColor: Colors
                                        .white, // Background color of the circle
                                    strokeWidth: 5.0),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.black12,
                      )),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    // child: Image.network(
                    //   widget.imageUrl!,
                    //   fit: BoxFit.cover,
                    // ),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: widget.imageUrl!,
                      placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                       valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black), // Progress color
                                    backgroundColor: Colors
                                        .white, // Background color of the circle
                                    strokeWidth: 5.0
                      )),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (widget.imageUrl == null || widget.imageUrl!.isEmpty)
          GestureDetector(
            onLongPress: () {
              showDialog(
                barrierDismissible: true,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    actionsOverflowButtonSpacing: 20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: Colors.white,
                    title: const Text(
                      "Delete message?",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    actions: [
                      TextButton(
                        style: TextButton.styleFrom(overlayColor: Colors.black),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.anekBangla(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(overlayColor: Colors.black),
                        onPressed: () {
                          delete();
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Delete',
                          style: GoogleFonts.anekBangla(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: BubbleSpecialOne(
              text: widget.message ?? '',
              isSender: widget.isCurrentUser,
              color: widget.isCurrentUser
                  ? Colors.green.shade500
                  : Colors.grey.shade500,
              tail: true,
              textStyle: GoogleFonts.raleway(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
    // return Container(
    //   decoration: BoxDecoration(
    //       boxShadow: const [
    //         BoxShadow(
    //           color: Colors.black38,
    //           offset: Offset(0.0, 0), //(x,y)
    //           blurRadius: 10.0,
    //         ),
    //       ],
    //       color: isCurrentUser ? Colors.green.shade400 : Colors.grey.shade500,
    //       borderRadius: BorderRadius.circular(8)),
    //   padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
    //   margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
    //   child: Text(
    //     message,
    //     style: TextStyle(color: Colors.white, fontSize: 19),
    //   ),
    // );
  }
}
