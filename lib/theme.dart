import 'package:flutter/material.dart';

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,
  dialogTheme: const DialogTheme(
    backgroundColor: Colors.white,
    elevation: 4, // Adjust elevation as needed
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
    ),
    contentTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 16.0,
    ),
  ),
);
