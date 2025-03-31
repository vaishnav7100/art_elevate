import 'package:art_elevate/constant.dart';
import 'package:art_elevate/pages/login_screen.dart';
import 'package:art_elevate/pages/mainpage/bottom_nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class Username extends StatefulWidget {
  const Username({super.key});

  @override
  State<Username> createState() => _UsernameState();
}

class _UsernameState extends State<Username> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String name = '';
  String emailid = '';
  String password = '';
  String confirmPassword = '';

  bool _isObscure = true;
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _name, _email, _password;

  showError(String errorMessage) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title:  Text(AppLocalizations.of(context)!.error),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                  onPressed: Navigator.of(context).pop, child:  Text(AppLocalizations.of(context)!.ok))
            ],
          );
        },
      );
    }
  }

  signup() async {
    if (mounted) {
      if (_formKey.currentState != null && _formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        setState(() {
          _isLoading = true;
        });

        try {
          UserCredential result = await _auth.createUserWithEmailAndPassword(
              email: _email, password: _password);
          User? user = result.user;
          if (user != null) {
            await result.user!.updateProfile(displayName: _name);
            await result.user!.reload();
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set({
              'fullName': _name,
              'email': _email,
              'uid': result.user!.uid,
              'role': 'buyer',
              'joinedDate': FieldValue.serverTimestamp()
            });
            if (mounted) {
              setState(() {
                _isLoading = false;
              });

              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(
              //       content: Text(
              //           'A verification email has been sent. Please verify your email before logging in.')),
              // );

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false);
            }
          } else {
            setState(() {
              _isLoading = false;
            });

            showError('Failed to create user.');
          }
        } catch (e) {
          setState(() {
            _isLoading = true;
          });

          if (e is FirebaseAuthException) {
            showError(e.message ?? 'An unknown error occurred');
          } else {
            showError('An unknown error occurred');
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:  Text(AppLocalizations.of(context)!.set_your_profile_password),
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
            color: Colors.black, fontSize: 21, fontWeight: FontWeight.w500),
        backgroundColor: kprimaryColor,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.black), // Progress color
                backgroundColor: Colors.white, // Background color of the circle
                strokeWidth: 5.0, // Thickness of the circle's stroke
              ),
            )
          : Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    leading: const Icon(Icons.person_outline_outlined),
                    title: TextFormField(
                        cursorColor: Colors.black,
                        cursorOpacityAnimates: true,
                        cursorWidth: 1,
                        onSaved: (value) => _name = value!,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        textCapitalization: TextCapitalization.words,
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        onTapOutside: (PointerDownEvent event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          labelText: "Full Name",
                          labelStyle: GoogleFonts.notoSans(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.1),
                        ),
                        onChanged: (value) {
                          setState(() {
                            name = value;
                          });
                        }),
                  ),
                  ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: TextFormField(
                        cursorColor: Colors.black,
                        cursorOpacityAnimates: true,
                        cursorWidth: 1,
                        onSaved: (value) => _email = value!,
                        textInputAction: TextInputAction.next,
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
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        onTapOutside: (PointerDownEvent event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          labelText: "Email ID",
                          labelStyle: GoogleFonts.notoSans(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.1),
                        ),
                        onChanged: (value) {
                          setState(() {
                            emailid = value;
                          });
                        }),
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock_outlined),
                    title: TextFormField(
                        cursorColor: Colors.black,
                        cursorOpacityAnimates: true,
                        cursorWidth: 1,
                        onSaved: (value) => _password = value!,
                        textInputAction: TextInputAction.next,
                        obscureText: _isObscure,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        controller: _passwordController,
                        onTapOutside: (PointerDownEvent event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          labelText: "Password",
                          labelStyle: GoogleFonts.notoSans(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.1),
                        ),
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        }),
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock_outlined),
                    title: TextFormField(
                        cursorColor: Colors.black,
                        cursorOpacityAnimates: true,
                        cursorWidth: 1,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return "Password do not match";
                          }
                          return null;
                        },
                        controller: _confirmPasswordController,
                        onTapOutside: (PointerDownEvent event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          labelText: "Confirm Password",
                          labelStyle: GoogleFonts.notoSans(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.1),
                        ),
                        onChanged: (value) {
                          setState(() {
                            confirmPassword = value;
                          });
                        }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: signup,
                    style: ElevatedButton.styleFrom(
                      elevation: 4,
                      side: const BorderSide(color: Colors.black38),
                      backgroundColor: Colors.white,
                    ),
                    child: Text(
                      'Submit',
                      style:
                          GoogleFonts.dmSans(fontSize: 18, color: Colors.black),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
