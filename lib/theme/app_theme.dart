import 'package:flutter/material.dart';

const blush = Color(0xFFEAC9BD);
const cream = Color(0xFFF4EEE6);
const espresso = Color(0xFF2E211C);
const brown = Color(0xFF6B5248);
const coral = Color(0xFFE35D4A);
const blushDeep = Color(0xFFE8C4B8);

ThemeData buildAppTheme() => ThemeData(
      scaffoldBackgroundColor: blush,
      colorScheme: ColorScheme.fromSeed(seedColor: coral),
      fontFamily: 'serif',
      useMaterial3: true,
    );