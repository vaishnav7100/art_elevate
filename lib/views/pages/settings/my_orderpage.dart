import 'dart:math';

import 'package:art_elevate/chats/messagepage.dart';
import 'package:art_elevate/views/utils/constant.dart';
import 'package:art_elevate/views/pages/mainpage/bottom_nav.dart';
import 'package:art_elevate/views/pages/orderpages/single_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:art_elevate/l10n/app_localizations.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  User? user = FirebaseAuth.instance.currentUser;
  bool? hasOrdered;
  bool isLoading = false;

  Future<void> getOrdered() async {
    CollectionReference orderRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('orders');
    final snapshot = await orderRef.get();
    if (mounted) {
      setState(() {
        hasOrdered = snapshot.docs.isEmpty;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkSeller();
    getOrdered();
    _fetchNotifications();
  }

  Stream<QuerySnapshot>? notificationsStream;

  bool isSeller = false;

  Future<void> checkSeller() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        var querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: user.uid)
            .where('role', isEqualTo: 'seller')
            .get();
        print('User UID: ${user.uid}');
        print('Query snapshot: ${querySnapshot.docs.length}');

        if (querySnapshot.docs.length.toInt() > 0) {
          if (mounted) {
            setState(() {
              isSeller = true;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              isSeller = false;
            });
          }
        }
      } catch (e) {
        print('Error checking seller: $e');
      }
    }
  }

  void _fetchNotifications() {
    // Get current user ID
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      notificationsStream = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('order_notifications')
          .orderBy('timestamp', descending: true)
          .snapshots();
    }
  }

  void _markAsRead(String notificationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('notifications')
          .doc(notificationId)
          .update({'read': true});
    } catch (e) {
      print("Error marking notification as read: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.shopping_cart_outlined,
              color: Colors.black,
            ),
          )
        ],
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
            color: Colors.black, fontSize: 21, fontWeight: FontWeight.w500),
        title: Text(AppLocalizations.of(context)!.myOrders),
        backgroundColor: kprimaryColor,
      ),
      body: hasOrdered == null
          ? const Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.black), // Progress color
                  backgroundColor:
                      Colors.white, // Background color of the circle
                  strokeWidth: 5.0),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isSeller)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, left: 8),
                      child: Text(
                        AppLocalizations.of(context)!.customer_orders,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  if (isSeller)
                    Flexible(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: notificationsStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black), // Progress color
                                  backgroundColor: Colors
                                      .white, // Background color of the circle
                                  strokeWidth: 5.0),
                            );
                          }

                          if (snapshot.hasError) {
                            return Center(
                                child: Text(
                                    '${AppLocalizations.of(context)!.error} ${snapshot.error}'));
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .no_orders_available,
                                  style: GoogleFonts.poppins(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ),
                            );
                          }

                          var notifications = snapshot.data!.docs;

                          bool allDelivered = notifications.every(
                              (notification) =>
                                  notification['delivered'] == true);

                          if (allDelivered) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .no_orders_available,
                                  style: GoogleFonts.poppins(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: notifications.length,
                            itemBuilder: (context, index) {
                              var notification = notifications[index];
                              bool isDelivered = notification['delivered'];
                              String receiverID = notification['id'];
                              String recieverEmail = notification['email'];
                              // String notificationId = notification.id;
                              String title = notification['title'];
                              String body = notification['body'];
                              // bool isRead = notification['read'] ?? false;
                              String imageUrl = notification['image'];

                              return !isDelivered
                                  ? Card(
                                      color: Colors.white,
                                      margin: const EdgeInsets.all(10),
                                      elevation: 6,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: CachedNetworkImage(
                                                  imageUrl: imageUrl,
                                                  width: 100, // Fixed width
                                                  height: 100, // Fixed height
                                                  fit: BoxFit
                                                      .cover, // Ensures image is scaled correctly
                                                ),
                                              ),
                                              Flexible(
                                                child: ListTile(
                                                  contentPadding:
                                                      const EdgeInsets.all(10),
                                                  title: Text(
                                                    title,
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(body),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    4.0),
                                                        child: Text(
                                                            "Email : $recieverEmail"),
                                                      )
                                                    ],
                                                  ),
                                                  tileColor: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 207.0, bottom: 10),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MessagePage(
                                                              receiverID:
                                                                  receiverID,
                                                              receiverEmail:
                                                                  recieverEmail,
                                                            )));
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 15),
                                                decoration: BoxDecoration(
                                                  color: kprimaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .send_message,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      // child: Center(
                                      //   child: Padding(
                                      //     padding: const EdgeInsets.all(20.0),
                                      //     child: Text(
                                      //       AppLocalizations.of(context)!
                                      //           .no_orders_available,
                                      //       style: GoogleFonts.poppins(
                                      //           color: Colors.black,
                                      //           fontSize: 16),
                                      //     ),
                                      //   ),
                                      // ),
                                      );
                            },
                          );
                        },
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8),
                    child: Text(
                      AppLocalizations.of(context)!.myOrders,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.uid)
                        .collection('orders')
                        .orderBy('Ordered_Date', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.black), // Progress color
                          backgroundColor:
                              Colors.white, // Background color of the circle
                          strokeWidth: 5.0,
                        ));
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  AppLocalizations.of(context)!.oopsNoOrders,
                                  style: GoogleFonts.poppins(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const BottomNavBar()),
                                ),
                                style: ElevatedButton.styleFrom(
                                  overlayColor: Colors.black,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 112, 106, 106)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.shopNow,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                            child: Text(AppLocalizations.of(context)!
                                .errorLoadingOrders));
                      }
                      if (snapshot.hasData) {
                        final orderedItem = snapshot.data!.docs;
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          cacheExtent: 999999999,
                          padding: const EdgeInsets.all(5),
                          itemCount: orderedItem.length,
                          itemBuilder: (BuildContext context, int index) {
                            var item = orderedItem[index];
                            bool hasRated = item['itemRating'] != 0;
                            double currentRating = double.tryParse(
                                    item['itemRating']?.toString() ?? '0.0') ??
                                0.0;
                            String productId = item['productId'] ?? 'defaultId';
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Container(
                                    clipBehavior: Clip.antiAlias,
                                    height: 160,
                                    width: 120,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: CachedNetworkImage(
                                      imageUrl: item['image'],
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const Center(
                                              child: CircularProgressIndicator(
                                        color: Colors.black,
                                      )),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 180,
                                        child: Text(
                                          overflow: TextOverflow.ellipsis,
                                          item['itemName'],
                                          style:
                                              GoogleFonts.poppins(fontSize: 18),
                                        ),
                                      ),
                                      SizedBox(
                                        child: Text(
                                          overflow: TextOverflow.ellipsis,
                                          "₹" + item['itemPrice'],
                                          style: GoogleFonts.montserrat(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      if (!hasRated)
                                        Text(
                                          AppLocalizations.of(context)!
                                              .rate_this_artwork,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      RatingBar.builder(
                                        initialRating: currentRating,
                                        minRating: 0,
                                        direction: Axis.horizontal,
                                        itemCount: 5,
                                        itemSize: 25,
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          double newRating =
                                              (rating + currentRating) / 2;
                                          FirebaseFirestore.instance
                                              .collection(item['itemName'])
                                              .doc(productId)
                                              .update({
                                            'itemRating': newRating,
                                          });

                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(user!.uid)
                                              .collection('orders')
                                              .doc(item.id)
                                              .update({'itemRating': rating});
                                        },
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          try {
                                            var docSnapshot = await FirebaseFirestore
                                                .instance
                                                .collection(item[
                                                    'itemName']) // Collection based on item name
                                                .doc(
                                                    productId) // Document ID (Product ID)
                                                .get();

                                            if (docSnapshot.exists) {
                                              Timestamp timestamp =
                                                  item['Ordered_Date'];
                                              String username = docSnapshot
                                                      .data()?['username'] ??
                                                  ''; // Safely access 'username'

                                              print('Username: $username');
                                              print(timestamp);

                                              QuerySnapshot snapshot =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .doc(user!.uid)
                                                      .collection('orders')
                                                      .where('Ordered_Date',
                                                          isEqualTo: timestamp)
                                                      .where('delivered',
                                                          isEqualTo: false)
                                                      .limit(1)
                                                      .get();

                                              print(
                                                  "users:${snapshot.docs.length}");

                                              if (snapshot.docs.isNotEmpty) {
                                                var doc = snapshot.docs.first;

                                                await doc.reference.update(
                                                    {'delivered': true});
                                              }

                                              QuerySnapshot snap =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('orders')
                                                      .where('userName',
                                                          isEqualTo:
                                                              user!.email)
                                                      .where('delivered',
                                                          isEqualTo: false)
                                                      .limit(1)
                                                      .get();

                                              print(
                                                  "orders:${snap.docs.length}");

                                              if (snap.docs.isNotEmpty) {
                                                var doc = snap.docs.first;

                                                await doc.reference.update(
                                                    {'delivered': true});
                                              }

                                              QuerySnapshot
                                                  orderNotificationSnapshot =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                          'users') // Get users collection
                                                      .where('email',
                                                          isEqualTo:
                                                              username) // Query based on email
                                                      .get(); // Execute query to get the user document(s)
                                              print(
                                                  "noti:${orderNotificationSnapshot.docs.length}");
                                              if (orderNotificationSnapshot
                                                  .docs.isNotEmpty) {
                                                var userDoc =
                                                    orderNotificationSnapshot
                                                        .docs
                                                        .first; // Get the first document (assuming unique email)

                                                QuerySnapshot
                                                    notificationsSnapshot =
                                                    await userDoc.reference
                                                        .collection(
                                                            'order_notifications') // Access the subcollection
                                                        .where('email',
                                                            isEqualTo:
                                                                user!.email)
                                                        .get(); // Get documents in subcollection

                                                print(
                                                    'Notifications found: ${notificationsSnapshot.docs.length}');

                                                if (notificationsSnapshot
                                                    .docs.isNotEmpty) {
                                                  // Get the most recent notification document
                                                  var mostRecentNotification =
                                                      notificationsSnapshot
                                                          .docs.first;

                                                  await mostRecentNotification
                                                      .reference
                                                      .update({
                                                    'delivered': true,
                                                  });

                                                  if (mounted) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            'Order marked as delivered for $username'),
                                                      ),
                                                    );
                                                  }
                                                } else {
                                                  print(
                                                      'No matching notification found');
                                                }
                                              } else {
                                                print('User not found');
                                              }
                                            } else {
                                              print(
                                                  'Product document not found');
                                            }
                                          } catch (e) {
                                            print('Error: $e');
                                            if (mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Failed to mark as delivered'),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.black,
                                          overlayColor: Colors.white,
                                          backgroundColor: Colors.white,
                                          elevation: 7,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          side: const BorderSide(
                                            color: Colors.black26,
                                            width: 1,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                        ).copyWith(
                                          shadowColor: WidgetStateProperty.all(
                                              Colors.black.withOpacity(0.3)),
                                        ),
                                        child: item['delivered']
                                            ? Center(
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .marked_as_delivered,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              )
                                            : Text(AppLocalizations.of(context)!
                                                .mark_as_delivered),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        )
                            .animate(delay: const Duration(milliseconds: 10))
                            .fade(begin: 0, end: 1);
                      }
                      return Center(
                          child:
                              Text(AppLocalizations.of(context)!.noItemsFound));
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
