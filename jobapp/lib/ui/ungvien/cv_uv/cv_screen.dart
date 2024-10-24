import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:jobapp/controller/user_controller.dart';
import 'package:jobapp/ui/auth/auth_controller.dart';

import '../../../server/database.dart';

class CvScreen extends StatefulWidget {
  const CvScreen({super.key});

  @override
  State<CvScreen> createState() => _CvScreenState();
}

class _CvScreenState extends State<CvScreen> {
  final AuthController controller = Get.find<AuthController>();
  final UserController userController = Get.find<UserController>();
  bool isLoading = true;
  bool showFloatingButton = false;
  List<Map<String, dynamic>> _allMyCv = [];
  @override
  void initState() {
    super.initState();
    _fetchCvUpload();
  }

  void _fetchCvUpload() async {
    setState(() {
      isLoading = true;
    });
    try {
      int uid = controller.userModel.value.id!;
      _allMyCv = await Database().fetchAllCvForUid(uid);
      setState(() {
        isLoading = false;
        showFloatingButton = _allMyCv.isNotEmpty;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.blue,
        title: const Text(
          'Quản lý CV',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 5, bottom: 10.0),
              child: Text(
                'CV đã tải lên',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _allMyCv.isEmpty
                    ? Container(
                        height: 300,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 80,
                                height: 80,
                                child: Image(
                                    image: AssetImage(
                                        'assets/images/uploadfile.jpg')),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  'Chưa có CV nào được tải lên',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  'Tải lên CV có sẳn trong thiết bị để tiếp cận tốt hơn với nhà tuyển dụng',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[400]),
                                ),
                              ),
                              SizedBox(
                                width: 170,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      final result =
                                          await Get.toNamed('/uploadCV');
                                      if (result == true) {
                                        _fetchCvUpload();
                                        setState(() {});
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: Color.fromARGB(136, 0, 0, 0),
                                        ),
                                        Text(
                                          ' Tải CV ngay',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                      ],
                                    )),
                              )
                            ],
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 250,
                        child: ListView.builder(
                          itemCount: _allMyCv.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final cv = _allMyCv[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(() =>
                                      PDFViewerPage(pdfBase64: cv['pdf']));
                                },
                                child: Container(
                                  width: 170,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: PDFView(
                                            pdfData:
                                                base64Decode('${cv['pdf']}'),
                                          ),
                                        ),
                                      ),
                                      const Divider(),
                                      const SizedBox(height: 5),
                                      Text(
                                        cv['nameCv'].toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "${DateTime.parse(cv['time'].toString()).year} -"
                                        "${DateTime.parse(cv['time'].toString()).month} -"
                                        "${DateTime.parse(cv['time'].toString()).day}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
            const Padding(
              padding: EdgeInsets.only(top: 5, bottom: 10.0),
              child: Text(
                'Hồ sơ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 150,
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed('/updateCV');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    print('star');
                                  },
                                  child: const Icon(
                                    Icons.star_border_outlined,
                                  ),
                                ),
                              ),
                              Obx(() {
                                return Row(
                                  children: [
                                    ClipOval(
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: imageFromBase64String(
                                          controller.userModel.value.image
                                              .toString(),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      controller.userModel.value.name
                                          .toString(),
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Obx(() {
                                return Row(
                                  children: [
                                    Text(
                                      "${DateTime.parse(controller.userModel.value.createdAt.toString()).year}-"
                                      "${DateTime.parse(controller.userModel.value.createdAt.toString()).month}-"
                                      "${DateTime.parse(controller.userModel.value.createdAt.toString()).day}  ",
                                    ),
                                    Text(
                                      "${DateTime.parse(controller.userModel.value.createdAt.toString()).hour}:"
                                      "${DateTime.parse(controller.userModel.value.createdAt.toString()).minute}",
                                    ),
                                  ],
                                );
                              }),
                            ),
                            Icon(Icons.more_horiz)
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: showFloatingButton
          ? FloatingActionButton(
              onPressed: () async {
                final result = await Get.toNamed('/uploadCV');
                if (result == true) {
                  _fetchCvUpload();
                  setState(() {});
                }
              },
              backgroundColor: Colors.blue,
              shape: const CircleBorder(),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Image imageFromBase64String(String base64String) {
    if (base64String.isEmpty || base64String == 'null') {
      return const Image(
        image: AssetImage('assets/images/user.png'),
        width: 70,
        height: 70,
        fit: BoxFit.cover,
      );
    }

    try {
      return Image.memory(
        base64Decode(base64String),
        width: 70,
        height: 70,
        fit: BoxFit.cover,
      );
    } catch (e) {
      print('Error decoding Base64 image: $e');
      return const Image(
        image: AssetImage('assets/images/user.png'),
        fit: BoxFit.cover,
      );
    }
  }
}

class PDFViewerPage extends StatelessWidget {
  final String pdfBase64;

  const PDFViewerPage({super.key, required this.pdfBase64});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Xem CV"),
      ),
      body: PDFView(
        pdfData: base64Decode(pdfBase64),
      ),
    );
  }
}
