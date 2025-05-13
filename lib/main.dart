import 'package:art_elevate/pages/splash_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
  options: kIsWeb
      ? const FirebaseOptions(
          apiKey: "AIzaSyDDJLqzsAidQiae0bysssnyyE3xdM_yzSI",
          appId: "1:1036178823711:web:b091190672ee4004ba532a",
          messagingSenderId: "1036178823711",
          projectId: "art-elevate",
          storageBucket: "art-elevate.firebasestorage.app",
        )
      : null,
);

if (!kIsWeb) {
  await FirebaseAppCheck.instance.activate();
}

  String savedLanguage = await _loadLanguagePreference();
  runApp(
    MyApp(initialLanguage: savedLanguage),
  );
}

Future<String> _loadLanguagePreference() async {
  final prefs = await SharedPreferences.getInstance();
  String? language = prefs.getString('language');
  return language ?? 'en';
}

class MyApp extends StatefulWidget {
  final String initialLanguage;

  const MyApp({super.key, required this.initialLanguage});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale _locale;
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _locale = Locale(widget.initialLanguage);
    _selectedLanguage = widget.initialLanguage;
  }

  void setLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: ThemeData(fontFamily: 'Urbanist'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('es', ''),
        Locale('ar', ''),
        Locale('ml', ''),
        Locale('hi', '')
      ],
    );
  }
}
