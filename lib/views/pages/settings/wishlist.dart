import 'package:art_elevate/l10n/app_localizations.dart';
import 'package:art_elevate/views/utils/constant.dart';
import 'package:art_elevate/views/pages/mainpage/bottom_nav.dart';
import 'package:art_elevate/views/pages/orderpages/single_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  User? user = FirebaseAuth.instance.currentUser;
  bool? hasWishlisted;
  Future<void> getWishlisted() async {
    CollectionReference wishlistRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('wishlistedItems');
    final snapshot = await wishlistRef.get();
    setState(() {
      hasWishlisted = snapshot.docs
          .isNotEmpty; // True if there are items in wishlist, false otherwise
    });
  }

  @override
  void initState() {
    super.initState();
    getWishlisted();
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
              Icons.favorite_outline_outlined,
              color: Colors.black,
            ),
          )
        ],
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
            color: Colors.black, fontSize: 21, fontWeight: FontWeight.w500),
        title: Text(AppLocalizations.of(context)!.wishlist),
        backgroundColor: kprimaryColor,
      ),
      body: hasWishlisted == null
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.black), // Progress color
                backgroundColor: Colors.white, // Background color of the circle
                strokeWidth: 5.0,
              ),
            ) // Show loading spinner if state is null
          : hasWishlisted!
              ? StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user!.uid)
                      .collection('wishlistedItems')
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
                    if (snapshot.hasError) {
                      return Center(
                          child: Text(
                              '${AppLocalizations.of(context)!.error} ${snapshot.error}'));
                    }
                    if (snapshot.hasData) {
                      final wishlistedItems = snapshot.data!.docs;
                      return ListView.builder(
                        cacheExtent: 999999999,
                        padding: const EdgeInsets.all(5),
                        itemCount: wishlistedItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          var item = wishlistedItems[index];
                          String productId = item['productId'] ?? 'defaultId';
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SingleView(
                                      imageUrl: item['image'],
                                      itemName: item['title'],
                                      itemPrice: item['price'],
                                      itemDescription: item['description'],
                                      itemSize: item['size'],
                                      itemRating: item['rating'],
                                      productId: productId,
                                      username: item['username'],
                                    ),
                                  ));
                            },
                            child: Padding(
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
                                    // child: Image.network(
                                    //   item['image'],
                                    //   fit: BoxFit.cover,
                                    // ),
                                    child: CachedNetworkImage(
                                      imageUrl: item['image'],
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const Center(
                                              child: CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Colors
                                                              .black), // Progress color
                                                  backgroundColor: Colors
                                                      .white, // Background color of the circle
                                                  strokeWidth: 5.0)),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        child: Text(
                                          item['title'],
                                          style:
                                              GoogleFonts.poppins(fontSize: 18),
                                        ),
                                      ),
                                      SizedBox(
                                        child: Text(
                                          "₹" + item['price'],
                                          style: GoogleFonts.montserrat(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      )
                          .animate(delay: const Duration(milliseconds: 10))
                          .fade(begin: 0, end: 1);
                    }
                    return Center(
                        child:
                            Text(AppLocalizations.of(context)!.no_items_found));
                  },
                )
              : Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      Image.asset(
                        'assets/images/wishlist.png',
                        height: 170,
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                      Text(
                        AppLocalizations.of(context)!.oops_no_items,
                        style: GoogleFonts.poppins(fontSize: 18),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BottomNavBar()),
                        ),
                        style: ElevatedButton.styleFrom(
                          overlayColor: Colors.black,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Color.fromARGB(255, 112, 106, 106)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.add_now,
                          style: GoogleFonts.dmSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      )
                    ],
                  ),
                )
                  .animate(delay: const Duration(milliseconds: 200))
                  .fade(begin: 0, end: 1),
    );
  }
}
