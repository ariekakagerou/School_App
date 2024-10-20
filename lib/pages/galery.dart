import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<dynamic> galleryData = [];
  bool isLoading = true;
  final String apiUrl =
      'https://praktikum-cpanel-unbin.com/kelompok_ojan/school_apps_api/galery_api.php'; // Definisikan apiUrl di sini

  @override
  void initState() {
    super.initState();
    fetchGalleryData();
  }

  Future<void> fetchGalleryData() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse(
        'https://praktikum-cpanel-unbin.com/kelompok_ojan/school_apps_api/galery_api.php'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        galleryData = jsonData['data'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memuat data galeri')),
      );
    }
  }

  void showGalleryForm({Map<String, dynamic>? item}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GalleryFormDialog(
          item: item,
          onSave: (newItem) {
            if (item == null) {
              addGalleryItem(newItem);
            } else {
              if (newItem['kd_galery'] != null) {
                editGalleryItem(newItem);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ID galeri tidak valid')),
                );
              }
            }
          },
        );
      },
    );
  }

  Future<void> addGalleryItem(Map<String, dynamic> newItem) async {
    final url = Uri.parse(apiUrl); // Gunakan apiUrl yang sudah didefinisikan
    var request = http.MultipartRequest('POST', url);

    request.fields['judul_galery'] = newItem['judul_galery'];
    request.fields['isi_galery'] = newItem['isi_galery'];
    request.fields['tgl_post_galery'] = newItem['tgl_post_galery'];
    request.fields['status_galery'] = newItem['status_galery'];
    request.fields['kd_petugas'] = newItem['kd_petugas'];

    if (newItem['foto_galery'] != null) {
      final bytes = await newItem['foto_galery'].readAsBytes();
      request.files.add(http.MultipartFile.fromBytes(
        'foto_galery',
        bytes,
        filename: newItem['foto_galery'].name,
      ));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil menambahkan item galeri')),
      );
      fetchGalleryData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menambahkan item galeri')),
      );
    }
  }

  Future<void> editGalleryItem(Map<String, dynamic> updatedItem) async {
    final url = Uri.parse('$apiUrl?kd_galery=${updatedItem['kd_galery']}');

    // Ambil nilai status_galery dari item yang ada
    String statusGalery =
        updatedItem['status_galery'] ?? '0'; // Default ke '0' jika tidak ada

    // Pastikan status_galery adalah '0' atau '1'
    if (statusGalery != '0' && statusGalery != '1') {
      statusGalery = '0'; // Set default jika tidak sesuai
    }

    Map<String, dynamic> jsonData = {
      'kd_galery': updatedItem['kd_galery'],
      'judul_galery': updatedItem['judul_galery'],
      'isi_galery': updatedItem['isi_galery'],
      'tgl_post_galery': updatedItem['tgl_post_galery'],
      'status_galery': statusGalery, // Pastikan ini sesuai
      'kd_petugas': updatedItem['kd_petugas'],
    };

    if (updatedItem['foto_galery'] != null) {
      List<int> imageBytes = await updatedItem['foto_galery'].readAsBytes();
      String base64Image = base64Encode(imageBytes);
      jsonData['foto_galery'] = 'data:image/png;base64,$base64Image';
    }

    try {
      print(
          'Sending PUT request to $url with data: $jsonData'); // Log data yang dikirim
      final response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(jsonData),
      );

      final responseBody = json.decode(response.body);
      print('Response: ${response.statusCode} - $responseBody'); // Log respons

      if (response.statusCode == 200) {
        if (responseBody['status'] == 'sukses') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Berhasil memperbarui item galeri')),
          );
          fetchGalleryData();
        } else {
          throw Exception(
              responseBody['message'] ?? 'Gagal memperbarui galeri');
        }
      } else {
        throw Exception('Gagal memperbarui galeri: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating gallery: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Gagal memperbarui item galeri: ${e.toString()}')),
      );
    }
  }

  Future<void> deleteGalleryItem(String kdGallery) async {
    final url = Uri.parse(
        'https://praktikum-cpanel-unbin.com/kelompok_ojan/school_apps_api/galery_api.php?kd_galery=$kdGallery');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'sukses') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berhasil menghapus item galeri')),
        );
        fetchGalleryData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Gagal menghapus item galeri: ${jsonResponse['message'] ?? 'Terjadi kesalahan'}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Gagal menghapus item galeri: Kesalahan jaringan')),
      );
    }
  }

  Future<void> _refreshGalleryData() async {
    await fetchGalleryData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Galeri'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshGalleryData,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75, // Adjust aspect ratio for cards
                ),
                itemCount: galleryData.length,
                itemBuilder: (context, index) {
                  final item = galleryData[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.all(8),
                    elevation: 3,
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10)),
                            child: Image.network(
                              'https://praktikum-cpanel-unbin.com/kelompok_ojan/school_apps_api/uploads/${item['foto_galery']}',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                    child: Icon(Icons.error, size: 50));
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            item['judul_galery'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(item['isi_galery'],
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                        ),
                        OverflowBar(
                          alignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => showGalleryForm(item: item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Konfirmasi Hapus'),
                                    content: const Text(
                                        'Apakah Anda yakin ingin menghapus item ini?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text('Batal'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          deleteGalleryItem(item['kd_galery']);
                                        },
                                        child: const Text('Hapus'),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showGalleryForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class GalleryFormDialog extends StatefulWidget {
  final Map<String, dynamic>? item;
  final Function(Map<String, dynamic>) onSave;

  const GalleryFormDialog({super.key, this.item, required this.onSave});

  @override
  _GalleryFormDialogState createState() => _GalleryFormDialogState();
}

class _GalleryFormDialogState extends State<GalleryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _isiController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _judulController.text = widget.item!['judul_galery'];
      _isiController.text = widget.item!['isi_galery'];
      _tanggalController.text = widget.item!['tgl_post_galery'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.item == null ? 'Tambah Galeri' : 'Edit Galeri'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.item != null) // Tampilkan ID galeri saat mengedit
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'ID Galeri: ${widget.item!['kd_galery']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            TextFormField(
              controller: _judulController,
              decoration: const InputDecoration(labelText: 'Judul Galeri'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Judul tidak boleh kosong';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _isiController,
              decoration: const InputDecoration(labelText: 'Isi Galeri'),
              maxLines: 2,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Isi tidak boleh kosong';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _tanggalController,
              decoration: const InputDecoration(labelText: 'Tanggal Post'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tanggal tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () async {
                _image = await _picker.pickImage(source: ImageSource.gallery);
                setState(() {});
              },
              child: Text(_image == null
                  ? 'Pilih Gambar'
                  : 'Gambar Dipilih: ${_image!.name}'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Map<String, dynamic> newItem = {
                'kd_galery': widget.item != null
                    ? widget.item!['kd_galery']
                    : null, // Pastikan kd_galery dikirim
                'judul_galery': _judulController.text,
                'isi_galery': _isiController.text,
                'tgl_post_galery': _tanggalController.text,
                'kd_petugas': '1', // Hardcoded for simplicity
                'status_galery': 'active', // Default status
                'foto_galery': _image,
              };
              widget.onSave(newItem);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
