import 'package:art_elevate/views/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
            color: Colors.black, fontSize: 21, fontWeight: FontWeight.w500),
        title: Text(AppLocalizations.of(context)!.termsAndConditions),
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
                '1. Introduction',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Welcome to [Your Art Platform]! These Terms and Conditions ("Terms") govern your use of our platform and services. By accessing or using our platform, you agree to be bound by these Terms. If you do not agree with any part of these Terms, please do not use our platform.',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                '2. Use of Our Platform',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'You must be at least 18 years old to use our platform. By using our platform, you agree to provide accurate and complete information and to keep your account details secure. You are responsible for all activities that occur under your account.',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                '3. Purchase of Artwork',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'All artwork available on our platform is subject to availability. Once you place an order, you will receive a confirmation email detailing your purchase. Prices are subject to change without notice. We reserve the right to cancel or modify orders if there are errors in pricing or availability.',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                '4. Payment Terms',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Payments for artwork are processed through secure payment gateways. You agree to provide valid and accurate payment information. All transactions are subject to verification and approval, and we reserve the right to refuse or cancel any transaction if necessary.',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                '5. Shipping and Delivery',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Shipping costs are calculated based on the size, weight, and destination of the artwork. We will make every effort to deliver your artwork in a timely manner. Delivery times may vary depending on your location and shipping method chosen. Please refer to our Shipping Policy for more details.',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                '6. Returns and Refunds',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Returns are accepted only if the artwork arrives damaged or is significantly not as described. For more information on how to initiate a return and our refund process, please refer to our Return Policy. Refunds will be issued to the original payment method once we receive and inspect the returned item.',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                '7. Intellectual Property',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'All content on our platform, including artwork images, descriptions, and other materials, is protected by intellectual property laws. You may not use, reproduce, or distribute any content from our platform without prior written permission from us or the respective rights holders.',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                '8. User Conduct',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'You agree not to use our platform for any unlawful purpose or in any way that could damage, disable, or impair the platform. You are responsible for your interactions with other users and for ensuring that your use of the platform complies with these Terms and all applicable laws.',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                '9. Limitation of Liability',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'To the fullest extent permitted by law, [Your Art Platform] shall not be liable for any indirect, incidental, special, or consequential damages arising from your use of the platform or any content provided. Our total liability for any claims arising out of or related to your use of the platform shall be limited to the amount paid by you for the artwork in question.',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                '10. Changes to Terms',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'We reserve the right to update or modify these Terms at any time. Any changes will be posted on this page, and your continued use of the platform after any such changes constitutes your acceptance of the new Terms. We encourage you to review these Terms periodically.',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                '11. Governing Law',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'These Terms are governed by and construed in accordance with the laws of [Your Country/State]. Any disputes arising from these Terms or your use of the platform shall be resolved in the courts located in [Your City/State].',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                '12. Contact Us',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'If you have any questions or concerns regarding these Terms and Conditions, please contact us at [support email/phone number]. We are here to assist you and provide any necessary support.',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
