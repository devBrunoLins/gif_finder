import 'package:flutter/material.dart';
import 'interface/home_page.dart';

void main() {
  runApp(
    MaterialApp(
      home: const HomePage(),
      theme: ThemeData(
        hintColor: Colors.white,
        primaryColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          hintStyle: TextStyle(color: Colors.white),
        ),
      ),
    ),
  );
}
