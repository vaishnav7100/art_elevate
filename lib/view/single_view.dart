import 'dart:developer';

import 'package:art_elevate/chats/messagepage.dart';
import 'package:art_elevate/views/constant.dart';
import 'package:art_elevate/views/mainpage/user_profile.dart';
import 'package:art_elevate/views/mainpage/username.dart';
import 'package:art_elevate/view/order_summary.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:art_elevate/l10n/app_localizations.dart';

class SingleView extends StatefulWidget {
  final String imageUrl;
  final String itemName;
  final String itemPrice;
  final String itemRating;
  final String itemDescription;
  final String itemSize;
  final String username;
  final String productId;

  const SingleView({
    super.key,
    required this.imageUrl,
    required this.itemName,
    required this.itemPrice,
    required this.productId,
    required this.username,
    this.itemRating = '0',
    required this.itemDescription,
    required this.itemSize,
  });

  @override
  State<SingleView> createState() => _SingleViewState();
}

class _SingleViewState extends State<SingleView> {
  List<String> art = [
    'Pencil Portrait',
    'Vector art',
    'Watercolor',
    'Stencil art',
    'Pen Portrait',
  ];

  bool _isWishlisted = false;
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> _onTapWishlist() async {
    CollectionReference wishlistRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('wishlistedItems');
    if (_isWishlisted) {
      final querySnapshot = await wishlistRef
          .where('productId', isEqualTo: widget.productId)
          .get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } else {
      await wishlistRef.add({
        'username': widget.username,
        'productId': widget.productId,
        'title': widget.itemName,
        'price': widget.itemPrice,
        'size': widget.itemSize,
        'description': widget.itemDescription,
        'rating': widget.itemRating,
        'image': widget.imageUrl,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
    setState(() {
      _isWishlisted = !_isWishlisted;
    });
  }

  Future<void> chechWishlisted() async {
    final wishlistRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('wishlistedItems');
    final querySnapshot =
        await wishlistRef.where('productId', isEqualTo: widget.productId).get();
    setState(() {
      _isWishlisted = querySnapshot.docs.isNotEmpty;
    });
  }

  bool _addToCart = false;

  void _onTapAddToCart() {
    setState(() {
      _addToCart = !_addToCart;
    });
  }

  String userName = "";
  String userID = '';

  Future<void> _fetchUserEmail() async {
    try {
      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
          .collection(widget.itemName)
          .doc(widget.productId)
          .get();
      if (productSnapshot.exists) {
        var data = productSnapshot.data() as Map<String, dynamic>;
        // log('Fetched userName: ${data['username']}',
        // ); // Debugging

        setState(() {
          userName = data['username'];
        });
      } else {
        // Handle the case when the product does not exist
        log('Product not found');
      }
    } catch (e) {
      log('Error fetching product data: $e');
    }
  }

  Future<String> getUserID(String username) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: username)
        .get();
    log(username);

    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot userDoc = snapshot.docs.first;
      String uid = userDoc['uid'];
      log(uid);
      return uid;
    } else {
      return '';
    }
  }

  Future<void> _fetchUserID() async {
    String fetchUserID = await getUserID(userName);
    // log(fetchUserID);
    if (fetchUserID == false) {
      // Handle the case where the userID is null (e.g., show an error message or set a default value)
      setState(() {
        userID = ''; // Set it to null explicitly
      });
    }
    setState(() {
      userID = fetchUserID;
    });
  }

  final TextEditingController _reportController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  getUserId() {
    if (user != null) {
      return user!.uid;
    }
  }

  Future<void> sendReportingMessage() async {
    String reportedID = await getUserID(userName);
    await FirebaseFirestore.instance.collection('reported_users').add({
      'reporterID': getUserId().toString(),
      'reporterEmail': user!.email,
      'reportedEmail': userName,
      'reportedID': reportedID,
      'reason': "Reported on Artwork : ${_reportController.text}",
      'timestamp': Timestamp.now(),
    });
    _reportController.clear();
  }

