import 'package:art_elevate/views/constant.dart';
import 'package:art_elevate/views/pages/drawer/become_seller.dart';
import 'package:art_elevate/views/pages/drawer/myaccount/editartwork.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ArtworkPage extends StatefulWidget {
  const ArtworkPage({super.key});

  @override
  _ArtworkPageState createState() => _ArtworkPageState();
}

class _ArtworkPageState extends State<ArtworkPage> {
  List<String> itemNames = [
    'Graphite Pencil Portrait',
    'Colour Pencil Portrait',
    'Charcoal Pencil Portrait',
    'Vector art',
    'Watercolor',
    'Stencil art',
    'Pen Portrait',
  ];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool hasArtwork = false;
  Future<void> checkHasArtwork() async {
    String currentEmail = _auth.currentUser?.email ?? '';

    for (String category in itemNames) {
      // Fetch the artworks for each category
      final querySnapshot = await _firestore
          .collection(category)
          .where('username', isEqualTo: currentEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          hasArtwork = true; // User has at least one artwork
        });
        break; // No need to check further categories
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkHasArtwork();
    getCurrentUserEmail();
  } // Function to get the current user's email

  Stream<String> getCurrentUserEmail() {
    return _auth.authStateChanges().map((user) {
      return user?.email ?? ''; // Return email when user logs in or updates
    });
  }

  // Function to retrieve the artworks based on category and user email
  Stream<QuerySnapshot> getUserApprovedArtworks(String category, String email) {
    return _firestore
        .collection(category)
        .where('username', isEqualTo: email)
        .where('approved', isEqualTo: true)
        .snapshots(); // Listen for real-time updates
  }

  // Function to retrieve the artworks based on category and user email
  Stream<QuerySnapshot> getArtworks(
      String category, String email, bool approved) {
    return _firestore
        .collection(category)
        .where('username', isEqualTo: email)
        .where('approved', isEqualTo: approved)
        .snapshots(); // Listen for real-time updates
  }

  // Function to retrieve the artworks based on category and user email
  Stream<QuerySnapshot> getUserPendingArtworks(String category, String email) {
    return _firestore
        .collection(category)
        .where('username', isEqualTo: email)
        .where('approved', isEqualTo: false)
        .snapshots(); // Listen for real-time updates
  }

  Future<void> deleteArtwork(String category, String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection(category)
          .doc(documentId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                AppLocalizations.of(context)!.artwork_deleted_successfully)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "${AppLocalizations.of(context)!.error_deleting_artwork} $e")),
      );
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
              Icons.collections_outlined,
              color: Colors.black,
            ),
          )
        ],
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
            color: Colors.black, fontSize: 21, fontWeight: FontWeight.w500),
        title: Text(AppLocalizations.of(context)!.myArtwork),
        backgroundColor: kprimaryColor,
      ),
      body: hasArtwork
          ? SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildArtworkStream(approved: false),
                  buildArtworkStream(approved: true),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.upload_your_artwork,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    )
                        .animate(delay: const Duration(milliseconds: 200))
                        .fade(begin: 0, end: 1),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => const BecomeSellerPage(),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        overlayColor: Colors.black,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.upload_artwork,
                        style: GoogleFonts.dmSans(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    )
                        .animate(delay: const Duration(milliseconds: 200))
                        .fade(begin: 0, end: 1),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildArtworkStream({required bool approved}) {
    return StreamBuilder<String>(
      stream: getCurrentUserEmail(), // Stream for current user's email
      builder: (context, emailSnapshot) {
        if (emailSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Colors.black), // Progress color
              backgroundColor: Colors.white, // Background color of the circle
              strokeWidth: 5.0,
            ),
          );
        }
        if (emailSnapshot.hasError) {
          return Center(
              child: Text(AppLocalizations.of(context)!.error_fetching_email));
        }
        String currentEmail = emailSnapshot.data ?? '';
        return ListView.builder(
          shrinkWrap: true,
          cacheExtent: 1000,
          itemCount: itemNames.length, // Number of categories
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            String category = itemNames[index];
            return StreamBuilder<QuerySnapshot>(
              stream: getArtworks(category, currentEmail, approved),
              builder: (context, artworksSnapshot) {
                if (artworksSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center();
                }
                if (artworksSnapshot.hasError) {
                  return Center(
                      child: Text(AppLocalizations.of(context)!
                          .error_deleting_artwork));
                }
                if (artworksSnapshot.data == null) {
                  return Container();
                }
                final artworks = artworksSnapshot.data?.docs ?? [];
                if (artworks.isEmpty) {
                  return Container();
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category,
                        style: GoogleFonts.poppins(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      ListView.builder(
                        cacheExtent: 1000,
                        shrinkWrap: true, // To avoid full screen usage
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: artworks.length,
                        itemBuilder: (context, artworkIndex) {
                          var artwork = artworks[artworkIndex];
                          var documentId = artwork.id;
                          return Stack(
                            children: [
                              Card(
                                color: Colors.white,
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        clipBehavior: Clip.antiAlias,
                                        height: 160,
                                        width: 120,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: CachedNetworkImage(
                                          imageUrl: artwork['image'],
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator(
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
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              child: Text(
                                                artwork['title'],
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Text(
                                              "₹" + artwork['price'],
                                              style: GoogleFonts.montserrat(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              "Size : ${artwork['itemSize']}",
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                              artwork['itemDescription'],
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 8),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: approved
                                                      ? Colors.green.shade700
                                                      : Colors.red.shade800,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                width: 100,
                                                child: Center(
                                                  child: Text(
                                                    approved
                                                        ? 'Approved'
                                                        : 'Pending',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      tooltip: AppLocalizations.of(context)!
                                          .delete_this_artwork,
                                      onPressed: () {
                                        deleteArtwork(category, documentId);
                                      },
                                      icon: const Icon(
                                        CupertinoIcons.delete,
                                        size: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                    IconButton(
                                      tooltip: "Edit this artwork",
                                      onPressed: () {
                                        // Show the EditArtworkPopup
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              EditArtworkPopup(
                                            documentId: documentId,
                                            currentCategory: category,
                                            currentTitle: artwork['title'],
                                            currentPrice: artwork['price'],
                                            currentSize: artwork['itemSize'],
                                            currentDescription:
                                                artwork['itemDescription'],
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        CupertinoIcons.pencil,
                                        size: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
