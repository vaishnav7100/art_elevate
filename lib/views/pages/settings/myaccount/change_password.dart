import 'package:art_elevate/views/utils/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _oldController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _cnewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text(
          textAlign: TextAlign.center,
          'Change Password',
        ),
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 20,
        ),
        backgroundColor: kprimaryColor,
      ),
      body: Column(
        children: [
          ListTile(
            title: TextFormField(
              textInputAction: TextInputAction.next,
              cursorColor: Colors.black,
              cursorWidth: 1,
              controller: _oldController,
              onTapOutside: (PointerDownEvent event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              decoration: InputDecoration(
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          overlayColor: Colors.black12,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.white,
                          elevation: 0),
                      onPressed: () {},
                      child: Text(
                        'Verify',
                        style: GoogleFonts.poppins(
                            color: Colors.black, fontWeight: FontWeight.w600),
                      )),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                labelText: "Current Password",
                labelStyle: GoogleFonts.notoSans(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ),
          ListTile(
            title: TextFormField(
              textInputAction: TextInputAction.next,
              cursorColor: Colors.black,
              cursorWidth: 1,
              controller: _newController,
              onTapOutside: (PointerDownEvent event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                labelText: "New Password",
                labelStyle: GoogleFonts.notoSans(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ),
          ListTile(
            title: TextFormField(
              cursorColor: Colors.black,
              cursorWidth: 1,
              controller: _cnewController,
              onTapOutside: (PointerDownEvent event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                labelText: "Confirm New Password",
                labelStyle: GoogleFonts.notoSans(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
