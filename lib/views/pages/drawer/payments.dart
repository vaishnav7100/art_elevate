import 'package:art_elevate/views/constant.dart';
import 'package:art_elevate/views/pages/drawer/myaccount/editupi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class Payments extends StatefulWidget {
  const Payments({super.key});

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  bool isFinished = false;
  bool isDelivered = false;
  int itemPrice = 0;
  String upiId = '';
  String documentId = '';

  void onSwipeCallback() {
    // Add logic for redeeming the amount to the UPI ID
    print("Amount redeemed to UPI ID");
    // You can add your redeem logic here (e.g., API call, transaction logic, etc.)
  }

  void updateUpiId(String newUpiId) {
    setState(() {
      upiId = newUpiId;
    });
  }

  checkPayment() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('payment')
          .get();

      if (snap.docs.isNotEmpty) {
        var paymentDoc = snap.docs[0];

        String docId = paymentDoc.id;

        // Safely retrieve the 'upiId' from the document data
        String upiID = paymentDoc['upiId'] ?? '';

        if (mounted) {
          setState(() {
            documentId = docId;
          });
        }

        if (mounted) {
          setState(() {
            upiId = upiID;
          });
        }
      } else {
        // Handle case where no documents are found
        print('No payment documents found!');
      }
    } else {
      // Handle case where the user is not authenticated
      print('User is not authenticated');
    }
  }

  @override
  void initState() {
    super.initState();
    checkPayment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.payment_rounded,
              color: Colors.black,
            ),
          )
        ],
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
            color: Colors.black, fontSize: 21, fontWeight: FontWeight.w500),
        title: const Text("Payments"),
        backgroundColor: kprimaryColor,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 12.0, top: 10),
            child: Text(
              'Payments pending',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                ),
                child: Text(
                  'UPI ID : $upiId',
                  style: const TextStyle(
                    fontSize: 21,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => EditUpi(
                      onUpiUpdated: updateUpiId,
                      docId: documentId,
                      upiId: upiId,
                    ),
                  );
                },
                icon: const Icon(
                  CupertinoIcons.pencil,
                  size: 26,
                  color: Colors.black,
                ),
              )
            ],
          ),
          Flexible(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('order_notifications')
                  .orderBy('timestamp', descending: true)
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
                          strokeWidth: 5.0));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Text(
                    'No Pending payments found!',
                    style:
                        GoogleFonts.poppins(color: Colors.black, fontSize: 18),
                  ));
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length, // Show multiple docs
                  itemBuilder: (context, index) {
                    var document = snapshot.data!.docs[index];
                    String itemPrice = document['itemPrice'] ?? '0';
                    isDelivered = document['delivered'];
                    return Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.maxFinite,
                            child: Card(
                              color: Colors.grey.shade200,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '₹$itemPrice',
                                      style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.0),
                                      child: Text(
                                        "This can only be redeemed after the artwork is delivered to the customer.",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    if (isDelivered)
                                      SwipeableButtonView(
                                        buttonText: 'Swipe to redeem',
                                        buttontextstyle: GoogleFonts.poppins(
                                            color: Colors.white, fontSize: 18),
                                        buttonWidget: const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Colors.grey,
                                        ),
                                        activeColor: const Color.fromARGB(
                                            255, 8, 193, 85),
                                        isFinished: isFinished,
                                        onWaitingProcess: () {
                                          Future.delayed(
                                              const Duration(seconds: 2), () {
                                            setState(() {
                                              isFinished = true;
                                            });
                                          });
                                        },
                                        onFinish: () async {
                                          setState(() {
                                            isFinished = false;
                                          });
                                        },
                                      ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    if (isDelivered)
                                      const Center(
                                        child: Text(
                                          'The amount will be sent to your UPI ID.',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
