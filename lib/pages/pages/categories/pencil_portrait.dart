// import 'package:art_elevate/constant.dart';
// import 'package:art_elevate/single/single_view.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class PencilPortrait extends StatefulWidget {
//   const PencilPortrait({super.key});

//   @override
//   State<PencilPortrait> createState() => _PencilPortraitState();
// }

// class _PencilPortraitState extends State<PencilPortrait> {
//   List<String> assets = [
//     'assets/pencil_portrait/pencilportrait16.jpg',
//     'assets/pencil_portrait/pencilportrait3.jpg',
//     'assets/pencil_portrait/pencilportrait4.jpg',
//     'assets/pencil_portrait/pencilportrait5.jpg',
//     'assets/pencil_portrait/pencilportrait6.jpg',
//     'assets/pencil_portrait/pencilportrait7.jpg',
//     'assets/pencil_portrait/pencilportrait8.webp',
//     'assets/pencil_portrait/pencilportrait9.webp',
//     'assets/pencil_portrait/pencilportrait10.webp',
//     'assets/pencil_portrait/pencilportrait11.webp',
//     'assets/pencil_portrait/pencilportrait12.jpg',
//     'assets/pencil_portrait/pencilportrait13.jpeg',
//     'assets/pencil_portrait/pencilportrait14.jpg',
//     'assets/pencil_portrait/pencilportrait15.jpg',
//   ];
//   List<String> text = [
//     'Charcoal Pencil Portrait',
//     'Charcoal Pencil Portrait',
//     'Charcoal Pencil Portrait',
//     'Colour Pencil Portrait',
//     'Graphite Pencil Portrait',
//     'Graphite Pencil Portrait',
//     'Graphite Pencil Portrait',
//     'Charcoal Pencil Portrait',
//     'Charcoal Pencil Portrait',
//     'Charcoal Pencil Portrait',
//     'Colour Pencil Portrait',
//     'Colour Pencil Portrait',
//     'Colour Pencil Portrait',
//     'Colour Pencil Portrait',
//   ];

//   List<String> price = [
//     '₹1350',
//     '₹1400',
//     '₹1550',
//     '₹1400',
//     '₹1200',
//     '₹1700',
//     '₹1600',
//     '₹1500',
//     '₹2000',
//     '₹1200',
//     '₹1300',
//     '₹1400',
//     '₹1250',
//     '₹1399',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: kprimaryColor,
//       ),
//       body: GridView.builder(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           mainAxisExtent: 260,
//         ),
//         itemCount: assets.length,
//         itemBuilder: (BuildContext context, int index) {
//           return GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => SingleView(
//                      itemDescription: '',
//                     itemSize: '',
//                     itemPrice: price[index],
//                     imageUrl: assets[index],
//                     itemName: text[index],
//                     productId: '',
//                     username: '',
//                   ),
//                 ),
//               );
//             },
//             child: Container(
//               padding: const EdgeInsets.all(10),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     width: 150,
//                     decoration:
//                         BoxDecoration(borderRadius: BorderRadius.circular(20)),
//                     clipBehavior: Clip.antiAlias,
//                     height: 195,
//                     child: Image.asset(
//                       assets[index],
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   Text(
//                     text[index],
//                     style: GoogleFonts.poppins(
//                       fontSize: 15,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   RichText(
//                     text: TextSpan(
//                       children: <TextSpan>[
//                         TextSpan(
//                           text: '2200',
//                           style: GoogleFonts.numans(
//                               color: Colors.grey[700],
//                               decoration: TextDecoration.lineThrough,
//                               fontSize: 16),
//                         ),
//                         const TextSpan(text: '  '),
//                         TextSpan(
//                           text: price[index],
//                           style: GoogleFonts.numans(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
