import 'package:art_elevate/address/addaddress.dart';
import 'package:art_elevate/constant.dart';
import 'package:art_elevate/pages/pages/drawer/myaccount/myaccount.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Savedaddress extends StatefulWidget {
  const Savedaddress({
    super.key,
  });

  @override
  State<Savedaddress> createState() => _SavedaddressState();
}

class _SavedaddressState extends State<Savedaddress> {
  List<Map<String, dynamic>> addressList = [];
  late String selectedAddress;

  @override
  void initState() {
    super.initState();
    selectedAddress = '';
  }

  void addAddress(String newAddress) {
    addressList.add(newAddress as Map<String, dynamic>);
    selectedAddress = newAddress;
  }

  User? user = FirebaseAuth.instance.currentUser;

  Future<int?> noOfAddress() async {
    User? user = FirebaseAuth.instance.currentUser;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('addresses')
        .get();
    return snapshot.docs.length;
  }

  Future<Map<String, dynamic>> getAddressData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return {
        'count': 0,
        'addresses': []
      }; // If no user is logged in, return empty data
    }

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('addresses')
        .get();

    // Extract the address data from the snapshot
    List<Map<String, dynamic>> addresses = snapshot.docs.map((doc) {
      var addressData = doc.data() as Map<String, dynamic>;

      return {
        'fullname': addressData['fullName'] ?? '',
        'phnno': addressData['phoneNumber'] ?? '',
        'state': addressData['state'] ?? '',
        'city': addressData['city'] ?? '',
        'house': addressData['houseNo'] ?? '',
        'landmark': addressData['landmark'] ?? '',
      };
    }).toList();

    // Return both the count of addresses and the addresses themselves
    return {'count': addresses.length, 'addresses': addresses};
  }

  Future<int?> getAddressCount() async {
    return await noOfAddress(); // Call the asynchronous function
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('addresses')
          .doc(addressId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                AppLocalizations.of(context)!.address_deleted_successfully)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "${AppLocalizations.of(context)!.error_deleting_address}$e")),
      );
    }
  }

  Future<void> makeDefault(String addressId) async {
    try {
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!.user_need_to_login)),
        );
      }
      final addressRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('addresses');
      await addressRef.get().then((snapshot) async {
        for (var doc in snapshot.docs) {
          await doc.reference.update({'isDefault': false});
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(AppLocalizations.of(context)!.address_made_default)),
        );
      });
      await addressRef.doc(addressId).update({'isDefault': true});
    } catch (e) {
      print('${AppLocalizations.of(context)!.error_making_default_address}$e');
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
              Icons.location_on_outlined,
              color: Colors.black,
            ),
          )
        ],
        backgroundColor: kprimaryColor,
        title: Text(AppLocalizations.of(context)!.my_addresses),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          color: Colors.black,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true); // Pass 'true' when navigating back
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Section for saved addresses
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                AppLocalizations.of(context)!.saved_addresses,
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(fontSize: 18),
              ),
            ),
            const Divider(),
            FutureBuilder(
              future: getAddressCount(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Shimmer(
                    gradient: const LinearGradient(
                        colors: [Colors.black45, Colors.white70]),
                    child: Card(
                      child: Container(
                        height: 200,
                      ),
                    ),
                  );
                }

                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user?.uid)
                      .collection('addresses')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                          child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'No Saved address found!',
                          style: GoogleFonts.poppins(
                              color: Colors.black, fontSize: 18),
                        ),
                      ));
                    }
                    if (snapshot.hasData) {
                      final snap = snapshot.data!.docs;
                      return Column(
                        children: [
                          ListView.builder(
                            cacheExtent: 999999999,
                            physics:
                                const NeverScrollableScrollPhysics(), // Disable internal scrolling
                            shrinkWrap: true,
                            itemCount: snap.length,
                            itemBuilder: (BuildContext context, int index) {
                              String addressId = snap[index].id;
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () async {
                                  await makeDefault(addressId);
                                  if (mounted) {
                                    Navigator.pop(context, true);
                                  }
                                },
                                child: Card(
                                  color: Colors.white,
                                  elevation: 5,
                                  child: ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 31,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                snap[index]['fullName'],
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 19,
                                                  letterSpacing: 1,
                                                ),
                                              ),
                                              IconButton(
                                                  tooltip: AppLocalizations.of(
                                                          context)!
                                                      .delete_this_address,
                                                  onPressed: () =>
                                                      deleteAddress(addressId),
                                                  icon: const Icon(Icons
                                                      .delete_forever_rounded))
                                            ],
                                          ),
                                        ),
                                        Text(
                                          snap[index]['houseNo'],
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        Text(
                                          snap[index]['city'],
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        if (snap[index]['landmark'] != null &&
                                            snap[index]['landmark'].isNotEmpty)
                                          Text(
                                            snap[index]['landmark'],
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 17,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        Text(
                                          snap[index]['state'],
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        Text(
                                          snap[index]['pincode'],
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        Text(
                                          snap[index]['phoneNumber'],
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17,
                                            letterSpacing: 1,
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
                      );
                    }
                    return const SizedBox();
                  },
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 10.0, left: 5, top: 5),
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddAddress(),
                  ),
                ),
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
                      AppLocalizations.of(context)!.add_a_new_address,
                      style: GoogleFonts.anekBangla(
                          fontSize: 18, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
