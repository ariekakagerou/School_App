import 'dart:convert';
import 'package:http/http.dart' as http;

class InfoService {
  static const String baseUrl =
      'https://praktikum-cpanel-unbin.com/kelompok_ojan/school_apps_api/info_api.php'; // Sesuaikan URL dengan server kamu

  // Fungsi untuk mendapatkan semua data info
  Future<List<dynamic>> fetchAllInfo() async {
    final response = await http.get(Uri.parse('$baseUrl/info_api.php'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'sukses') {
        return data['data'];
      } else {
        throw Exception(data['pesan']);
      }
    } else {
      throw Exception('Failed to load info');
    }
  }

  // Fungsi untuk mendapatkan detail info berdasarkan kd_info
  Future<Map<String, dynamic>> fetchInfoById(String kdInfo) async {
    final response =
        await http.get(Uri.parse('$baseUrl/info_api.php?kd_info=$kdInfo'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'sukses') {
        return data['data'];
      } else {
        throw Exception(data['pesan']);
      }
    } else {
      throw Exception('Gagal memuat info');
    }
  }

  // Fungsi untuk menambahkan info baru
  Future<bool> addInfo(String judulInfo, String isiInfo, String tglPostInfo,
      String statusInfo, String kdPetugas) async {
    final response = await http.post(
      Uri.parse('$baseUrl/info_api.php'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'judul_info': judulInfo,
        'isi_info': isiInfo,
        'tgl_post_info': tglPostInfo,
        'status_info': statusInfo,
        'kd_petugas': kdPetugas,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['status'] == 'sukses';
    } else {
      throw Exception('Gagal menambahkan info');
    }
  }

  // Fungsi untuk memperbarui info
  Future<bool> updateInfo(String kdInfo, String judulInfo, String isiInfo,
      String tglPostInfo, String statusInfo, String kdPetugas) async {
    final response = await http.put(
      Uri.parse('$baseUrl/info_api.php'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'kd_info': kdInfo,
        'judul_info': judulInfo,
        'isi_info': isiInfo,
        'tgl_post_info': tglPostInfo,
        'status_info': statusInfo,
        'kd_petugas': kdPetugas,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['status'] == 'sukses';
    } else {
      throw Exception('Gagal memperbarui info');
    }
  }

  // Fungsi untuk menghapus info
  Future<bool> deleteInfo(String kdInfo) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/info_api.php?kd_info=$kdInfo'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['status'] == 'sukses';
    } else {
      throw Exception('Gagal menghapus info');
    }
  }
}
