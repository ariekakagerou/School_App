import 'package:flutter/material.dart';
import 'package:school_apps2/auth/login.dart';

class RegistrasiScreen extends StatefulWidget {
  const RegistrasiScreen({super.key});

  @override
  State<RegistrasiScreen> createState() => _RegistrasiScreenState();
}

class _RegistrasiScreenState extends State<RegistrasiScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _konfirmasiPasswordController = TextEditingController();
  bool _lihatPassword = false;
  bool _lihatKonfirmasiPassword = false;

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _konfirmasiPasswordController.dispose();
    super.dispose();
  }

  void _daftar() {
    if (_formKey.currentState!.validate()) {
      // Implementasi logika pendaftaran di sini
      // Untuk sementara, kita hanya akan menampilkan SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pendaftaran berhasil!')),
      );
      // Kembali ke halaman login setelah pendaftaran berhasil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.latar,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.teks),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.latar,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Daftar Akun Baru',
                  style: TextStyle(
                    color: AppColors.teks,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buatInputTeks(
                        controller: _namaController,
                        label: 'Nama Lengkap',
                        icon: Icons.person,
                        validator: (value) =>
                            value!.isEmpty ? 'Nama wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),
                      _buatInputTeks(
                        controller: _emailController,
                        label: 'Email',
                        icon: Icons.email,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email wajib diisi';
                          } else if (!value.contains('@')) {
                            return 'Email tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buatInputTeks(
                        controller: _passwordController,
                        label: 'Password',
                        icon: Icons.lock,
                        isPassword: true,
                        lihatPassword: _lihatPassword,
                        toggleLihatPassword: () =>
                            setState(() => _lihatPassword = !_lihatPassword),
                        validator: (value) => value!.isEmpty
                            ? 'Password wajib diisi'
                            : (value.length < 6
                                ? 'Password minimal 6 karakter'
                                : null),
                      ),
                      const SizedBox(height: 16),
                      _buatInputTeks(
                        controller: _konfirmasiPasswordController,
                        label: 'Konfirmasi Password',
                        icon: Icons.lock,
                        isPassword: true,
                        lihatPassword: _lihatKonfirmasiPassword,
                        toggleLihatPassword: () => setState(() =>
                            _lihatKonfirmasiPassword =
                                !_lihatKonfirmasiPassword),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Konfirmasi password wajib diisi';
                          } else if (value != _passwordController.text) {
                            return 'Password tidak cocok';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _daftar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.aksen,
                          foregroundColor: AppColors.putih,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Daftar',
                            style: TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Sudah punya akun?',
                        style: TextStyle(color: AppColors.teks)),
                    TextButton(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      ),
                      style: TextButton.styleFrom(
                          foregroundColor: AppColors.aksen),
                      child: const Text('Masuk'),
                    ),
                  ],
                ),
              ],
            ),
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
    bool lihatPassword = false,
    VoidCallback? toggleLihatPassword,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !lihatPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.teks),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  lihatPassword ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.teks,
                ),
                onPressed: toggleLihatPassword,
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validator,
    );
  }
}
