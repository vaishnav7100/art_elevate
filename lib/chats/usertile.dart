import 'dart:developer';

import 'package:art_elevate/chats/chat_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:art_elevate/l10n/app_localizations.dart';

class UserTile extends StatelessWidget {
  final String text;
  final String chatRoomID;
  final void Function()? onTap;
  final bool isNewMessage;
  final Function refreshUserList;
  UserTile(
      {super.key,
      required this.text,
      this.onTap,
      required this.isNewMessage,
      required this.chatRoomID,
      required this.refreshUserList});

  final ChatServices _chatServices = ChatServices();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            const Icon(
              Icons.person,
              color: Colors.black,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                overflow: TextOverflow.ellipsis,
                text,
                style: GoogleFonts.poppins(fontSize: 17),
              ),
            ),
            if (isNewMessage)
              Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            PopupMenuButton(
              color: Colors.grey[100],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              itemBuilder: (context) => <PopupMenuEntry>[
                PopupMenuItem(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(AppLocalizations.of(context)!.delete),
                  onTap: () {
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
                          title: Text(
                            "Are you sure?",
                            style: GoogleFonts.poppins(
                                color: Colors.black, fontSize: 20),
                          ),
                          actions: [
                            TextButton(
                              style: TextButton.styleFrom(
                                  overlayColor: Colors.black),
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
                              style: TextButton.styleFrom(
                                  overlayColor: Colors.black),
                              onPressed: () {
                                log(chatRoomID);
                                _chatServices.deleteChatRoom(chatRoomID);
                                refreshUserList();
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Confirm',
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
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
