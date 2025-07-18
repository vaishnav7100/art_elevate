import 'package:art_elevate/l10n/app_localizations.dart';
import 'package:art_elevate/main.dart';
import 'package:art_elevate/models/auth_viewmodel.dart';
import 'package:art_elevate/views/pages/mainpage/bottom_nav.dart';
import 'package:art_elevate/views/pages/loginpage/set_profile.dart';
import 'package:art_elevate/views/pages/loginpage/forgot_password.dart';
import 'package:art_elevate/views/pages/phoneform.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _email, _password;

  // chechAuthentication() {
  //   _auth.authStateChanges().listen((user) {
  //     if (user != null && user.emailVerified && mounted) {
  //       Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(builder: (context) => const BottomNavBar()),
  //           (Route<dynamic> route) => false);
  //     }
  //   });
  // }

  // navigateToSignup() {
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => const PhoneForm()),
  //   );
  // }

  String _selectedLanguage = 'en';
  Future<String> _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedLanguage = prefs.getString('language');

    savedLanguage ??= 'en';

    setState(() {
      _selectedLanguage = savedLanguage!;
    });

    MyApp.setLocale(context, Locale(savedLanguage));
    return savedLanguage;
  }

  Future<void> _saveLanguagePreference(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('language', languageCode);
  }

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
  }

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context);
    return ColoredBox(
      color: Colors.white,
      child: Stack(
        children: [
          Positioned.fill(
            child: Lottie.asset(
              "assets/background.json",
              fit: BoxFit.cover,
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
                          if (auth.errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Text(
                                auth.errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ElevatedButton(
                            onPressed: auth.isLoading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      try {
                                        await auth.login(
                                          _emailController.text.trim(),
                                          _passwordController.text.trim(),
                                          context,
                                        );
                                      } catch (e) {}
                                    }
                                  },
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
                SafeArea(
                  child: Align(
                    alignment: Alignment.bottomCenter,
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
                                    builder: (context) => const SetProfile(),
                                  ),
                                );
                              },
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          if (auth.isLoading)
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
