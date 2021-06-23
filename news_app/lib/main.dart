import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:news_app/app/landing_page.dart';
import 'package:news_app/provider/theme_provider.dart';
import 'package:news_app/services/auth.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        title: 'News App',
        themeMode: ThemeMode.system,
        theme: MyThemes.lightTheme,
        darkTheme: MyThemes.darkTheme,
        home: LandingPage(),
      ),
    );
  }
}
