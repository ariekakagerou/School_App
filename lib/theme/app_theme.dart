import 'package:flutter/material.dart';

class AppColors {
  static const Color latar = Color(0xFFE0F2FE);
  static const Color teks = Color(0xFF333333);
  static const Color aksen = Color(0xFF3D5AFE);
  static const Color putih = Colors.white;

  // Warna spesifik untuk setiap halaman
  static const Color latarGaleri = Color(0xFFE0F2FE);
  static const Color latarAgenda = Color(0xFFE0F2FE);
  static const Color latarHome = Color(0xFFE0F2FE);
  static const Color latarInfo = Color(0xFFE0F2FE);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.latar,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.putih,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.teks),
        titleTextStyle: TextStyle(color: AppColors.teks, fontSize: 20),
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColors.aksen,
        onPrimary: AppColors.putih,
      ),
    );
  }

  static BoxDecoration get galeriBackground {
    return const BoxDecoration(
      color: AppColors.latarGaleri,
    );
  }

  static BoxDecoration get agendaBackground {
    return const BoxDecoration(
      color: AppColors.latarAgenda,
    );
  }

  static BoxDecoration get homeBackground {
    return const BoxDecoration(
      color: AppColors.latarHome,
    );
  }

  static BoxDecoration get infoBackground {
    return const BoxDecoration(
      color: AppColors.latarInfo,
    );
  }
}
