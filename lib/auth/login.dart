import 'package:flutter/material.dart';
import 'package:school_apps2/pages/welcome.dart';
import 'package:school_apps2/auth/registrasi.dart';

class AppColors {
  static const Color latar = Color(0xFFE0F2FE);
  static const Color teks = Color(0xFF1E40AF);
  static const Color aksen = Color(0xFF60A5FA);
  static const Color putih = Colors.white;
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _lihatPassword = false;

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _masuk() {
    if (_formKey.currentState!.validate()) {
      if (_userIdController.text == '123456' &&
          _passwordController.text == '123456') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User ID atau Password salah')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.latar,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.school, size: 80, color: AppColors.teks),
              const SizedBox(height: 24),
              const Text(
                'Selamat Datang',
                style: TextStyle(
                    color: AppColors.teks,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Silakan masuk ke akun Anda',
                style: TextStyle(color: AppColors.teks, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buatInputTeks(
                      controller: _userIdController,
                      label: 'User ID',
                      icon: Icons.person,
                      validator: (value) =>
                          value!.isEmpty ? 'User ID wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),
                    _buatInputTeks(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock,
                      isPassword: true,
                      validator: (value) => value!.isEmpty
                          ? 'Password wajib diisi'
                          : (value.length < 6
                              ? 'Password minimal 6 karakter'
                              : null),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            foregroundColor: AppColors.teks),
                        child: const Text('Lupa Password?'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _masuk,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.aksen,
                          foregroundColor: AppColors.putih,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          elevation: 5,
                        ),
                        child: const Text(
                          'Masuk',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Belum punya akun?',
                      style: TextStyle(color: AppColors.teks)),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegistrasiScreen()),
                    ),
                    style:
                        TextButton.styleFrom(foregroundColor: AppColors.aksen),
                    child: const Text('Daftar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buatInputTeks({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !_lihatPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.teks),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                    _lihatPassword ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.teks),
                onPressed: () =>
                    setState(() => _lihatPassword = !_lihatPassword),
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validator,
    );
  }
}
