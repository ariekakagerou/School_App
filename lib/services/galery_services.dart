import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Definisi kelas Galery (Model)
class Galery {
  final String kdGalery;
  final String judulGalery;
  final String fotoGalery;
  final String isiGalery;
  final String tglPostGalery;
  final String statusGalery;
  final String kdPetugas;

  Galery({
    required this.kdGalery,
    required this.judulGalery,
    required this.fotoGalery,
    required this.isiGalery,
    required this.tglPostGalery,
    required this.statusGalery,
    required this.kdPetugas,
  });

  factory Galery.fromJson(Map<String, dynamic> json) {
    return Galery(
      kdGalery: json['kd_galery'],
      judulGalery: json['judul_galery'],
      fotoGalery: json['foto_galery'],
      isiGalery: json['isi_galery'],
      tglPostGalery: json['tgl_post_galery'],
      statusGalery: json['status_galery'],
      kdPetugas: json['kd_petugas'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kd_galery': kdGalery,
      'judul_galery': judulGalery,
      'foto_galery': fotoGalery,
      'isi_galery': isiGalery,
      'tgl_post_galery': tglPostGalery,
      'status_galery': statusGalery,
      'kd_petugas': kdPetugas,
    };
  }
}

// Service untuk menangani operasi CRUD galeri
class GaleryService {
  final String baseUrl =
      'https://praktikum-cpanel-unbin.com/kelompok_ojan/school_apps_api/galery_api.php';

  // Fungsi untuk mengambil data galeri dari API
  Future<List<Galery>> fetchGaleryData() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success' && jsonData['data'] is List) {
          return (jsonData['data'] as List)
              .map((item) => Galery.fromJson(item))
              .toList();
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Failed to load gallery data');
      }
    } catch (e) {
      print('Error in fetchGaleryData: $e');
      rethrow;
    }
  }

  // Fungsi untuk menambah item galeri
  Future<bool> addGaleryItem(Map<String, dynamic> newItem) async {
    final url = Uri.parse(baseUrl);
    var request = http.MultipartRequest('POST', url);

    // Menambahkan data teks ke dalam request
    request.fields['judul_galery'] = newItem['judul_galery'];
    request.fields['isi_galery'] = newItem['isi_galery'];
    request.fields['tgl_post_galery'] =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    request.fields['status_galery'] = newItem['status_galery'];
    request.fields['kd_petugas'] = newItem['kd_petugas'];

    // Menangani upload gambar untuk mobile dan web
    if (newItem['foto_galery'] != null) {
      if (kIsWeb) {
        // Penanganan upload untuk platform web
        request.fields['foto_galery'] = newItem['foto_galery'];
      } else if (Platform.isAndroid || Platform.isIOS) {
        // Penanganan upload untuk mobile (Android/iOS)
        File imageFile = File(newItem['foto_galery']);
        request.files.add(
          await http.MultipartFile.fromPath(
            'foto_galery',
            imageFile.path,
          ),
        );
      }
    }

    // Mengirimkan request ke server
    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 201 || response.statusCode == 200) {
        var jsonResponse = json.decode(responseBody);
        if (jsonResponse['status'] == 'success') {
          return true;
        } else {
          throw Exception(jsonResponse['message']);
        }
      } else {
        throw Exception(
            'Failed to add gallery item: ${response.statusCode}\n$responseBody');
      }
    } catch (e) {
      print("Error saat mengirim request: $e");
      return false;
    }
  }

  // Fungsi untuk mengedit item galeri
  Future<bool> editGaleryItem(Map<String, dynamic> updatedItem) async {
    final url = Uri.parse(baseUrl);
    var request = http.MultipartRequest('PUT', url);

    // Menambahkan data teks ke dalam request
    request.fields['kd_galery'] = updatedItem['kd_galery'];
    request.fields['judul_galery'] = updatedItem['judul_galery'];
    request.fields['isi_galery'] = updatedItem['isi_galery'];
    request.fields['status_galery'] = updatedItem['status_galery'];
    request.fields['kd_petugas'] = updatedItem['kd_petugas'];

    // Menangani upload gambar jika ada
    if (updatedItem['foto_galery'] != null) {
      if (kIsWeb) {
        request.fields['foto_galery'] = updatedItem['foto_galery'];
      } else if (Platform.isAndroid || Platform.isIOS) {
        File imageFile = File(updatedItem['foto_galery']);
        request.files.add(
          await http.MultipartFile.fromPath(
            'foto_galery',
            imageFile.path,
          ),
        );
      }
    }

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(responseBody);
        if (jsonResponse['status'] == 'success') {
          return true;
        } else {
          throw Exception(jsonResponse['message']);
        }
      } else {
        throw Exception(
            'Failed to update gallery item: ${response.statusCode}\n$responseBody');
      }
    } catch (e) {
      print("Error saat mengirim request: $e");
      return false;
    }
  }

  // Fungsi untuk menghapus item galeri
  Future<bool> deleteGaleryItem(String kdGalery) async {
    final url = Uri.parse('$baseUrl?kd_galery=$kdGalery');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        return true;
      } else {
        throw Exception(jsonResponse['message']);
      }
    } else {
      throw Exception('Failed to delete gallery item');
    }
  }
}
