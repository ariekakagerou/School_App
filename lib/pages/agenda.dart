import 'package:flutter/material.dart';
import '../services/agenda_services.dart';
import '../theme/app_theme.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  final LayananAgenda _agendaService = LayananAgenda();
  List<dynamic> _agendaItems = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadAgenda();
  }

  Future<void> _loadAgenda() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final agendaList = await _agendaService.ambilSemuaAgenda();
      setState(() {
        _agendaItems = agendaList;
        _agendaItems.sort((a, b) => a['tgl_agenda'].compareTo(b['tgl_agenda']));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal memuat agenda: $e';
      });
    }
  }

  Future<void> _refreshAgenda() async {
    await _loadAgenda();
  }

  void _tambahAgenda() {
    _showAgendaDialog();
  }

  void _editAgenda(Map<String, dynamic> item) {
    _showAgendaDialog(item: item);
  }

  void _showAgendaDialog({Map<String, dynamic>? item}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String judulAgenda = item?['judul_agenda'] ?? '';
        DateTime? tglAgenda =
            item != null ? DateTime.parse(item['tgl_agenda']) : null;
        String isiAgenda = item?['isi_agenda'] ?? '';
        String kdPetugas = item?['kd_petugas'] ?? '';
        return AlertDialog(
          title: Text(item == null ? 'Tambah Agenda Baru' : 'Edit Agenda'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Judul Agenda'),
                onChanged: (value) => judulAgenda = value,
                controller: TextEditingController(text: judulAgenda),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: Text(tglAgenda == null
                    ? 'Pilih Tanggal'
                    : _formatTanggal(tglAgenda)),
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: tglAgenda ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2025),
                  );
                  if (picked != null) {
                    setState(() {
                      tglAgenda = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(labelText: 'Isi Agenda'),
                onChanged: (value) => isiAgenda = value,
                controller: TextEditingController(text: isiAgenda),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Kode Petugas'),
                onChanged: (value) => kdPetugas = value,
                controller: TextEditingController(text: kdPetugas),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Simpan'),
              onPressed: () async {
                if (judulAgenda.isNotEmpty &&
                    tglAgenda != null &&
                    kdPetugas.isNotEmpty) {
                  try {
                    if (item == null) {
                      await _agendaService.tambahAgenda(judulAgenda, isiAgenda,
                          tglAgenda!.toIso8601String(), kdPetugas);
                    } else {
                      await _agendaService.perbaruiAgenda(
                          item['kd_agenda'],
                          judulAgenda,
                          isiAgenda,
                          tglAgenda!.toIso8601String(),
                          kdPetugas);
                    }
                    await _loadAgenda();
                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Gagal ${item == null ? 'menambah' : 'memperbarui'} agenda: $e')),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _hapusAgenda(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Agenda'),
          content: const Text('Apakah Anda yakin ingin menghapus agenda ini?'),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Hapus'),
              onPressed: () async {
                try {
                  await _agendaService.hapusAgenda(item['kd_agenda']);
                  await _loadAgenda();
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menghapus agenda: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda'),
      ),
      body: Container(
        decoration: AppTheme.agendaBackground,
        child: RefreshIndicator(
          onRefresh: _refreshAgenda,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_errorMessage),
                          ElevatedButton(
                            onPressed: _loadAgenda,
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _agendaItems.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: _buildAgendaItem(_agendaItems[index]),
                        );
                      },
                    ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahAgenda,
        backgroundColor: AppColors.aksen,
        foregroundColor: AppColors.putih,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAgendaItem(Map<String, dynamic> item) {
    return Card(
      elevation: 2,
      color: AppColors.putih,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.event, color: AppColors.aksen),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item['judul_agenda'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.teks,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: AppColors.aksen),
                  onPressed: () => _editAgenda(item),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: AppColors.aksen),
                  onPressed: () => _hapusAgenda(item),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _formatTanggal(DateTime.parse(item['tgl_agenda'])),
              style: TextStyle(
                fontSize: 14,
                color: AppColors.teks.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item['isi_agenda'],
              style: const TextStyle(fontSize: 16, color: AppColors.teks),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTanggal(DateTime tanggal) {
    List<String> namaBulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    List<String> namaHari = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu'
    ];

    String hari = namaHari[tanggal.weekday - 1];
    String bulan = namaBulan[tanggal.month - 1];

    return '$hari, ${tanggal.day} $bulan ${tanggal.year}';
  }
}
