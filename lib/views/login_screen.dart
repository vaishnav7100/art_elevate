import 'package:art_elevate/main.dart';
import 'package:art_elevate/views/mainpage/bottom_nav.dart';
import 'package:art_elevate/views/mainpage/username.dart';
import 'package:art_elevate/views/pages/forgot_password.dart';
import 'package:art_elevate/views/pages/phoneform.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // final formKey = GlobalKey<FormState>();
  var name = '';
  var phone = '';
  var email = '';

  // void _login() {
  //   if (formKey.currentState?.validate() ?? false) {
  //     String email = _emailController.text;

  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => HomePage(
  //           img: '',
  //           name: name,
  //           phone: phone,
  //           email: email,
  //           itemUrl: '',
  //           itemPrice: '',
  //           itemName: '',
  //         ),
  //       ),
  //     );
  //   }
  // }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _email, _password;

  chechAuthentication() {
    _auth.authStateChanges().listen((user) {
      if (user != null && user.emailVerified && mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavBar()),
            (Route<dynamic> route) => false);
      }
    });
  }

  navigateToSignup() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PhoneForm()),
    );
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
    chechAuthentication();
  }

  bool _isLoading = false;
  bool _isObscure = true;

  void signin() async {
    if (_formKey.currentState != null) {
      _formKey.currentState!.validate();
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);

        User? user = userCredential.user;
        if (user != null) {
          if (user.emailVerified) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BottomNavBar()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                    "A verification email has been sent. Please verify your email before logging in.")));
            await user.sendEmailVerification();
          }
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          handleFirebaseAuthError(e);
        }
      } catch (e) {
        if (mounted) {
          showError(AppLocalizations.of(context)!.unknownError);
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  showError(String errorMessage) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(AppLocalizations.of(context)!.error),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: true).pop(),
                  child: Text(AppLocalizations.of(context)!.okButton))
            ],
          );
        },
      );
    }
  }

  void handleFirebaseAuthError(FirebaseAuthException e) {
    String errorMessage = 'An unknown error occurred. Please try again later.';

    switch (e.code) {
      case 'user-not-found':
        errorMessage = AppLocalizations.of(context)!.userNotFound;
        break;
      case 'wrong-password':
        errorMessage = AppLocalizations.of(context)!.wrongPassword;
        break;
      case 'invalid-email':
        errorMessage = AppLocalizations.of(context)!.invalidEmail;
        break;
      case 'email-already-in-use':
        errorMessage = AppLocalizations.of(context)!.emailInUse;
        break;
      default:
        errorMessage = e.message ?? errorMessage;
        break;
    }

    // Show the error using an AlertDialog or any other UI component
    showError(errorMessage);
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/login_bg.png",
              fit: BoxFit.cover,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded) {
                  return child;
                } else {
                  return AnimatedOpacity(
                    opacity: frame != null ? 1 : 0,
                    duration: const Duration(milliseconds: 500),
                    child: child,
                  );
                }
              },
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 35, right: 5),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Material(
                      color: Colors.transparent,
                      child: DropdownButton<String>(
                        dropdownColor: Colors.white,
                        value: _selectedLanguage.isEmpty
                            ? 'en'
                            : _selectedLanguage,
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
                ),
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            textAlign: TextAlign.center,
                            AppLocalizations.of(context)!.welcomeMessage,
                            style: GoogleFonts.robotoMono(
                              fontSize: 28,
                              letterSpacing: 3,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 28),
                          TextFormField(
                            onSaved: (value) => _email = value!,
                            scrollPadding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!.emailHint;
                              }
                              final emailRegExp = RegExp(
                                r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                                caseSensitive: false,
                              );
                              if (!emailRegExp.hasMatch(value)) {
                                return AppLocalizations.of(context)!.validEmail;
                              }
                              if (!value.endsWith('@gmail.com')) {
                                return AppLocalizations.of(context)!.gmailOnly;
                              }
                              return null;
                            },
                            cursorColor: Colors.black,
                            cursorOpacityAnimates: true,
                            cursorWidth: 1,
                            onTapOutside: (PointerDownEvent event) =>
                                FocusManager.instance.primaryFocus?.unfocus(),
                            controller: _emailController,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    const BorderSide(color: Colors.black),
                              ),
                              labelText: AppLocalizations.of(context)!.email,
                              labelStyle: GoogleFonts.notoSans(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 0.1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            obscureText: _isObscure,
                            onSaved: (value) => _password = value!,
                            textInputAction: TextInputAction.send,
                            scrollPadding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .passwordHint;
                              } else if (value.length < 6) {
                                return AppLocalizations.of(context)!
                                    .passwordLength;
                              }
                              return null;
                            },
                            cursorColor: Colors.black,
                            cursorOpacityAnimates: true,
                            cursorWidth: 1,
                            onTapOutside: (PointerDownEvent event) =>
                                FocusManager.instance.primaryFocus?.unfocus(),
                            controller: _passwordController,
                            decoration: InputDecoration(
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
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    const BorderSide(color: Colors.black),
                              ),
                              labelText: AppLocalizations.of(context)!.password,
                              labelStyle: GoogleFonts.notoSans(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 0.1),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            height: 25,
                            child: Container(
                              alignment: const Alignment(1, 0),
                              child: RichText(
                                text: TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgotPage(),
                                        ),
                                      );
                                    },
                                  text: AppLocalizations.of(context)!
                                      .forgotPassword,
                                  style: GoogleFonts.ubuntuMono(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          ElevatedButton(
                            onPressed: _isLoading ? null : signin,
                            style: ElevatedButton.styleFrom(
                              overlayColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  14.0,
                                ),
                              ),
                              side: const BorderSide(color: Colors.black45),
                              elevation: 7,
                              backgroundColor: Colors.white,
                              splashFactory: InkSplash.splashFactory,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.loginButton,
                              style: GoogleFonts.openSans(
                                letterSpacing: 3,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: BottomAppBar(
              color: Colors.transparent,
              height: 50,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: AppLocalizations.of(context)!.noAccount,
                  style: GoogleFonts.ubuntuMono(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(context)!.clickHere,
                      style: GoogleFonts.poppins(color: Colors.blue[900]),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Username(),
                            ),
                          );
                        },
                    )
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.black), // Progress color
                backgroundColor: Colors.white, // Background color of the circle
                strokeWidth: 5.0, // Thickness of the circle's stroke
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
