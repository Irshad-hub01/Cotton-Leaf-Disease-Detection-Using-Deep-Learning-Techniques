import 'package:flutter/material.dart';
import 'package:spotflod/page/about_page.dart';
import 'package:spotflod/page/confidence_page.dart';
import 'package:spotflod/page/display_image.dart';
import 'package:spotflod/page/home_page.dart';
import 'package:spotflod/page/prediction_page.dart';

import 'data/constants.dart';

Future<void> main() async {
  runApp(const SpotFlod());
}

class SpotFlod extends StatelessWidget {
  const SpotFlod({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0XFFdde6cd)),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
              iconColor: MaterialStateProperty.all(Constants.colorScheme.tertiary),
              iconSize: MaterialStateProperty.all(32)),
        ),
        cardTheme: CardTheme(color: Constants.colorScheme.tertiaryContainer),
        scaffoldBackgroundColor: Constants.colorScheme.secondaryContainer
      ),
      home: const HomePage(),
      routes: {
        HomePage.id: (context) => const HomePage(),
        DisplayImage.id: (context) => const DisplayImage(),
        ConfidencePage.id: (context) => const ConfidencePage(),
        PredictionPage.id: (context) => const PredictionPage(),
        AboutPage.id: (context) => const AboutPage(),
      },
    );
  }

  void setColorScheme() {}
}
