import 'package:art_elevate/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Editprofile extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  const Editprofile(
      {super.key,
      required this.name,
      required this.email,
      required this.phone});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;

    _nameController.text = user?.displayName ?? '';
    _emailController.text = user?.email ?? '';
  }

  void updatedName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (_formKey.currentState!.validate()) {
      if (user != null) {
        try {
          await user.updateProfile(displayName: _nameController.text);
          await user.reload();
          user = FirebaseAuth.instance.currentUser;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user?.uid)
              .set({'displayName': user?.displayName});
          setState(() {
            _nameController.text = user?.displayName ?? "";
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Name updated successfully!')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update name: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text(
          textAlign: TextAlign.center,
          'Edit Profile',
        ),
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 20,
        ),
        backgroundColor: kprimaryColor,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 5,
            ),
            ListTile(
              leading: const Icon(Icons.person_outline_outlined),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  overlayColor: Colors.black12,
                ),
                onPressed: () {
                  updatedName();
                },
                child: Text(
                  'Update',
                  style: GoogleFonts.poppins(
                      color: Colors.black, fontWeight: FontWeight.w500),
                ),
              ),
              title: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                cursorColor: Colors.black,
                cursorWidth: 1,
                onFieldSubmitted: (value) {
                  setState(() {
                    _nameController.text = value;
                  });
                },
                textCapitalization: TextCapitalization.words,
                controller: _nameController,
                onTapOutside: (PointerDownEvent event) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                decoration: InputDecoration(
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: 'Name',
                  labelStyle: GoogleFonts.notoSans(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.email_outlined),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  overlayColor: Colors.black12,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('You cannot update your emai !')));
                },
                child: Text(
                  'Update',
                  style: GoogleFonts.poppins(
                      color: Colors.black, fontWeight: FontWeight.w500),
                ),
              ),
              title: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email id';
                  }
                  final emailRegExp = RegExp(
                    r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                    caseSensitive: false,
                  );
                  if (!emailRegExp.hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  if (!value.endsWith('@gmail.com')) {
                    return 'Please enter a gmail address';
                  }
                  return null;
                },
                cursorColor: Colors.black,
                cursorWidth: 1,
                controller: _emailController,
                onTapOutside: (PointerDownEvent event) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                decoration: InputDecoration(
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: "E-mail ID",
                  labelStyle: GoogleFonts.notoSans(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
