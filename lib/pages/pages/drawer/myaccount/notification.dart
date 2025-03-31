import 'dart:developer';

import 'package:art_elevate/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  // Fetch notifications stream for the current user
  Stream<QuerySnapshot>? notificationsStream;
  int unreadCount = 0;
  // Fetch notifications when the widget is first loaded
  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  void _fetchNotifications() {
    // Get current user ID
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Listen to notifications for the current user
      notificationsStream = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('notifications')
          .orderBy('timestamp', descending: true) // Sort by timestamp
          .snapshots();

      notificationsStream!.listen((QuerySnapshot snapshot) {
        // Count unread notifications
        unreadCount =
            snapshot.docs.where((doc) => doc['read'] == false).toList().length;
        setState(() {});
      });
    }
  }

  // Mark notification as read
  void _markAsRead(String notificationId) async {
    try {
      if (mounted) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('notifications')
            .doc(notificationId)
            .update({'read': true});
      }
    } catch (e) {
      log("Error marking notification as read: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: kprimaryColor,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.notifications_outlined,
              color: Colors.black,
            ),
          )
        ],
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
            color: Colors.black, fontSize: 21, fontWeight: FontWeight.w500),
        title:  Text(AppLocalizations.of(context)!.notifications),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: notificationsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.black), // Progress color
                  backgroundColor:
                      Colors.white, // Background color of the circle
                  strokeWidth: 5.0),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('${AppLocalizations.of(context)!.error}${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.no_notifications_available,
                style: GoogleFonts.poppins(color: Colors.black, fontSize: 16),
              ),
            );
          }

          var notifications = snapshot.data!.docs;
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              var notification = notifications[index];
              String notificationId = notification.id;
              String title = notification['title'];
              String body = notification['body'];
              bool isRead = notification['read'] ?? false;
              String imageUrl = notification['image'];

              return Stack(
                children: [
                  Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    elevation: 7,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            width: 100, // Fixed width
                            height: 100, // Fixed height
                            fit: BoxFit
                                .cover, // Ensures image is scaled correctly
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            title: Text(
                              title,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: isRead ? Colors.grey : Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              body,
                              style: const TextStyle(fontSize: 17),
                            ),
                            onTap: () {},
                            tileColor:
                                isRead ? Colors.grey.shade200 : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                      bottom: 5,
                      right: 10,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          overlayColor: Colors.white,
                          backgroundColor: Colors.white, // White text
                          elevation: 7,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side:
                              const BorderSide(color: Colors.black26, width: 1),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                        ).copyWith(
                          shadowColor: WidgetStateProperty.all(
                              Colors.black.withOpacity(0.3)),
                        ),
                        onPressed: () {
                          if (!isRead) {
                            if (mounted) {
                              _markAsRead(notificationId); // Mark as read
                            }
                          }
                        },
                        child:  Text(AppLocalizations.of(context)!.mark_as_read),
                      )),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