  void _showReportDialog() {
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
            "Report this artwork?",
            style: GoogleFonts.poppins(color: Colors.black, fontSize: 19),
          ),
          actions: [
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _reportController,
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a reason';
                  }
                  return null;
                },
                scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                cursorColor: Colors.black,
                cursorOpacityAnimates: true,
                cursorWidth: 1,
                onTapOutside: (PointerDownEvent event) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  labelText: 'Reason',
                  labelStyle: GoogleFonts.notoSans(
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  style: TextButton.styleFrom(overlayColor: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(overlayColor: Colors.black),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)!
                              .report_sent_successfully),
                          backgroundColor: Colors.green,
                        ),
                      );
                      sendReportingMessage();
                    }
                  },
                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchUserEmail().then((_) {
      _fetchUserID();
    });
    chechWishlisted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: kprimaryColor,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle the menu item selection here
              if (value == 'report') {
                _showReportDialog();
              }
            },
            icon: const Icon(Icons.more_vert), // Three dots icon
            color: Colors.grey[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            itemBuilder: (context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'report',
                child: Row(
                  children: [
                    Text(
                      'Report ',
                      style: TextStyle(fontSize: 16),
                    ),
                    Icon(Icons.flag_outlined)
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 400,
                  child: Hero(
                    tag: '${widget.productId}Tag',
                    // child: Image.network(
                    //   widget.imageUrl,
                    //   fit: BoxFit.contain,
                    // ),
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.black), // Progress color
                              backgroundColor: Colors
                                  .white, // Background color of the circle
                              strokeWidth: 5.0)),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
                Positioned(
                  top: 348,
                  right: 5,
                  child: IconButton(
                    style: const ButtonStyle(
                        splashFactory: NoSplash.splashFactory),
                    icon: Icon(
                      _isWishlisted ? Icons.favorite : Icons.favorite_border,
                      color: _isWishlisted ? Colors.red : Colors.black,
                      size: 30,
                    ),
                    onPressed: _onTapWishlist,
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7),
              child: Text(
                widget.itemName,
                // 'Graphite pencil drawing',
                style: GoogleFonts.poppins(fontSize: 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "₹${widget.itemPrice}",
                    style: GoogleFonts.montserrat(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  RatingBarIndicator(
                    rating: double.tryParse(widget.itemRating) ??
                        0.0, // Convert the string to double
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 25,
                    direction: Axis.horizontal,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: SizedBox(
                height: 20,
                child: Text(
                  'Size : ${widget.itemSize}',
                  style: GoogleFonts.montserrat(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: SizedBox(
                child: Text(
                  ' ${widget.itemDescription}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const Divider(
              color: Colors.black54,
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfile(
                      username: userName,
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 10.0, top: 8, bottom: 8),
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        userName,
                        style: GoogleFonts.poppins(fontSize: 20),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: Icon(Icons.arrow_forward_ios_outlined),
                  )
                ],
              ),
            ),
            const Divider(
              color: Colors.black54,
            ),
          ],
        ),
      ),
      bottomNavigationBar: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 50,
                width: 190,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessagePage(
                          receiverEmail: userName,
                          receiverID: userID,
                        ),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    overlayColor: Colors.black,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      side: BorderSide(color: Colors.black),
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Chat',
                          style: GoogleFonts.poppins(
                              fontSize: 20, color: Colors.black),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.message_outlined,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                width: 190,
                child: TextButton(
                  style: TextButton.styleFrom(
                    overlayColor: Colors.black,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      side: BorderSide(color: Colors.black),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderSummary(
                          userId: userID,
                          itemPrice: widget.itemPrice,
                          itemName: widget.itemName,
                          itemUrl: widget.imageUrl,
                          itemRating: widget.itemRating,
                          productId: widget.productId,
                        ),
                      ),
                    );
                  },
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Buy now',
                          style: GoogleFonts.poppins(
                              fontSize: 20, color: Colors.black),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
