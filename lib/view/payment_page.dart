import 'package:art_elevate/views/mainpage/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:art_elevate/l10n/app_localizations.dart';

class PaymentPage extends StatefulWidget {
  final String imageUrl;
  final String itemName;
  final String itemPrice;
  const PaymentPage({
    super.key,
    required this.imageUrl,
    required this.itemName,
    required this.itemPrice,
  });
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future _showDialog(BuildContext context) {
    if (!mounted) return Future.value();
    final BuildContext? scaffoldContext = _scaffoldKey.currentContext;

    if (scaffoldContext == null) {
      return Future.value();
    }
    return showDialog(
      context: scaffoldContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BottomNavBar()),
            );
          }
        });
        return AlertDialog(
          titlePadding: const EdgeInsets.only(top: 30, left: 25, right: 25),
          contentPadding:
              const EdgeInsets.only(top: 25, left: 25, right: 25, bottom: 35),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            'Thank you for the Order ',
            style: GoogleFonts.poppins(
              fontSize: 22,
            ),
          ),
          content: Text(
            'Keep shopping with us.',
            style: GoogleFonts.poppins(
              fontSize: 16,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(AppLocalizations.of(context)!.payment),
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 21,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              title: Row(
                children: [
                  const Icon(FontAwesomeIcons.creditCard),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Credit/Debit/ATM Card',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              title: Row(
                children: [
                  const Icon(FontAwesomeIcons.googlePay),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    'UPI',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              title: Row(
                children: [
                  const Icon(FontAwesomeIcons.indianRupeeSign),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Cash on Delivery',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 50,
          child: TextButton(
            onPressed: () {
              _showDialog(context);
            },
            style: TextButton.styleFrom(
              overlayColor: Colors.black,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                side: BorderSide(color: Colors.black, width: 1.2),
              ),
            ),
            child: Text(
              'Place Order',
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
