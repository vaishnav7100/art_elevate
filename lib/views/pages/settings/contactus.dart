import 'package:art_elevate/views/utils/constant.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:art_elevate/l10n/app_localizations.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  void _makePhoneCall() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: '18001234567',
    );
    print('Attempting to launch $launchUri'); // Debug print
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      }
    } catch (e) {
      print("Error: $e"); // Debug print
    }
  }

  Future<void> _openemail() async {
    final Uri url = Uri.parse(
      'mailto:vaishnavprabhakaran31@gmail.com&su=Hello&body=This%20is%20a%20test%20email',
    );
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _openWhatsappChat() async {
    final Uri url = Uri.parse('https://wa.me/+918078461246?text=Hello');
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(AppLocalizations.of(context)!.contactUs),
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
            color: Colors.black, fontSize: 21, fontWeight: FontWeight.w500),
        backgroundColor: kprimaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              const SizedBox(
                height: 6,
              ),
              SizedBox(
                width: 180,
                child: Image.asset(
                  'assets/artelevate1.png',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                AppLocalizations.of(context)!.connectMessage,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.headset_mic_outlined,
                      size: 21,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)!.customerCare,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    RichText(
                      text: TextSpan(
                        text: "1800 1234 567",
                        style: GoogleFonts.ubuntu(
                          color: Colors.blue[900],
                          fontSize: 20,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = _makePhoneCall,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.whatsapp),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)!.whatsapp,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    RichText(
                      text: TextSpan(
                          text: "8078461246",
                          style: GoogleFonts.ubuntu(
                            color: Colors.blue[900],
                            fontSize: 20,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = _openWhatsappChat),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(Icons.email_outlined),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      "${AppLocalizations.of(context)!.email} :",
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          text: "help@artelevate.com",
                          style: GoogleFonts.ubuntu(
                            color: Colors.blue[900],
                            fontSize: 20,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = _openemail,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(Icons.access_time),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)!.workingHours,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
