import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../server/database.dart';
import '../../../auth/auth_controller.dart';

class UploadCv extends StatefulWidget {
  const UploadCv({super.key});

  @override
  State<UploadCv> createState() => _UploadCvState();
}

class _UploadCvState extends State<UploadCv> {
  final AuthController controller = Get.find<AuthController>();
  String? _pdfPath;
  int? _fileSize;
  String? fileSizeKB;
  bool _isLoading = false;

  Future<void> _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _pdfPath = result.files.single.path;
        _fileSize = result.files.single.size;

        fileSizeKB = (_fileSize! / 1024).toStringAsFixed(2);
      });
    }
  }

  Future<void> _uploadPDF() async {
    if (_pdfPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn file PDF')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final bytes = await File(_pdfPath!).readAsBytes();
      int uid = controller.userModel.value.id!;
      String nameCv = _pdfPath!.split('/').last;
      DateTime time = DateTime.now();
      final pdfBase64 = base64Encode(bytes);

      await Database().uploadCV(uid, nameCv, time, pdfBase64);

      setState(() {
        _isLoading = false;
      });

      Get.back(result: true);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Lỗi upload CV: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi upload CV')),
      );
    }
  }

  void _deleteFilePath() {
    setState(() {
      _pdfPath = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tải CV lên'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: const Color.fromARGB(255, 137, 201, 247),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 250,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Upload CV để các cơ hội việc làm tự tìm đến bạn',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Giảm 50% thời gian cần thiết để tìm được một công việc phù hợp',
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ],
                    ),
                  ),
                  Image(
                    image: AssetImage('assets/images/file.png'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.white,
              height: 500,
              child: Center(
                child: _pdfPath != null
                    ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: double.infinity,
                          height: 80,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[300]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.upload_file_outlined,
                                color: Colors.blue,
                                size: 40,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _pdfPath!.split('/').last,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text('$fileSizeKB KB'),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _deleteFilePath();
                                  print(_pdfPath);
                                },
                                icon: Icon(Icons.clear),
                              ),
                            ],
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _pickPDF();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              height: 180,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return const LinearGradient(
                                        colors: [Colors.white, Colors.blue],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ).createShader(bounds);
                                    },
                                    child: const Icon(
                                      Icons.cloud_upload_rounded,
                                      size: 50,
                                      color: Color.fromARGB(255, 122, 188, 243),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      'Nhấn để tải lên',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: const TextSpan(
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                        children: [
                                          TextSpan(
                                              text:
                                                  'Hỗ trợ định dạng .doc, .docx, pdf có kích thước dưới '),
                                          TextSpan(
                                            text: '5MB',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ),
          Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter, // Đặt nút ở dưới cùng
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _uploadPDF();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 11.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Tải CV lên',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
