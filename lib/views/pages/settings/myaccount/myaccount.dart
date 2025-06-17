// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:art_elevate/address/addaddress.dart';
import 'package:art_elevate/address/savedaddress.dart';
import 'package:art_elevate/views/utils/constant.dart';
import 'package:art_elevate/views/pages/loginpage/login_screen.dart';
import 'package:art_elevate/views/pages/settings/aboutus.dart';
import 'package:art_elevate/views/pages/settings/myaccount/change_password.dart';
import 'package:art_elevate/views/pages/settings/myaccount/editprofile.dart';
import 'package:art_elevate/views/pages/settings/myaccount/notification.dart';
import 'package:art_elevate/views/pages/settings/policies/terms_and_policies.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:art_elevate/l10n/app_localizations.dart';

class Myaccount extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  const Myaccount(
      {super.key,
      required this.name,
      required this.email,
      required this.phone});

  @override
  State<Myaccount> createState() => _MyaccountState();
}

class _MyaccountState extends State<Myaccount> {
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _delete(String password) async {
    User? user = FirebaseAuth.instance.currentUser;
    try {
      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!, password: password);
        await user.reauthenticateWithCredential(credential);
        await user.delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                AppLocalizations.of(context)!.account_deleted_successfully),
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
          ModalRoute.withName('/'),
        );
      }
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'requires-recent-login') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.please_login_again),
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
            ModalRoute.withName('/'));
      } else {
        log('Error deleting account: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(AppLocalizations.of(context)!.error_deleting_account)),
        );
      }
    }
  }

  _resetPassword() async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: widget.email);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.password_reset_email_sent,
          style: GoogleFonts.poppins(fontSize: 18),
        ),
      ),
    );
  }

  _showDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            AppLocalizations.of(context)!.confirm,
            style: GoogleFonts.poppins(
              fontSize: 20,
            ),
          ),
          content: Text(
            AppLocalizations.of(context)!.delete_account_confirmation,
            style: GoogleFonts.poppins(
              fontSize: 18,
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                overlayColor: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context)!.no,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                overlayColor: Colors.black,
              ),
              onPressed: () {
                _showPasswordDialog(context);
              },
              child: Text(
                AppLocalizations.of(context)!.yes,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _showPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          title: Text(
            AppLocalizations.of(context)!.enter_password_to_delete_account,
            style: GoogleFonts.poppins(color: Colors.black, fontSize: 21),
          ),
          content: Form(
            key: _formKey,
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.wrongPassword;
                }
                return null;
              },
              onTapOutside: (PointerDownEvent event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              cursorColor: Colors.black,
              cursorWidth: 1,
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                labelText: AppLocalizations.of(context)!.password,
                labelStyle: GoogleFonts.notoSans(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: GoogleFonts.anekBangla(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  String password = _passwordController.text;
                  if (password.isNotEmpty) {
                    _delete(password); // Reauthenticate and delete account
                    Navigator.of(context).pop(); // Close the dialog
                  }
                }
              },
              child: Text(
                AppLocalizations.of(context)!.confirm,
                style: GoogleFonts.anekBangla(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showResetDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            AppLocalizations.of(context)!.confirm,
            style: GoogleFonts.poppins(
              fontSize: 20,
            ),
          ),
          content: Text(
            AppLocalizations.of(context)!.reset_password_confirmation,
            style: GoogleFonts.poppins(
              fontSize: 18,
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                overlayColor: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context)!.no,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                overlayColor: Colors.black,
              ),
              onPressed: () {
                _resetPassword();
              },
              child: Text(
                AppLocalizations.of(context)!.yes,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: kprimaryColor,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          textAlign: TextAlign.center,
          AppLocalizations.of(context)!.my_account,
        ),
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
            color: Colors.black, fontSize: 21, fontWeight: FontWeight.w500),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.manage_accounts_outlined,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 8,
          ),
          ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: EdgeInsets.all(10),
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _showResetDialog(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[350]!,
                          offset: Offset(1, 1),
                          blurRadius: 10,
                          spreadRadius: 2),
                    ],
                  ),
                  padding: EdgeInsets.all(8),
                  height: 60,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Icon(Icons.password_outlined),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          AppLocalizations.of(context)!.change_password,
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
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Savedaddress())),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[350]!,
                          offset: Offset(1, 1),
                          blurRadius: 10,
                          spreadRadius: 2),
                    ],
                  ),
                  padding: EdgeInsets.all(8),
                  height: 60,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Icon(Icons.location_on_outlined),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          AppLocalizations.of(context)!.saved_addresses,
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
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _showDialog(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[350]!,
                          offset: Offset(1, 1),
                          blurRadius: 10,
                          spreadRadius: 2),
                    ],
                  ),
                  padding: EdgeInsets.all(8),
                  height: 60,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Icon(Icons.delete_outlined),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          AppLocalizations.of(context)!.delete_account,
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
