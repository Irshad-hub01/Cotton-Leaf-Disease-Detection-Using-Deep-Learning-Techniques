import 'package:flutter/material.dart';

class Constants {
  static String cachePath = '';

  static String modelPath = '';

  static List<String> classLabels = [
    'Aphids',
    'Army worm',
    'Bacterial Blight',
    'Curl Virus',
    'Fusarium wilt',
    'Healthy',
    'Powdery mildew',
    'Target spot'
  ];

  static ColorScheme colorScheme =
      ColorScheme.fromSeed(seedColor: const Color(0XFFdde6cd));
}
