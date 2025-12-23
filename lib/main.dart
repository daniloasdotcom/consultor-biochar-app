import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BiocharProApp());
}

class BiocharProApp extends StatefulWidget {
  const BiocharProApp({super.key});

  @override
  State<BiocharProApp> createState() => _BiocharProAppState();
}

class _BiocharProAppState extends State<BiocharProApp> {
  // Inicializa com ThemeMode.system para seguir a preferência do OS
  ThemeMode _themeMode = ThemeMode.system;

  void toggleTheme() {
    setState(() {
      // Lógica de alternância: 
      // Se estiver no sistema, descobre qual é o brilho atual e inverte.
      // Se já estiver manual, apenas inverte.
      final brightness = MediaQuery.platformBrightnessOf(context);
      bool isCurrentlyDark;
      
      if (_themeMode == ThemeMode.system) {
        isCurrentlyDark = brightness == Brightness.dark;
      } else {
        isCurrentlyDark = _themeMode == ThemeMode.dark;
      }

      _themeMode = isCurrentlyDark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Biochar Pro',
      // Aqui está a chave: usa a variável de estado que começa como .system
      themeMode: _themeMode, 
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light, // Define explicitamente como light
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A365D),
          brightness: Brightness.light,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark, // Define explicitamente como dark
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A365D),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212), // Fundo padrão escuro
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF2C2C2E), // Cor de fundo input dark
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: HomeScreen(onToggleTheme: toggleTheme),
    );
  }
}