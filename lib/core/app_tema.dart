import 'package:flutter/material.dart';

import 'app_cores.dart';


class AppTema {
  AppTema._();

  static ThemeData get claro {
    final esquema = ColorScheme.fromSeed(
      seedColor: AppCores.primaria,
      primary: AppCores.primaria,
      secondary: AppCores.secundaria,
      surface: Colors.white,
    );

    final formatoBotao = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    );

    const textoBotao = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: esquema,
      scaffoldBackgroundColor: AppCores.fundo,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppCores.primaria,
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w800,
          color: AppCores.texto,
        ),
        headlineSmall: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: AppCores.texto,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppCores.texto,
        ),
        titleMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppCores.texto,
        ),
        bodyLarge: TextStyle(fontSize: 20, color: AppCores.texto),
        bodyMedium: TextStyle(fontSize: 18, color: AppCores.texto),
        bodySmall: TextStyle(fontSize: 16, color: AppCores.textoSuave),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppCores.primaria,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(60),
          shape: formatoBotao,
          textStyle: textoBotao,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppCores.primaria,
          minimumSize: const Size.fromHeight(60),
          shape: formatoBotao,
          side: const BorderSide(color: AppCores.primaria, width: 2),
          textStyle: textoBotao,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppCores.primaria,
          minimumSize: const Size(48, 52),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 20,
        ),
        labelStyle: const TextStyle(fontSize: 18),
        hintStyle: const TextStyle(fontSize: 18),
        errorStyle: const TextStyle(fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppCores.primaria, width: 2),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        contentTextStyle: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}
