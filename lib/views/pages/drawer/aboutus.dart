import 'package:art_elevate/l10n/app_localizations.dart';
import 'package:art_elevate/views/constant.dart';
import 'package:flutter/material.dart';
import 'package:art_elevate/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: kprimaryColor,
        title: Text(AppLocalizations.of(context)!.aboutUs),
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
            color: Colors.black, fontSize: 21, fontWeight: FontWeight.w500),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 25),
          Text(
            AppLocalizations.of(context)!.who_are_we,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              AppLocalizations.of(context)!.about_us_description,
              textAlign: TextAlign.justify,
              style: GoogleFonts.poppins(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
