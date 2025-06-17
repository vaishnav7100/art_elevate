import 'package:art_elevate/views/utils/constant.dart';
import 'package:art_elevate/services/database.dart';
import 'package:art_elevate/views/pages/orderpages/single_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryProduct extends StatefulWidget {
  final String category;
  const CategoryProduct({super.key, required this.category});

  @override
  State<CategoryProduct> createState() => _CategoryProductState();
}

class _CategoryProductState extends State<CategoryProduct> {
  Stream? categoryStream;

  getontheload() async {
    categoryStream = await DatabaseMethods().getProducts(widget.category);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getontheload();
  }

  Widget allProducts() {
    return StreamBuilder(
        stream: categoryStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? SingleChildScrollView(
                  child: GridView.builder(
                    cacheExtent: 999999999,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 260,
                    ),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot ds = snapshot.data.docs[index];
                      return Hero(
                        tag: '${ds.id}Tag',
                        child: Material(
                          type: MaterialType.transparency,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SingleView(
                                            itemDescription:
                                                ds['itemDescription'],
                                            itemSize: ds['itemSize'],
                                            imageUrl: ds['image'],
                                            itemName: ds['title'],
                                            itemPrice: ds['price'],
                                            username: ds['username'],
                                            itemRating:
                                                ds['itemRating'].toString(),
                                            productId: ds.id,
                                          )));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 150,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    clipBehavior: Clip.antiAlias,
                                    height: 195,
                                    // child: Image.network(
                                    //   ds['image'],
                                    //   fit: BoxFit.cover,
                                    // ),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: ds['image'],
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
                                  Text(
                                    ds['title'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "₹" + ds["price"],
                                    style: GoogleFonts.numans(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  //       children: <>[
                                  //         TextSpan(
                                  //           text: '2200',
                                  //           style: GoogleFonts.numans(
                                  //               color: Colors.grey[700],
                                  //               decoration: TextDecoration.lineThrough,
                                  //               fontSize: 16),
                                  //         ),
                                  //          TextSpan(text: '  '),
                                  //         TextSpan(
                                  //           text: price[index],
                                  //           style: GoogleFonts.numans(
                                  //             color: Colors.black,
                                  //             fontWeight: FontWeight.bold,
                                  //             fontSize: 16,

                                  //         ),
                                  //       ],
                                  //     ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              // ? GridView.builder(
              //     padding: EdgeInsets.zero,
              //     gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount: 2,
              //       childAspectRatio: 0.6,
              //       mainAxisSpacing: 10,
              //     ),
              //     itemCount: snapshot.data.docs.length,
              //     itemBuilder: (context, index) {
              //       DocumentSnapshot ds = snapshot.data.docs[index];
              //       return Container(
              //         margin:  EdgeInsets.all(10),
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(20),
              //         ),
              //         child: Column(
              //           children: [
              //             Container(
              //               width: 150,
              //               decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(20)),
              //               clipBehavior: Clip.antiAlias,
              //               height: 195,
              //               child: Image.network(
              //                 ds["image"],
              //                 fit: BoxFit.cover,
              //               ),
              //             ),
              //             Text(
              //               "₹" + ds["price"],
              //               style: GoogleFonts.poppins(),
              //             )
              //           ],
              //         ),
              //       );
              //     },
              //   )
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(widget.category),
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(color: Colors.black, fontSize: 21),
        backgroundColor: kprimaryColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: allProducts()
                .animate(delay: const Duration(milliseconds: 200))
                .fade(begin: 0, end: 1),
          )
        ],
      ),
    );
  }
}
