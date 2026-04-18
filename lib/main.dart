import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/disclaimer_screen.dart';
import 'screens/checklist_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final accepted = prefs.getBool('disclaimer_accepted') ?? false;
  runApp(DocPrepApp(disclaimerAccepted: accepted));
}

class DocPrepApp extends StatelessWidget {
  final bool disclaimerAccepted;
  const DocPrepApp({super.key, required this.disclaimerAccepted});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DocPrep',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A7C6F),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
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
      home: disclaimerAccepted
          ? const ChecklistScreen()
          : const DisclaimerScreen(),
    );
  }
}
