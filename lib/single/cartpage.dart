// import 'package:art_elevate/single/order_summary.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class CartPage extends StatefulWidget {
//   final String itemUrl;
//   final String itemPrice;
//   final String itemName;
//   const CartPage(
//       {super.key,
//       required this.itemPrice,
//       required this.itemName,
//       required this.itemUrl});

//   @override
//   State<CartPage> createState() => _CartPageState();
// }

// class _CartPageState extends State<CartPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text(
//           textAlign: TextAlign.center,
//           'Cart',
//         ),
//         titleTextStyle: GoogleFonts.poppins(
//           color: Colors.black,
//           fontSize: 21,
//         ),
//       ),
//       bottomNavigationBar: widget.itemUrl.isEmpty
//           ? null
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: SizedBox(
//                 height: 50,
//                 child: TextButton(
//                   onPressed: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => OrderSummary(
//                         userId: '',
//                         productId: '',
//                         itemPrice: widget.itemPrice,
//                         itemName: widget.itemName,
//                         itemUrl: widget.itemUrl,
//                       ),
//                     ),
//                   ),
//                   style: TextButton.styleFrom(
//                     overlayColor: Colors.black,
//                     shape: const RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(12)),
//                       side: BorderSide(color: Colors.black, width: 1.2),
//                     ),
//                   ),
//                   child: Text(
//                     'Order now',
//                     style: GoogleFonts.poppins(
//                       fontSize: 20,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: widget.itemUrl.isEmpty
//             ? Center(
//                 child: Text(
//                   "No items in the cart.",
//                   style: GoogleFonts.poppins(fontSize: 18),
//                 ),
//               )
//             : ListView.builder(
//                 itemCount: 1,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Row(
//                     children: [
//                       Container(
//                         clipBehavior: Clip.antiAlias,
//                         height: 160,
//                         width: 120,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Image.asset(
//                           widget.itemUrl,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 20,
//                       ),
//                       Column(
//                         children: [
//                           SizedBox(
//                             child: Text(
//                               widget.itemName,
//                               style: GoogleFonts.poppins(fontSize: 18),
//                             ),
//                           ),
//                           SizedBox(
//                             child: Text(
//                               widget.itemPrice,
//                               style: GoogleFonts.poppins(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   );
//                 },
//               ),
//       ),
//     );
//   }
// }
