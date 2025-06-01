import 'package:art_elevate/views/mainpage/category_product.dart';
import 'package:art_elevate/views/pages/categories/pen.dart';
import 'package:art_elevate/views/pages/categories/pencil_portrait.dart';
import 'package:art_elevate/views/pages/categories/stencil.dart';
import 'package:art_elevate/views/pages/categories/vector_art.dart';
import 'package:art_elevate/views/pages/categories/watercolor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:art_elevate/l10n/app_localizations.dart';

class viewAll extends StatefulWidget {
  const viewAll({super.key});

  @override
  State<viewAll> createState() => _viewAllState();
}

class _viewAllState extends State<viewAll> {
  // final List<Widget> _pages = [
  //   const PencilPortrait(),
  //   const VectorArt(),
  //   const WaterColor(),
  //   const StencilArt(),
  //   const PenPortrait(),
  // ];
  List<String> assets = [
    'assets/images/img7.jpg',
    'assets/images/pencilportrait12.jpg',
    'assets/images/pencilportrait4.jpg',
    'assets/images/img2.png',
    'assets/images/img4.jpg',
    'assets/images/img3.jpg',
    'assets/images/img5.jpg',
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
  void _onItemTap(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CategoryProduct(category: text[index])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: const Color.fromARGB(255, 232, 232, 232),
        title: Text(
          AppLocalizations.of(context)!.categories,
          style: GoogleFonts.anekBangla(),
        ),
        centerTitle: true,
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 240,
        ),
        itemCount: assets.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _onItemTap(index),
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 150,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    clipBehavior: Clip.antiAlias,
                    height: 195,
                    child: Image.asset(
                      assets[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    text[index],
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
