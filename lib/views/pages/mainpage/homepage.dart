import 'dart:developer';

import 'package:art_elevate/views/utils/constant.dart';
import 'package:art_elevate/views/pages/loginpage/login_screen.dart';
import 'package:art_elevate/views/pages/mainpage/bottom_nav.dart';
import 'package:art_elevate/views/pages/mainpage/category_product.dart';

import 'package:art_elevate/views/pages/settings/aboutus.dart';
import 'package:art_elevate/views/pages/settings/become_seller.dart';
import 'package:art_elevate/views/pages/settings/contactus.dart';
import 'package:art_elevate/views/pages/settings/my_artwork.dart';
import 'package:art_elevate/views/pages/settings/myaccount/myaccount.dart';
import 'package:art_elevate/views/pages/settings/my_orderpage.dart';
import 'package:art_elevate/views/pages/settings/myaccount/notification.dart';
import 'package:art_elevate/views/pages/settings/policies/terms_and_policies.dart';
import 'package:art_elevate/views/pages/settings/wishlist.dart';
import 'package:art_elevate/views/pages/mainpage/viewallpage.dart';
import 'package:art_elevate/services/database.dart';
import 'package:art_elevate/views/pages/orderpages/single_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:art_elevate/l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = '';

  List<String> assets = [
    'assets/images/img7.jpg',
    'assets/images/pencilportrait12.jpg',
    'assets/images/pencilportrait4.jpg',
    'assets/images/img2.png',
    'assets/images/img4.jpg',
    'assets/images/img3.jpg',
    'assets/images/img5.jpg',
  ];

  List<String> art = [
    'Graphite Pencil Portrait',
    'Colour Pencil Portrait',
    'Charcoal Pencil Portrait',
    'Vector art',
    'Watercolor',
    'Stencil art',
    'Pen Portrait',
  ];

  List<String> text = [
    'Graphite Pencil Portrait',
    'Colour Pencil Portrait',
    'Charcoal Pencil Portrait',
    'Vector art',
    'Watercolor',
    'Stencil art',
    'Pen Portrait',
  ];

  List<String> categoryName = [
    'Graphite Pencil Portrait',
    'Colour Pencil Portrait',
    'Charcoal Pencil Portrait',
    'Vector art',
    'Watercolor',
    'Stencil art',
    'Pen Portrait',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final TextEditingController _searchController = TextEditingController();

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // User? user;
  // bool isSignedIn = false;
  late Future<List<Map<String, dynamic>>> _itemsFuture;

  int selectedIndex = 0;

  // getUser() async {
  //   try {
  //     User? firebaseUser = _auth.currentUser;
  //     await firebaseUser?.reload();
  //     firebaseUser = _auth.currentUser;

  //     if (firebaseUser != null) {
  //       setState(() {
  //         user = firebaseUser!;
  //         isSignedIn = true;
  //       });
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       setState(() {
  //         isSignedIn = false;
  //       });
  //       showError(AppLocalizations.of(context)!.error_message);
  //     }
  //   }
  // }

  int unreadCount = 0;

  // Fetch unread notifications count
  void _fetchUnreadNotifications() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('notifications')
          .where('read', isEqualTo: false) // Filter unread notifications
          .get();
      if (mounted) {
        setState(() {
          unreadCount = snapshot.docs.length;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // getUser();
    _itemsFuture = DatabaseMethods().getMultipleCollectionsData();
    _fetchUnreadNotifications();
  }

  showError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.error),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.ok),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      drawerEdgeDragWidth: 60,
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              leading: IconButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Notifications(),
                        fullscreenDialog: true),
                  );
                  if (mounted) {
                    _fetchUnreadNotifications();
                  }
                },
                icon: Stack(
                  children: [
                    const Icon(
                      Iconsax.notification_copy,
                      color: Colors.black87,
                      size: 28,
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 247, 31, 15),
                              shape: BoxShape.circle),
                        ),
                      ),
                  ],
                ),
              ),
              floating: true,
              snap: true,
              scrolledUnderElevation: 0,
              forceMaterialTransparency: false,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 8.0,
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Wishlist(),
                          fullscreenDialog: true),
                    ),
                    icon: const Icon(
                      Iconsax.heart_add_copy,
                      color: Colors.black87,
                      size: 28,
                    ),
                  ),
                )
              ],
              backgroundColor: Colors.white,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(15),
                child: TypeAheadField(
                  emptyBuilder: (context) {
                    return ListTile(
                      tileColor: Colors.white,
                      title: Text(
                        '  Item not found!',
                        style: GoogleFonts.poppins(),
                      ),
                    );
                  },
                  itemBuilder: (context, dataitem) {
                    return ListTile(
                      tileColor: Colors.white,
                      title: Text(
                        dataitem,
                        style: GoogleFonts.poppins(),
                      )
                          .animate(delay: const Duration(milliseconds: 200))
                          .fade(begin: 0, end: 1),
                    );
                  },
                  onSelected: (value) {
                    final index = art.indexOf(value);
                    if (index != -1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CategoryProduct(category: categoryName[index]),
                        ),
                      );
                    }
                  },
                  controller: _searchController,
                  suggestionsCallback: (value) {
                    return art.where(
                      (element) {
                        return element.toLowerCase().contains(
                              value.toLowerCase(),
                            );
                      },
                    ).toList();
                  },
                  builder: (context, controller, focusNode) {
                    return Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: TextField(
                        cursorColor: Colors.black,
                        cursorWidth: 1.5,
                        onTapOutside: (PointerDownEvent event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        onTap: () {},
                        controller: _searchController,
                        focusNode: focusNode,
                        onChanged: (text) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          suffixIcon: _searchController.text.isNotEmpty
                              ? Visibility(
                                  child: IconButton(
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.cancel_outlined,
                                        color: Colors.black54),
                                  ),
                                )
                              : null,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          hintText: 'Search by graphite,charcoal & more...',
                          prefixIcon: const Visibility(
                            child: Icon(
                              Icons.search_outlined,
                              size: 22,
                            ),
                          ),
                          hintStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400, fontSize: 15),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                        ),
                      ),
                    );
                  },
                ),
              ),
              centerTitle: true,
              title: Image.asset(
                "assets/design.jpg",
                height: 75,
                width: 75,
              ),
              toolbarHeight: 150,
            ),
          ],
          body: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.all(2)),
                SizedBox(
                  height: 190,
                  width: MediaQuery.of(context).size.width,
                  child: AnimatedContainer(
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[400]!,
                            offset: const Offset(1, 1),
                            blurRadius: 15,
                            spreadRadius: 2),
                      ],
                    ),
                    duration: const Duration(milliseconds: 200),
                    child: FlutterCarousel(
                      items: [
                        Image.asset(
                          'assets/art_craft.png',
                          isAntiAlias: true,
                          fit: BoxFit.fitWidth,
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (BuildContext context) {
                                return const Dialog(
                                  backgroundColor: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(35),
                                    child: SizedBox(
                                      child: Text(
                                        'Graphite Pencil Portrait: A graphite pencil portrait uses various grades of graphite to create realistic, detailed images. The artist works with different hardness levels of pencils to achieve a range of shading, contrast, and textures. This style often emphasizes light and shadow, and can portray very lifelike, intricate features, especially in black-and-white artworks.',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Image.asset(
                            'assets/Graphite.png',
                            isAntiAlias: true,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (BuildContext context) {
                                return const Dialog(
                                  backgroundColor: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(35),
                                    child: SizedBox(
                                        child: Text(
                                      'Colour Pencil Portrait: A color pencil portrait uses colored pencils to create vibrant, realistic, or stylized representations of people. This medium allows for blending of colors to achieve smooth transitions in skin tones and other details, while also adding depth and dimension. Color pencil portraits tend to be more vivid and colorful compared to graphite portraits.',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400),
                                    )),
                                  ),
                                );
                              },
                            );
                          },
                          child: Image.asset(
                            'assets/Color.png',
                            isAntiAlias: true,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (BuildContext context) {
                                return const Dialog(
                                  backgroundColor: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(35),
                                    child: SizedBox(
                                      child: Text(
                                        'Charcoal Pencil Portrait: Charcoal pencil portraits use charcoal, which can be either compressed or vine, to create bold, dramatic images. Charcoal’s rich blacks and the ability to blend smoothly make it ideal for creating high-contrast, expressive portraits. This style often emphasizes emotion and dramatic lighting, with less focus on fine detail compared to graphite.',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Image.asset(
                            'assets/Charcoal.png',
                            isAntiAlias: true,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (BuildContext context) {
                                return const Dialog(
                                  backgroundColor: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(35),
                                    child: SizedBox(
                                      child: Text(
                                        'Vector Art: Vector art is a digital art style where images are created using vector graphics, which are based on mathematical equations. This allows for infinitely scalable images without losing quality. Vector art is often flat, with clean, sharp lines, and vibrant colors. It’s commonly used in logos, illustrations, and stylized portraits.',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Image.asset(
                            'assets/Vector.png',
                            isAntiAlias: true,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (BuildContext context) {
                                return const Dialog(
                                  backgroundColor: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(35),
                                    child: SizedBox(
                                      child: Text(
                                        'Watercolor: Watercolor art involves using water-soluble paints to create transparent layers of color. The fluidity of watercolors allows for soft blending, gradients, and expressive brushstrokes. In portraits, it can be used to create soft, ethereal looks or vibrant, lively depictions. Watercolor portraits often have a more painterly, artistic feel compared to other mediums.',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Image.asset(
                            'assets/Watercolor.png',
                            isAntiAlias: true,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (BuildContext context) {
                                return const Dialog(
                                  backgroundColor: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(35),
                                    child: SizedBox(
                                      child: Text(
                                        'Stencil Art: Stencil art involves cutting out shapes or designs from a material (usually cardboard or plastic) and then applying paint or ink over it to create images. This technique allows for precise, repeatable designs, and can range from simple patterns to complex, layered portraits. It’s often used in street art or graphic design for its bold and graphic quality.',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Image.asset(
                            'assets/Stencil.png',
                            isAntiAlias: true,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (BuildContext context) {
                                return const Dialog(
                                  backgroundColor: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(35),
                                    child: SizedBox(
                                      child: Text(
                                        'Pen Portrait: A pen portrait uses ink pens to create detailed, often linear images. Artists may use fine lines or stippling (dots) to build texture and shading. The technique can range from highly detailed realistic portraits to abstract or minimalist representations. Pen portraits tend to have a sharp, graphic quality and may include intricate patterns or textures.',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Image.asset(
                            'assets/Penportrait.png',
                            isAntiAlias: true,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ],
                      options: FlutterCarouselOptions(
                        enableInfiniteScroll: true,
                        pageSnapping: true,
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        scrollDirection: Axis.horizontal,
                        slideIndicator: CircularSlideIndicator(
                            slideIndicatorOptions: const SlideIndicatorOptions(
                                indicatorRadius: 5,
                                indicatorBorderColor: Colors.grey,
                                currentIndicatorColor: Colors.grey)),
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                //categories
                SizedBox(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(left: 10, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.categories,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.only(left: 20),
                              shadowColor: Colors.transparent,
                              backgroundColor: Colors.transparent,
                              splashFactory: NoSplash.splashFactory),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const viewAll(),
                              )),
                          child: Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.view_all,
                                style: GoogleFonts.poppins(fontSize: 15),
                              ),
                              const Icon(
                                Icons.arrow_forward,
                                size: 20,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 195,
                        width: MediaQuery.of(context).size.width,
                        child: PageView.builder(
                          itemCount: assets.length,
                          padEnds: false,
                          pageSnapping: false,
                          physics: const BouncingScrollPhysics(),
                          controller: PageController(viewportFraction: 0.43),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CategoryProduct(
                                      category: categoryName[index],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      clipBehavior: Clip.antiAlias,
                                      height: 155,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Image.asset(
                                        assets[index],
                                      ),
                                    ),
                                    Text(
                                      text[index],
                                      style: GoogleFonts.poppins(fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                        child: Container(
                          color: Colors.white,
                        ),
                      ),
                      FutureBuilder(
                        future: _itemsFuture,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Shimmer(
                              gradient: const LinearGradient(
                                  colors: [Colors.black45, Colors.white70]),
                              child: SizedBox(
                                height: 195,
                                child: GridView.builder(
                                  padding: const EdgeInsets.all(10),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisExtent: 240),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      width: 150,
                                      height: 195,
                                      margin: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text(
                                    '${AppLocalizations.of(context)!.error} ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(
                                child: Text(AppLocalizations.of(context)!
                                    .no_data_found));
                          }
                          final items = snapshot.data!;
                          return Container(
                            color: Colors.white,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GridView.builder(
                                  cacheExtent: 9999999999,
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(10),
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisExtent: 240),
                                  itemCount: items.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final item = items[index];
                                    String productId =
                                        item['productId'] ?? 'defaultId';
                                    // log('Selected Product ID: $productId'); // Debugging line
                                    double currentRating = double.tryParse(
                                            item['itemRating']?.toString() ??
                                                '0.0') ??
                                        0.0;
                                    return Hero(
                                      tag: '${productId}Tag',
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            // Default value if null
                                            // _fetchUserEmail(productId);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SingleView(
                                                          itemDescription: item[
                                                              'itemDescription'],
                                                          itemSize:
                                                              item['itemSize'],
                                                          itemRating:
                                                              currentRating
                                                                  .toString(),
                                                          imageUrl:
                                                              item['image'],
                                                          itemName:
                                                              item['title'],
                                                          itemPrice:
                                                              item['price'],
                                                          username:
                                                              item['username'],
                                                          productId:
                                                              productId)),
                                            );
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 150,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  clipBehavior: Clip.antiAlias,
                                                  height: 195,
                                                  // child: Image.network(
                                                  //   item['image'],
                                                  //   fit: BoxFit.cover,
                                                  // ),
                                                  child: CachedNetworkImage(
                                                    imageUrl: item['image'],
                                                    fit: BoxFit.cover,
                                                    placeholder: (context,
                                                            url) =>
                                                        const Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                                    valueColor: AlwaysStoppedAnimation<
                                                                            Color>(
                                                                        Colors
                                                                            .black), // Progress color
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white, // Background color of the circle
                                                                    strokeWidth:
                                                                        5.0)),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  ),
                                                ),
                                                Text(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  item['title'],
                                                  style: GoogleFonts.poppins(),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
