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

  void _handleDelete(BuildContext context, String message, int cvId) async {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Database().deleteCvUpload(cvId);
              Navigator.pop(context);
              _fetchCvUpload();
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${DateTime.parse(cv['time'].toString()).year} -"
                                              "${DateTime.parse(cv['time'].toString()).month} -"
                                              "${DateTime.parse(cv['time'].toString()).day}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                _showMoreBottomSheet(
                                                    context,
                                                    cv['nameCv'],
                                                    cv['pdf'],
                                                    cv['cv_id']);
                                              },
                                              icon: Icon(Icons.more_horiz),
                                            ),
                                          ],
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

  void _showMoreBottomSheet(
      BuildContext context, String cvName, String pdf, int cvId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (ctx, setState) {
          return FractionallySizedBox(
            heightFactor: 0.35,
            widthFactor: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    cvName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 400,
                    color: Colors.grey[200],
                    child: SingleChildScrollView(
                        child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(() => PDFViewerPage(pdfBase64: pdf));
                            },
                            child: Container(
                              width: 400,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Icon(Icons.visibility),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Xem',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return DoiTenDialog(
                                    name: cvName,
                                    cvId: cvId,
                                    onUpdate: () {
                                      _fetchCvUpload();
                                    },
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: 400,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Icon(Icons.edit),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Đổi tên',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              _handleDelete(
                                  context, 'Bạn có muốn xóa cv', cvId);
                            },
                            child: Container(
                              width: 400,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Xóa',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    )),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
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

// ignore: must_be_immutable
class DoiTenDialog extends StatefulWidget {
  String name;
  int cvId;
  final VoidCallback onUpdate;
  DoiTenDialog(
      {required this.name,
      required this.cvId,
      required this.onUpdate,
      super.key});

  @override
  State<DoiTenDialog> createState() => _DoiTenDialogState();
}

class _DoiTenDialogState extends State<DoiTenDialog> {
  final nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    nameController.text = widget.name;
  }

  void _handleUpdateNameCV() async {
    String nameCV = nameController.text;
    try {
      Database().updateNameCV(widget.cvId, nameCV);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: 380,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Đổi tên",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5.0),
            SizedBox(
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tên CV',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              nameController.clear();
                              print('clear');
                            });
                          },
                          icon: Icon(Icons.cancel_sharp)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.0),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.blue),
                    child: TextButton(
                      onPressed: () async {
                        _handleUpdateNameCV();
                        Navigator.pop(context);
                        widget.onUpdate();
                      },
                      child: Text(
                        "Đổi tên",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[300]),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Hủy",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
