import 'dart:developer';

import 'package:art_elevate/address/add_address.dart';
import 'package:art_elevate/address/addaddress.dart';
import 'package:art_elevate/address/savedaddress.dart';
import 'package:art_elevate/views/constant.dart';
import 'package:art_elevate/views/mainpage/bottom_nav.dart';
import 'package:art_elevate/view/payment_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class OrderSummary extends StatefulWidget {
  final String userId;
  final String itemUrl;
  final String itemPrice;
  final String itemRating;
  final String itemName;
  final String productId;
  const OrderSummary({
    super.key,
    required this.itemPrice,
    required this.itemName,
    required this.itemUrl,
    required this.productId,
    required this.userId,
    required this.itemRating,
  });

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  bool addressSaved = false;

  void _navigateToAddAddress() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddAddresspdt()),
    );

    if (result == true) {
      // Refresh the OrderSummary page here
      setState(() {
        checkForSavedAddress();
        // Refresh logic (e.g., fetching updated data)
      });
    }
  }

  Future<void> _selectAddress() async {
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("You must be logged in to select an address.")),
      );
      return;
    } else {
      final result = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => const Savedaddress()));
      if (result == true) {
        setState(() {
          checkForSavedAddress();
        });
      }
    }
  }

  User? user = FirebaseAuth.instance.currentUser;

  Stream<List<Map<String, dynamic>>> getAddressData() {
    if (user == null) {
      return Stream.value([]); // Return an empty list if no user is logged in
    }
    // Listen for updates in the user's 'Address' collection in Firestore
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('addresses')
        .where('isDefault', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        var addressData = doc.data();
        return {
          'fullname': addressData['Full Name'] ?? '',
          'phnno': addressData['Phone Number'] ?? '',
          'state': addressData['State'] ?? '',
          'city': addressData['City'] ?? '',
          'house': addressData['House No'] ?? '',
          'landmark': addressData['Landmark'] ?? '',
          'pincode': addressData['Pincode'] ?? '',
        };
      }).toList();
    });
  }

  Future<void> checkForSavedAddress() async {
    bool hasAddress = await hasSavedAddress();
    if (mounted) {
      setState(() {
        addressSaved = hasAddress;
      });
    }
  }

  Future<bool> hasSavedAddress() async {
    if (user == null) {
      return false;
    }
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('addresses')
        .get();
    return snapshot.docs.isNotEmpty;
  }

  Future<String?> _onSubmit() async {
    if (addressSaved) {
      try {
        // Proceed with saving the order, as the address is saved
        var orderRef = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('orders')
            .add({
          "itemName": widget.itemName,
          "itemPrice": widget.itemPrice,
          "image": widget.itemUrl,
          "itemRating": 0,
          "productId": widget.productId,
          "delivered": false,
          "address":
              'Full Name: $fullName \n Phone Number: $phoneNumber \n House No: $houseNo \n City: $city \n State: $state \n Pincode: $pincode \n Landmark: $landmark', // Placeholder for address, you can pass the actual address here
          "Ordered_Date": FieldValue.serverTimestamp(),
        });

        String orderId = orderRef.id;
        return orderId;
      } catch (e) {
        // Handle any errors during the save process
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving order: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a valid address")),
      );
    }
    return null;
  }

  Future<String?> onSubmit() async {
    if (addressSaved) {
      try {
        // Proceed with saving the order, as the address is saved
        var orderRef =
            await FirebaseFirestore.instance.collection('orders').add(
          {
            "itemName": widget.itemName,
            "itemPrice": widget.itemPrice,
            "itemRating": 0,
            "image": widget.itemUrl,
            "productId": widget.productId,
            "userName": user!.email,
            "delivered": false,
            "address":
                'Full Name: $fullName \n Phone Number: $phoneNumber \n House No: $houseNo \n City: $city \n State: $state \n Pincode: $pincode \n Landmark: $landmark', // Placeholder for address, you can pass the actual address here
            "Ordered_Date": FieldValue.serverTimestamp(),
          },
        );

        String orderId = orderRef.id;
        return orderId;
      } catch (e) {
        // Handle any errors during the save process
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving order: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a valid address")),
      );
    }
    return null;
  }

  Future<void> sendNotification(String userId, String imageUrl) async {
    if (landmark.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('order_notifications')
          .add(
        {
          'title': 'You have got a new order!',
          "itemName": widget.itemName,
          "itemPrice": widget.itemPrice,
          'image': imageUrl,
          'delivered': false,
          'body':
              'The details of customer are as follows: \n Full Name: $fullName \n Phone Number: $phoneNumber \n House No: $houseNo \n City: $city \n State: $state \n Pincode: $pincode \n Landmark: $landmark ',
          'timestamp': FieldValue.serverTimestamp(),
          'id': user!.uid,
          'email': user!.email,
          // 'read': false,
        },
      );
    }
    if (landmark.isEmpty) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('order_notifications')
          .add(
        {
          'title': 'You have got a new order!',
          "itemName": widget.itemName,
          "itemPrice": widget.itemPrice,
          'image': imageUrl,
          'delivered': false,
          'body':
              'The details of customer are as follows: \n Full Name: $fullName \n Phone Number: $phoneNumber \n House No: $houseNo \n City: $city \n State: $state \n Pincode: $pincode ',
          'timestamp': FieldValue.serverTimestamp(),
          'id': user!.uid,
          'email': user!.email,
          // 'read': false,
        },
      );
    }
  }

  Razorpay _razorpay = Razorpay();
  @override
  void initState() {
    super.initState();
    checkForSavedAddress();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    log("Payment Success: ${response.paymentId}");
    _onSubmit();
    onSubmit();
    sendNotification(widget.userId, widget.itemUrl);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment successful: ${response.paymentId}")),
    );
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const BottomNavBar(),
        ),
        (Route<dynamic> route) => false);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    log("Payment Failure: ${response.message}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment failed: ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear(); // Removes all listeners
  }

  void openCheckout() {
    var options = {
      'key': 'rzp_test_NOgCj9dZzwwMPK',
      'amount': (double.parse(widget.itemPrice) * 100).toInt(), //in paise.
      'name': widget.itemName,
      'image': widget.itemUrl,
      // 'order_id':orderId, // Generate order_id using Orders API
      // 'order_EMBFqjDHEEn80l', // 'description': 'Fine T-Shirt',
      'timeout': 60, // in seconds
      'prefill': {'contact': '9000090000', 'email': 'gaurav.kumar@example.com'}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening Razorpay: $e')),
      );
    }
  }

  String fullName = '';
  String phoneNumber = '';
  String houseNo = '';
  String landmark = '';
  String city = '';
  String state = '';
  String pincode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: kprimaryColor,
        title: const Text(
          textAlign: TextAlign.center,
          'Order Summary',
        ),
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 21,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 50,
          child: TextButton(
            onPressed: () {
              if (addressSaved) {
                ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text(AppLocalizations.of(context)!.processing_your_order)));
                openCheckout();
              } else {
                ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                    content: Text(AppLocalizations.of(context)!.please_save_your_address)));
              }
            },
            style: TextButton.styleFrom(
              overlayColor: Colors.black,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                side: BorderSide(color: Colors.black, width: 1.2),
              ),
            ),
            child: Text(
              'Order now',
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Deliver to :',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user?.uid)
                        .collection('addresses')
                        .where('isDefault', isEqualTo: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.black), // Progress color
                            backgroundColor:
                                Colors.white, // Background color of the circle
                            strokeWidth: 5.0,
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('${AppLocalizations.of(context)!.error} ${snapshot.error}'),
                        );
                      }
                      if (snapshot.data == null ||
                          snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'No saved address found ',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        );
                      }

                      final snap =
                          snapshot.data!.docs[0].data() as Map<String, dynamic>;
                      fullName = snap['fullName'];
                      phoneNumber = snap['phoneNumber'];
                      houseNo = snap['houseNo'];
                      landmark = snap['landmark'] ?? "";
                      city = snap['city'];
                      state = snap['state'];
                      pincode = snap['pincode'];

                      // if (snap['fullName'] != null) {
                      //   setState(() {
                      //     fullName = snap['fullName'];
                      //   });
                      // }
                      // if (snap['phoneNumber'] != null) {
                      //   setState(() {
                      //     phoneNumber = snap['phoneNumber'];
                      //   });
                      // }
                      // if (snap['houseNo'] != null) {
                      //   setState(() {
                      //     houseNo = snap['houseNo'];
                      //   });
                      // }
                      // if (snap['landmark'] != null) {
                      //   setState(() {
                      //     landmark = snap['landmark'];
                      //   });
                      // }
                      // if (snap['city'] != null) {
                      //   setState(() {
                      //     city = snap['city'];
                      //   });
                      // }
                      // if (snap['state'] != null) {
                      //   setState(() {
                      //     state = snap['state'];
                      //   });
                      // }
                      // if (snap['pincode'] != null) {
                      //   setState(() {
                      //     pincode = snap['pincode'];
                      //   });
                      // }

                      return Flexible(
                        child: Card(
                          color: Colors.white,
                          elevation: 7,
                          shadowColor: Colors.black,
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snap['fullName'] ?? '',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 19,
                                      letterSpacing: 1),
                                ),
                                Text(
                                  snap['houseNo'] ?? "",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17,
                                      letterSpacing: 1),
                                ),
                                if (snap['landmark'] != null &&
                                    snap['landmark'].isNotEmpty)
                                  Text(
                                    snap['landmark'] ?? "",
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 17,
                                        letterSpacing: 1),
                                  ),
                                Text(
                                  snap['city'] ?? "",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17,
                                      letterSpacing: 1),
                                ),
                                Text(
                                  snap['state'] ?? "",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17,
                                      letterSpacing: 1),
                                ),
                                Text(
                                  snap['pincode'] ?? "",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17,
                                      letterSpacing: 1),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  snap['phoneNumber'] ?? "",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17,
                                      letterSpacing: 1),
                                ),
                                const Divider(),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 10.0,
                                    left: 10,
                                    top: 5,
                                  ),
                                  child: SizedBox(
                                    child: GestureDetector(
                                      onTap: _selectAddress,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on_outlined,
                                            size: 20,
                                            color: Colors.black,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            'Select another address',
                                            style: GoogleFonts.anekBangla(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
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
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, left: 10, top: 15),
              child: SizedBox(
                child: GestureDetector(
                  onTap: () => _navigateToAddAddress(),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.add,
                        size: 20,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Add a new address',
                        style: GoogleFonts.anekBangla(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Hero(
                  tag: '${widget.productId}Tag',
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    height: 160,
                    width: 120,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: CachedNetworkImage(
                      imageUrl: widget.itemUrl,
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
                const SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    SizedBox(
                      child: Text(
                        widget.itemName,
                        style: GoogleFonts.poppins(fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      child: Text(
                        "₹${widget.itemPrice}",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
