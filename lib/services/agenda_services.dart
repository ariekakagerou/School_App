import 'dart:convert';
import 'package:http/http.dart' as http;

class LayananAgenda {
  static const String urlDasar =
      'https://praktikum-cpanel-unbin.com/kelompok_ojan/school_apps_api/agenda_api.php'; // Sesuaikan URL dengan alamat server Anda

  // Fungsi untuk mengambil semua agenda
  Future<List<dynamic>> ambilSemuaAgenda() async {
    final respons = await http.get(Uri.parse('$urlDasar/agenda_api.php'));

    if (respons.statusCode == 200) {
      final data = jsonDecode(respons.body);
      return data['data'];
    } else {
      throw Exception('Gagal memuat agenda');
    }
  }

  // Fungsi untuk mengambil agenda berdasarkan kd_agenda
  Future<Map<String, dynamic>> ambilAgendaBerdasarkanId(String kdAgenda) async {
    final respons =
        await http.get(Uri.parse('$urlDasar/agenda_api?kd_agenda=$kdAgenda'));

    if (respons.statusCode == 200) {
      final data = jsonDecode(respons.body);
      return data['data'];
    } else {
      throw Exception('Gagal memuat agenda');
    }
  }

  // Fungsi untuk menambah agenda baru
  Future<bool> tambahAgenda(String judulAgenda, String isiAgenda,
      String tglAgenda, String kdPetugas) async {
    final respons = await http.post(
      Uri.parse('$urlDasar/agenda_api.php'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'judul_agenda': judulAgenda,
        'isi_agenda': isiAgenda,
        'tgl_agenda': tglAgenda,
        'kd_petugas': kdPetugas,
      }),
    );

    if (respons.statusCode == 200) {
      final data = jsonDecode(respons.body);
      return data['status'] == 'sukses';
    } else {
      throw Exception('Gagal menambahkan agenda');
    }
  }

  // Fungsi untuk memperbarui agenda
  Future<bool> perbaruiAgenda(String kdAgenda, String judulAgenda,
      String isiAgenda, String tglAgenda, String kdPetugas) async {
    final respons = await http.put(
      Uri.parse('$urlDasar/agenda_api.php'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'kd_agenda': kdAgenda,
        'judul_agenda': judulAgenda,
        'isi_agenda': isiAgenda,
        'tgl_agenda': tglAgenda,
        'kd_petugas': kdPetugas,
      }),
    );

    if (respons.statusCode == 200) {
      final data = jsonDecode(respons.body);
      return data['status'] == 'sukses';
    } else {
      throw Exception('Gagal memperbarui agenda');
    }
  }

  // Fungsi untuk menghapus agenda
  Future<bool> hapusAgenda(String kdAgenda) async {
    final respons = await http
        .delete(Uri.parse('$urlDasar/agenda_api.php?kd_agenda=$kdAgenda'));

    if (respons.statusCode == 200) {
      final data = jsonDecode(respons.body);
      return data['status'] == 'sukses';
    } else {
      throw Exception('Gagal menghapus agenda');
    }
  }
}
