import 'package:flutter/material.dart';
import '../theme/app_theme.dart' as app_theme;
import '../auth/login.dart' as login_screen;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_theme.AppColors.latar,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: app_theme.AppColors.teks),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Profil Mahasiswa',
            style: TextStyle(color: app_theme.AppColors.teks)),
        backgroundColor: app_theme.AppColors.putih,
        iconTheme: const IconThemeData(color: app_theme.AppColors.teks),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/mahasiswa.jpg'),
              ),
              const SizedBox(height: 20),
              _buildInfoCard('Nama Lengkap', 'John Doe'),
              _buildInfoCard('NPM', '12345678'),
              _buildInfoCard('Program Studi', 'Teknik Informatika'),
              const SizedBox(height: 30),
              const Text(
                'Barcode Absensi',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: app_theme.AppColors.teks),
              ),
              const SizedBox(height: 10),
              Container(
                width: 200.0,
                height: 200.0,
                decoration: BoxDecoration(
                  border: Border.all(color: app_theme.AppColors.teks),
                ),
                child: const Center(
                  child: Text(
                    '12345678', // Gunakan NPM atau ID unik lainnya
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: app_theme.AppColors.teks,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: app_theme.AppColors.aksen,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    // Implementasi logout langsung ke halaman login
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) =>
                              const login_screen.LoginScreen()),
                    );
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      color: app_theme.AppColors.putih,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Card(
      color: app_theme.AppColors.putih,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 16, color: app_theme.AppColors.teks)),
            Text(value,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: app_theme.AppColors.aksen)),
          ],
        ),
      ),
    );
  }
}
