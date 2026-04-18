import 'package:flutter/material.dart';
import 'screens/checklist_screen.dart';

void main() {
  runApp(const DocPrepApp());
}

class DocPrepApp extends StatelessWidget {
  const DocPrepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DocPrep',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A7C6F), // muted teal — calm, medical-adjacent
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        // Clean readable font
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          bodyMedium: TextStyle(fontSize: 15, height: 1.6),
          labelMedium: TextStyle(fontSize: 13),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      home: const ChecklistScreen(),
    );
  }
}
