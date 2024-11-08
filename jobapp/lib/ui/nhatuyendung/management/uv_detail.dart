import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobapp/server/database.dart';
import 'package:jobapp/ui/auth/auth_controller.dart';

class UvDetail extends StatefulWidget {
  const UvDetail({super.key});

  @override
  State<UvDetail> createState() => _UvDetailState();
}

class _UvDetailState extends State<UvDetail> {
  AuthController controller = Get.find<AuthController>();
  Map<String, dynamic> userData = {};
  Map<String, dynamic> data = {};
  late int uid;
  late int jid;
  late int cvId;
  late String nameCv;
  late String status;
  bool _isLoading = true;
  bool _isChecked1 = false;
  bool _isChecked2 = false;
  @override
  void initState() {
    super.initState();
    data = Get.arguments;
    uid = data['uid'];
    jid = data['jid'];
    cvId = data['cv_id'];
    nameCv = data['nameCv'];
    status = data['status'];

    _fetchUserData();
  }

  void _fetchUserData() async {
    try {
      userData = await Database().fetchUserForId(uid);
    } catch (e) {
      print(e);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleSubmitRight() async {
    String nameC = controller.companyModel.value.name!;
    try {
      switch (status) {
        case 'applied':
          await Database().updateApplicantStatus(jid, uid, 'approved', nameC);
          break;
        case 'approved':
        case 'rejected':
        case 'cancelled':
          Get.snackbar(
              'Thông báo', 'Tính năng đang trong quá trình phát triển');
          break;
        default:
          Get.snackbar('Lỗi', 'Trạng thái không xác định');
      }
    } catch (e) {
      print(e);
    }
  }

  void _handleSubmit() async {
    String nameC = controller.companyModel.value.name!;
    try {
      switch (status) {
        case 'applied':
          await Database().updateApplicantStatus(jid, uid, 'rejected', nameC);
          break;
        case 'approved':
        case 'rejected':
        case 'cancelled':
          Get.snackbar(
              'Thông báo', 'Tính năng đang trong quá trình phát triển');
          break;
        default:
          Get.snackbar('Lỗi', 'Trạng thái không xác định');
      }
    } catch (e) {
      print(e);
    }
  }

// button right
  String _getApproveButtonText(String status) {
    switch (status) {
      case 'applied':
        return 'Chấp nhận';
      case 'approved':
        return 'Liên hệ';
      case 'rejected':
        return 'Liên hệ';
      case 'cancelled':
        return 'Liên hệ';
      default:
        return 'null';
    }
  }

  Color? _getApproveButtonColor(String status) {
    switch (status) {
      case 'applied':
        return Colors.lightGreenAccent[700];
      case 'approved':
      case 'rejected':
      case 'cancelled':
        return Colors.lightGreenAccent[700];
      default:
        return Colors.grey;
    }
  }

// button left
  String _getRejectButtonText(String status) {
    switch (status) {
      case 'applied':
        return 'Từ chối';
      case 'approved':
        return 'Đã nhận';
      case 'rejected':
        return 'Đã từ chối';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return 'Không xác định';
    }
  }

  Color _getRejectButtonColor(String status) {
    switch (status) {
      case 'applied':
        return Colors.red;
      case 'approved':
      case 'rejected':
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

// avatar
  Image imageFromBase64String(String base64String) {
    if (base64String.isEmpty || base64String == 'null') {
      return const Image(
        image: AssetImage('assets/images/user.png'),
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      );
    }

    try {
      return Image.memory(
        base64Decode(base64String),
        width: 60,
        height: 60,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ ứng viên'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Card(
                elevation: 0.0,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ClipOval(
                                      child: imageFromBase64String(
                                        userData['image'],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userData['name'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Tuổi: 12',
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Text(
                                                'Giới tính: ${userData['gender']}',
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        height: 1,
                        width: 360,
                        color: const Color.fromARGB(255, 143, 143, 143),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'THÔNG TIN LIÊN HỆ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 100,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.blue,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(
                                        Icons.email,
                                        size: 30,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Text(
                                      '[userData[email]]',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(
                                        Icons.phone,
                                        size: 30,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Text(
                                      '[userData[phone]]',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 15),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Xem thông tin liên hệ ứng viên',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 0, bottom: 10),
                        height: 1,
                        width: 360,
                        color: const Color.fromARGB(255, 143, 143, 143),
                      ),
                      const Text(
                        'CV ỨNG TUYỂN',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 70,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 226, 230),
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.insert_drive_file,
                              size: 30,
                              color: Colors.red[400],
                            ),
                            Expanded(
                              child: Text(
                                nameCv,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.toNamed('/cvReview', arguments: cvId);
                              },
                              child: Text(
                                'Xem',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.all(8),
                        height: 1,
                        width: 360,
                        color: const Color.fromARGB(255, 143, 143, 143),
                      ),
                      const Text(
                        'Đánh giá CV',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            Text(
                                'Thực hiện đánh giá để tối ưu chiến dịch tuyển dụng của bạn'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 50,
                                  width: 170,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 64, 205, 68),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: _isChecked1,
                                        onChanged: (value) {
                                          setState(() {
                                            _isChecked1 = value!;
                                            _isChecked2 = false;
                                          });
                                        },
                                      ),
                                      Text(
                                        'Phù hợp',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  width: 170,
                                  decoration: BoxDecoration(
                                      color: Colors.red[100],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: _isChecked2,
                                        onChanged: (value) {
                                          setState(() {
                                            _isChecked2 = value!;
                                            _isChecked1 = false;
                                          });
                                        },
                                      ),
                                      Text(
                                        'Không phù hợp',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (_isChecked1 || _isChecked2)
                              Column(
                                children: [
                                  Text(
                                      'Trạng thái: ${_isChecked1 ? 'Phù hợp' : 'Không phù hợp'}'),
                                  const Text('Nguồn: Ứng tuyển'),
                                ],
                              ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: PreferredSize(
        preferredSize: const Size.fromHeight(200),
        child: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.only(right: 5),
            child: SizedBox(
              width: 180,
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _handleSubmit();
                        Get.back(result: 'rejected');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getRejectButtonColor(status),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        _getRejectButtonText(status),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        _handleSubmitRight();
                        Get.back(result: 'accepted');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getApproveButtonColor(status),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        _getApproveButtonText(status),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
