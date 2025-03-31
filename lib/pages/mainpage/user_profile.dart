import 'dart:developer';

import 'package:art_elevate/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class UserProfile extends StatefulWidget {
  final String username;

  const UserProfile({
    super.key,
    required this.username,
  });

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String userName = "";
  String date = "";

  Future<void> fetchJoined() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: widget.username)
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot userDoc = snapshot.docs[0];
      Timestamp timestamp = userDoc['joinedDate'];
      DateTime creationDate = timestamp.toDate();
      String formattedDate = DateFormat('MM-yyyy').format(creationDate);
      setState(() {
        date = formattedDate;
      });
    }
  }

  Future<List<DocumentSnapshot>> getArtworks(String category) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(category)
        .where('username', isEqualTo: widget.username)
        .get();
    return snapshot.docs;
  }

  List<String> itemNames = [
    'Graphite Pencil Portrait',
    'Colour Pencil Portrait',
    'Charcoal Pencil Portrait',
    'Vector art',
    'Watercolor',
    'Stencil art',
    'Pen Portrait',
  ];

  @override
  void initState() {
    super.initState();
    fetchJoined();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: kprimaryColor,
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 20),
              child: Text(
                widget.username,
                style: GoogleFonts.poppins(color: Colors.black, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 15),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    size: 22,
                  ),
                  Text(
                    ' Member since $date',
                    style: GoogleFonts.ptSans(color: Colors.black),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                ' Artworks',
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Column(
              children: [
                ListView.builder(
                  cacheExtent: 999999999,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: itemNames.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FutureBuilder<List<DocumentSnapshot>>(
                      future: getArtworks(itemNames[index]),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Shimmer(
                              gradient: const LinearGradient(
                                  colors: [Colors.black45, Colors.white70]),
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                height: 160,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: 3,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: const Card(
                                        elevation: 7,
                                        clipBehavior: Clip.antiAlias,
                                        color: Colors.white,
                                        child: Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                height: 160,
                                                width: 120,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ));
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('${AppLocalizations.of(context)!.error}${snapshot.error}'));
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const SizedBox();
                        }
                        List<DocumentSnapshot> artworks = snapshot.data!;
                        return Column(
                          children: [
                            ListView.builder(
                              cacheExtent: 999999999,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: artworks.length,
                              itemBuilder: (BuildContext context, int index) {
                                var artwork = artworks[index].data()
                                    as Map<String, dynamic>;
                                return Card(
                                  color: Colors.white,
                                  elevation: 5,
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
                                          //   artwork['image'],
                                          //   fit: BoxFit.cover,
                                          // ),
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
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  child: Text(
                                                    "${artwork['title']}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 18),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "₹${artwork['price']}",
                                              style: GoogleFonts.montserrat(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
