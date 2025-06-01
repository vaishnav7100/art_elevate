import 'package:art_elevate/views/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:art_elevate/l10n/app_localizations.dart';

class ReturnPolicy extends StatelessWidget {
  const ReturnPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(AppLocalizations.of(context)!.returnPolicy),
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
            color: Colors.black, fontSize: 21, fontWeight: FontWeight.w500),
        backgroundColor: kprimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                '1. Overview of the Policy',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Welcome to our Return Policy page. This section provides important information about how returns are handled for artwork purchased through our platform. We aim to offer a transparent and customer-friendly return process to ensure your satisfaction with your art purchase.',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                '2. Eligibility for Returns',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Artwork may be eligible for return if it is damaged upon arrival or not as described in the listing. We do not accept returns for artworks simply due to change of mind. If your artwork arrives damaged or you believe it is significantly not as described, please contact us within 7 days of receiving your order to initiate a return.',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                '3. Return Process',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'To start the return process, please follow these steps:\n\n1. Contact our customer support team at [support email/phone number] with your order number and details of the issue.\n2. Provide photographic evidence of the damage or discrepancy.\n3. Our team will review your request and provide you with instructions for returning the artwork.\n4. Return the artwork in its original packaging, including all certificates of authenticity or documentation, if applicable.\n5. We will inspect the returned artwork and determine if a refund or exchange is warranted.',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                '4. Refund Information',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'If your return is approved, we will issue a refund to your original payment method. Refunds are typically processed within 7-10 business days of receiving the returned artwork. Please note that shipping costs are non-refundable, and the customer is responsible for return shipping charges unless the return is due to our error or a damaged product.',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                '5. Exchanges',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'We offer exchanges for artworks that are damaged upon arrival or significantly not as described. If you would like to exchange your artwork for another piece, please contact our support team to discuss available options and return instructions.',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                '6. Non-Returnable Items',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Please note that certain items, such as custom artworks or commissioned pieces, are non-returnable unless they arrive damaged or are significantly different from what was agreed upon. This policy is in place to ensure the unique nature of custom and commissioned art is respected.',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                '7. Contact Us',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'For any questions or concerns regarding our return policy, please reach out to our customer support team at [support email/phone number]. We are here to assist you and ensure that your experience with our platform meets your expectations.',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
