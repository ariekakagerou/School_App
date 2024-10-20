import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:school_apps2/pages/profile.dart'; // Impor halaman profil

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController();
  Timer? _timer;
  final _images = List.generate(5, (index) => 'assets/images/${index + 1}.jpg');
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _nextPage());
  }

  void _nextPage() {
    setState(() {
      _currentPage = (_currentPage + 1) % _images.length;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    // Implementasi logika refresh di sini
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      // Perbarui data yang diperlukan
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.latar,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildImageSlider(),
              _buildScheduleTable(),
              _buildAdditionalIcons(),
              _buildInfoSection(),
              _buildAgendaSection(),
              _buildGallery(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      toolbarHeight: 60,
      title: _buildWelcomeRow(),
      backgroundColor: AppColors.putih,
      iconTheme: const IconThemeData(color: AppColors.teks),
      actions: [
        IconButton(
            icon: const Icon(Icons.notifications, size: 20), onPressed: () {})
      ],
    );
  }

  Widget _buildWelcomeRow() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          },
          child: const CircleAvatar(
            radius: 12,
            backgroundColor: AppColors.aksen,
            child: Icon(Icons.person, color: AppColors.putih, size: 14),
          ),
        ),
        const SizedBox(width: 6),
        const Expanded(
          child: Text(
            'Selamat Datang, Mahasiswa!',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.teks),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildImageSlider() {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _images.length,
        itemBuilder: (_, index) => _buildSliderItem(_images[index]),
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
      ),
    );
  }

  Widget _buildSliderItem(String imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
              color: Colors.black26, blurRadius: 5.0, offset: Offset(0, 2))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Text('Gambar tidak dapat dimuat'),
            );
          },
        ),
      ),
    );
  }

  Widget _buildScheduleTable() {
    return _buildCard(
      'Jadwal Hari Ini',
      LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Table(
                border: TableBorder.all(color: AppColors.aksen),
                defaultColumnWidth: const IntrinsicColumnWidth(),
                children: [
                  _buildTableRow(['Waktu', 'Mata Pelajaran', 'Pengajar'],
                      isHeader: true),
                  _buildTableRow([
                    '08:00 - 09:30',
                    'Matematika',
                    'Dr. Budi Santoso,\nM.Pd.',
                  ]),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard(String title, Widget content) {
    return Card(
      color: AppColors.putih,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.teks),
            ),
            const SizedBox(height: 12),
            content,
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      children: cells
          .map((cell) => TableCell(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: Text(
                    cell,
                    style: TextStyle(
                      fontWeight:
                          isHeader ? FontWeight.bold : FontWeight.normal,
                      color: isHeader ? AppColors.teks : null,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildAdditionalIcons() {
    final icons = [
      ['Jadwal', Icons.schedule],
      ['Tugas', Icons.assignment],
      ['Nilai', Icons.grade],
      ['Absensi', Icons.how_to_reg],
      ['Perpustakaan', Icons.library_books],
      ['Pengumuman', Icons.announcement],
      ['Ekstrakurikuler', Icons.sports_soccer],
      ['Kontak Guru', Icons.contact_mail],
    ];

    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: icons
          .map((icon) =>
              _buildIconButton(icon[0] as String, icon[1] as IconData))
          .toList(),
    );
  }

  Widget _buildIconButton(String label, IconData icon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: AppColors.aksen, size: 32), // Ukuran ikon diperbesar
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
              color: AppColors.teks, fontSize: 12), // Ukuran teks diperbesar
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'INFO',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.teks,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Handle "LIHAT SEMUA" action
                  },
                  child: const Text(
                    'LIHAT SEMUA',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.aksen,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) {
              return _buildInfoItem(
                date: '2023.05.${20 - index}',
                title: [
                  'Pengumuman Jadwal UAS Semester Genap 2022/2023',
                  'Seminar Nasional Teknologi Informasi 2023',
                  'Pelatihan Soft Skills untuk Mahasiswa IT',
                  'Lowongan Magang di Perusahaan IT Terkemuka'
                ][index],
                isNew: index == 0,
                isImportant: index == 0 || index == 1,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required String date,
    required String title,
    bool isNew = false,
    bool isImportant = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.indigo[900],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            color: isImportant ? Colors.red : AppColors.aksen,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    if (isNew) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Baru!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgendaSection() {
    print('Building Agenda Section');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'AGENDA',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.teks,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Handle "LIHAT SEMUA" action
                },
                child: const Text(
                  'LIHAT SEMUA',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.aksen,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          itemBuilder: (context, index) {
            return _buildAgendaItem(
              date: '2023.06.${01 + index}',
              title: [
                'Rapat Koordinasi Persiapan Ujian Akhir Semester',
                'Workshop Penulisan Karya Ilmiah',
                'Seminar Karir di Bidang Teknologi Informasi',
                'Pekan Olahraga Mahasiswa Fakultas'
              ][index],
              isNew: index == 0,
              isImportant: index == 0 || index == 2,
            );
          },
        ),
      ],
    );
  }

  Widget _buildAgendaItem({
    required String date,
    required String title,
    bool isNew = false,
    bool isImportant = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.putih,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            color: isImportant ? Colors.orange : AppColors.aksen,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.teks.withOpacity(0.6),
                      ),
                    ),
                    if (isNew) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Baru!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.teks,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGallery() {
    print('Building Gallery Section');
    return Container(
      color: Colors.white, // Mengubah latar belakang menjadi putih
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'GALERI',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.teks,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Handle "LIHAT SEMUA" action
                  },
                  child: const Text(
                    'LIHAT SEMUA',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.aksen,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5, // Jumlah foto yang ingin ditampilkan
              itemBuilder: (context, index) {
                return _buildGalleryItem(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryItem(int index) {
    return Container(
      width: 120,
      margin: EdgeInsets.only(left: index == 0 ? 16 : 8, right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[300], // Placeholder color
      ),
      child: Center(
        child: Text('Foto ${index + 1}'),
      ),
    );
  }
}
