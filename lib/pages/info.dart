import 'package:flutter/material.dart';
import '../services/info_services.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final InfoService _infoService = InfoService();
  List<InfoItem> _infoItems = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  Future<void> _loadInfo() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final infoList = await _infoService.fetchAllInfo();
      setState(() {
        _infoItems = infoList.map((item) => InfoItem.fromJson(item)).toList();
        _isLoading = false;
      });
      print('Jumlah info yang dimuat: ${_infoItems.length}');
      for (var item in _infoItems) {
        print(
            'KD_INFO: ${item.kdInfo}, Judul: ${item.judulInfo}, Isi: ${item.isiInfo}, Tanggal: ${item.tglPostInfo}, Status: ${item.statusInfo}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal memuat informasi: $e';
      });
      print('Error saat memuat info: $e');
    }
  }

  Future<void> _refreshInfo() async {
    await _loadInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFE6F2FF), // Warna latar belakang biru muda
      appBar: AppBar(
        title: const Text('Informasi Sekolah',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshInfo,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage.isNotEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_errorMessage),
                        ElevatedButton(
                          onPressed: _loadInfo,
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  )
                : _infoItems.isEmpty
                    ? const Center(child: Text('Tidak ada informasi tersedia'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: _infoItems.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: _buildInfoCard(_infoItems[index]),
                          );
                        },
                      ),
      ),
    );
  }

  Widget _buildInfoCard(InfoItem item) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.judulInfo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(item.isiInfo, style: const TextStyle(color: Colors.black87)),
            const SizedBox(height: 8),
            Text(
              'Tanggal: ${item.tglPostInfo}',
              style: const TextStyle(color: Colors.blue, fontSize: 12),
            ),
            Text(
              'Status: ${item.statusInfo}',
              style: const TextStyle(color: Colors.blue, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoItem {
  final String kdInfo;
  final String judulInfo;
  final String isiInfo;
  final String tglPostInfo;
  final String statusInfo;
  final String kdPetugas;

  InfoItem({
    required this.kdInfo,
    required this.judulInfo,
    required this.isiInfo,
    required this.tglPostInfo,
    required this.statusInfo,
    required this.kdPetugas,
  });

  factory InfoItem.fromJson(Map<String, dynamic> json) {
    return InfoItem(
      kdInfo: json['kd_info'] ?? '',
      judulInfo: json['judul_info'] ?? '',
      isiInfo: json['isi_info'] ?? '',
      tglPostInfo: json['tgl_post_info'] ?? '',
      statusInfo: json['status_info'] ?? '',
      kdPetugas: json['kd_petugas'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kd_info': kdInfo,
      'judul_info': judulInfo,
      'isi_info': isiInfo,
      'tgl_post_info': tglPostInfo,
      'status_info': statusInfo,
      'kd_petugas': kdPetugas,
    };
  }
}
