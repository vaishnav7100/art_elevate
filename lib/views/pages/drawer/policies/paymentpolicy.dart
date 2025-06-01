import 'package:art_elevate/views/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:art_elevate/l10n/app_localizations.dart';

class PaymentPolicy extends StatelessWidget {
  const PaymentPolicy({super.key});

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
        title: Text(AppLocalizations.of(context)!.paymentPolicy),
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
                '1. Overview',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Welcome to our Payment Policy page. Here, we provide important details about our payment process for purchasing artwork. This policy covers accepted payment methods, payment processing times, and information about refunds and returns specific to art purchases.',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                '2. Accepted Payment Methods',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'We accept a variety of payment methods, including major credit and debit cards (Visa, MasterCard, American Express), PayPal, and other secure online payment systems. Please ensure that your payment method is valid and has sufficient funds before finalizing your purchase.',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                '3. Payment Processing',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Once your payment is processed, you will receive a confirmation email with details of your transaction and an invoice for your purchase. Payment processing is usually immediate; however, in some cases, it may take up to 24 hours for the payment to be fully confirmed and reflected in our system.',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                '4. Artwork Availability',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Please note that artworks are subject to availability. In rare cases, if an artwork is no longer available after your purchase, we will notify you immediately and offer you the option to select an alternative piece or receive a full refund.',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                '5. Refunds and Returns',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Given the unique nature of art purchases, we typically do not accept returns or offer refunds unless the artwork arrives damaged or is significantly not as described. If you encounter any issues with your purchase, please contact our support team within 7 days of receiving your artwork to initiate a return process. In the case of damage, please provide photographic evidence to support your claim. Refunds, if approved, will be processed to the original payment method within 7-10 business days after we receive the returned item.',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                '6. Shipping and Handling',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Shipping costs are calculated based on the size, weight, and destination of the artwork. We strive to offer the best possible shipping rates and ensure that your artwork is securely packaged. You will receive tracking information once your artwork is dispatched. Please note that delivery times may vary depending on your location and shipping method chosen.',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                '7. Security Measures',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'We prioritize the security of your payment information. Our payment gateway uses advanced encryption and security measures to protect your data during transactions. We do not store your payment details on our servers, ensuring your information remains confidential.',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                '8. Contact Us',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'If you have any questions or concerns regarding our payment policy, please contact our customer support team at [support email/phone number]. We are here to assist you and ensure that your experience with us is positive and satisfying.',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
