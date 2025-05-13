// import 'package:art_elevate/constant.dart';
// import 'package:art_elevate/single/single_view.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class PenPortrait extends StatefulWidget {
//   const PenPortrait({super.key});

//   @override
//   State<PenPortrait> createState() => _PenPortraitState();
// }

// class _PenPortraitState extends State<PenPortrait> {
//   List<String> text = [
//     'pen portrait',
//     'pen portrait',
//     'pen portrait',
//     'pen portrait',
//     'pen portrait',
//     'pen portrait',
//     'pen portrait',
//     'pen portrait',
//   ];
//   List<String> assets = [
//     'assets/pen/pen1.jpeg',
//     'assets/pen/pen2.jpeg',
//     'assets/pen/pen3.jpg',
//     'assets/pen/pen4.jpeg',
//     'assets/pen/pen5.jpeg',
//     'assets/pen/pen6.webp',
//     'assets/pen/pen7.jpeg',
//     'assets/pen/pen8.jpeg',
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
//                     imageUrl: assets[index],
//                     itemName: text[index],
//                     itemPrice: price[index],
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
