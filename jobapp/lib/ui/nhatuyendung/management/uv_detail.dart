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
  late String status;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    data = Get.arguments;
    uid = data['uid'];
    jid = data['jid'];
    status = data['status'];
    print('$uid, $status');
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
    String nameC = controller.name!;
    try {
      switch (status) {
        case 'đã ứng tuyển':
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
    String nameC = controller.name!;
    try {
      switch (status) {
        case 'đã ứng tuyển':
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
      case 'đã ứng tuyển':
        return 'Chấp nhận'; // Pending -> Allow approve
      case 'approved':
        return 'Liên hệ'; // Already approved
      case 'rejected':
        return 'Liên hệ'; // Can't approve once rejected
      case 'cancelled':
        return 'Liên hệ'; // Application cancelled
      default:
        return 'null';
    }
  }

  Color? _getApproveButtonColor(String status) {
    switch (status) {
      case 'đã ứng tuyển':
        return Colors.lightGreenAccent[700]; // Enable button with Green color
      case 'approved':
      case 'rejected':
      case 'cancelled':
        return Colors.lightGreenAccent[700]; // Disable button with grey color
      default:
        return Colors.grey;
    }
  }

// button left
  String _getRejectButtonText(String status) {
    switch (status) {
      case 'đã ứng tuyển':
        return 'Từ chối'; // Pending -> Allow reject
      case 'approved':
        return 'Đã nhận'; // Can't reject once approved
      case 'rejected':
        return 'Đã từ chối'; // Already rejected
      case 'cancelled':
        return 'Đã hủy'; // Application cancelled
      default:
        return 'Không xác định';
    }
  }

  Color _getRejectButtonColor(String status) {
    switch (status) {
      case 'đã ứng tuyển':
        return Colors.red; // Enable button with red color
      case 'approved':
      case 'rejected':
      case 'cancelled':
        return Colors.grey; // Disable button with grey color
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
                                        controller.base64.toString(),
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
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Flexible(
                                  child: Text(
                                    'Địa chỉ: ',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: Text(
                                    userData['address'],
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                const Text(
                                  'Điện thoại: ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: Text(
                                    userData['phone'].toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                const Text(
                                  'Email: ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: Text(
                                    userData['email'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
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
                            'NGHÀNH NGHỀ QUAN TÂM',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: Text(
                                    userData['career'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
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
                          const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'HỌC VẤN',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  userData['description'],
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color:
                                          Color.fromARGB(255, 158, 155, 145)),
                                  maxLines: 20,
                                  overflow: TextOverflow.ellipsis,
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
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'LỊCH SỬ ỨNG TUYỂN',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 6),
                                      child: Text(
                                        'Lịch sử',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
