import 'package:art_elevate/chats/messagepage.dart';
import 'package:art_elevate/views/constant.dart';
import 'package:art_elevate/main.dart';
import 'package:art_elevate/models/message.dart';
import 'package:art_elevate/views/login_screen.dart';
import 'package:art_elevate/views/pages/drawer/aboutus.dart';
import 'package:art_elevate/views/pages/drawer/contactus.dart';
import 'package:art_elevate/views/pages/drawer/my_artwork.dart';
import 'package:art_elevate/views/pages/drawer/myaccount/myaccount.dart';
import 'package:art_elevate/views/pages/drawer/payments.dart';
import 'package:art_elevate/views/pages/drawer/policies/paymentpolicy.dart';
import 'package:art_elevate/views/pages/drawer/policies/returnpolicy.dart';
import 'package:art_elevate/views/pages/drawer/policies/terms.dart';
import 'package:art_elevate/views/pages/drawer/policies/terms_and_policies.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class mySettings extends StatefulWidget {
  const mySettings({super.key});

  @override
  State<mySettings> createState() => _mySettingsState();
}

class _mySettingsState extends State<mySettings> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  signOut() async {
    await _auth.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  bool isSeller = false;

  Future<void> checkSeller() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        var querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: user.uid)
            .where('role', isEqualTo: 'seller')
            .get();
        print('User UID: ${user.uid}');
        print('Query snapshot: ${querySnapshot.docs.length}');

        if (querySnapshot.docs.length.toInt() > 0) {
          setState(() {
            isSeller = true;
          });
        } else {
          setState(() {
            isSeller = false;
          });
        }
      } catch (e) {
        print('Error checking seller: $e');
      }
    }
  }

  String _selectedLanguage = 'en';
  Future<String> _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedLanguage = prefs.getString('language');
    if (savedLanguage != null) {
      setState(() {
        _selectedLanguage = savedLanguage;
      });
      MyApp.setLocale(context, Locale(savedLanguage));
    }
    return 'en';
  }

  Future<void> _saveLanguagePreference(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('language', languageCode);
  }

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
    checkSeller();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Material(
              color: Colors.transparent,
              child: DropdownButton<String>(
                dropdownColor: Colors.white,
                value: _selectedLanguage.isEmpty ? 'en' : _selectedLanguage,
                hint: Text(
                  _selectedLanguage.isEmpty
                      ? 'English'
                      : (_selectedLanguage == 'en'
                          ? 'English'
                          : (_selectedLanguage == 'es'
                              ? 'Español'
                              : (_selectedLanguage == 'ar'
                                  ? 'Arabic'
                                  : (_selectedLanguage == 'hi'
                                      ? 'Hindi'
                                      : 'Malayalam')))),
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'en',
                    child: Text(
                      'English',
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'es',
                    child: Text(
                      'Español',
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'ar',
                    child: Text(
                      'Arabic',
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'hi',
                    child: Text(
                      'Hindi',
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'ml',
                    child: Text(
                      'Malayalam',
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                  ),
                ],
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedLanguage = newValue;
                    });
                    Locale newLocale = Locale(_selectedLanguage);
                    MyApp.setLocale(context, newLocale);
                    _saveLanguagePreference(newValue);
                  }
                },
              ),
            ),
          ),
        ],
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
            color: Colors.black, fontSize: 21, fontWeight: FontWeight.w500),
        title: Text(AppLocalizations.of(context)!.settings),
        backgroundColor: kprimaryColor,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: const EdgeInsets.all(10),
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Myaccount(
                              name: '',
                              email: '',
                              phone: '',
                            ))),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[350]!,
                          offset: const Offset(1, 1),
                          blurRadius: 10,
                          spreadRadius: 2),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.manage_accounts_outlined,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          AppLocalizations.of(context)!.account,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ArtworkPage(),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[350]!,
                          offset: const Offset(1, 1),
                          blurRadius: 10,
                          spreadRadius: 2),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.collections_outlined,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          AppLocalizations.of(context)!.myArtwork,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (isSeller)
                const SizedBox(
                  height: 15,
                ),
              if (isSeller)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Payments(),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[350]!,
                            offset: const Offset(1, 1),
                            blurRadius: 10,
                            spreadRadius: 2),
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.payment_outlined,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            AppLocalizations.of(context)!.payments,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TermsAndPolicies(),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[350]!,
                          offset: const Offset(1, 1),
                          blurRadius: 10,
                          spreadRadius: 2),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        const Icon(
                          color: Colors.black,
                          Icons.my_library_books_outlined,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          AppLocalizations.of(context)!.termsAndPolicies,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactUs(),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[350]!,
                          offset: const Offset(1, 1),
                          blurRadius: 10,
                          spreadRadius: 2),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.headset_mic_outlined,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          AppLocalizations.of(context)!.contactUs,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutUs(),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[350]!,
                          offset: const Offset(1, 1),
                          blurRadius: 10,
                          spreadRadius: 2),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          AppLocalizations.of(context)!.aboutUs,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              // GestureDetector(
              //   behavior: HitTestBehavior.opaque,
              //   onTap: () => Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => const MessagePage(
              //         isAdmin: true,
              //         receiverEmail: 'vaishnavprabha7@gmail.com',
              //         receiverID: 'TX63IPNhBDNzlIrYjlLeIxiCniT2',
              //       ),
              //     ),
              //   ),
              //   child: Container(
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(14),
              //       color: Colors.white,
              //       boxShadow: [
              //         BoxShadow(
              //             color: Colors.grey[350]!,
              //             offset: const Offset(1, 1),
              //             blurRadius: 10,
              //             spreadRadius: 2),
              //       ],
              //     ),
              //     padding: const EdgeInsets.all(8),
              //     height: 60,
              //     child: Padding(
              //       padding: const EdgeInsets.all(10.0),
              //       child: Row(
              //         children: [
              //           const Icon(
              //             Icons.chat_outlined,
              //             color: Colors.black,
              //           ),
              //           const SizedBox(
              //             width: 10,
              //           ),
              //           Text(
              //             'Chat with us',
              //             style: GoogleFonts.poppins(
              //               fontSize: 18,
              //               color: Colors.black,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 15,
              // ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: signOut,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[350]!,
                          offset: const Offset(1, 1),
                          blurRadius: 10,
                          spreadRadius: 2),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.logout_outlined,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          AppLocalizations.of(context)!.logout,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
