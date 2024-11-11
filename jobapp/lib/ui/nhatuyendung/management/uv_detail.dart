import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:jobapp/controller/calender_controller.dart';
import 'package:jobapp/server/database.dart';
import 'package:jobapp/ui/auth/auth_controller.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class UvDetail extends StatefulWidget {
  const UvDetail({super.key});

  @override
  State<UvDetail> createState() => _UvDetailState();
}

class _UvDetailState extends State<UvDetail> {
  AuthController controller = Get.find<AuthController>();
  CalenderController calenderController = Get.find<CalenderController>();
  final _commentController = TextEditingController();
  final addressController = TextEditingController();
  final timeController = TextEditingController();
  Map<String, dynamic> userData = {};
  Map<String, dynamic> data = {};
  Map<String, dynamic> contact = {};
  bool isLoadContact = false;
  late int uid;
  late int jid;
  late int cvId;
  late String age;
  late String nameCv;
  late String status;
  late String title;
  late String pdf;
  bool _isLoading = true;
  bool _isChecked1 = false;
  bool _isChecked2 = false;
  bool isSubmit = false;
  int? _selectedCvIndex;
  final String service_id = "service_r199mx5";
  final String template_applied = "template_16wojjr";
  final String template_rejected = "template_n1narzo";
  final String user_id = "lJfz7eGLdrRrnAL79";

  @override
  void initState() {
    super.initState();
    data = Get.arguments;
    uid = data['uid'];
    jid = data['jid'];
    cvId = data['cv_id'];
    nameCv = data['nameCv'];
    status = data['status'];
    title = data['title'];
    age = data['age'];

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

  Future<void> fetchContact() async {
    setState(() {
      isLoadContact = false;
    });
    try {
      contact = await Database().fetchUserDataForUid(uid);
      setState(() {
        isLoadContact = true;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchPdf() async {
    try {
      pdf = await Database().fetchPdfForCvId(cvId);
      if (pdf.isEmpty) {
        return;
      } else {
        Get.to(
          () => Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
            body: SfPdfViewer.memory(
              base64Decode(pdf),
            ),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _sendEmailUserApplied() async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'service_id': service_id,
            'template_id': template_applied,
            'user_id': user_id,
            'template_params': {
              'company_name': controller.companyModel.value.name,
              'user_name': userData['name'],
              'user_email': userData['email'],
              'address': addressController.text,
              'time': timeController.text
            },
          }));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('gửi cho ứng viên thành công')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $error')),
      );
    }
  }

  Future<void> _sendEmailUserRejected() async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'service_id': service_id,
            'template_id': template_applied,
            'user_id': user_id,
            'template_params': {
              'company_name': controller.companyModel.value.name,
              'user_name': userData['name'],
              'user_email': userData['email'],
              'address': addressController.text,
              'time': timeController.text
            },
          }));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('gửi cho ứng viên thành công')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $error')),
      );
    }
  }

  void _handleSubmitRight() async {
    setState(() {
      isSubmit = true;
    });
    String nameC = controller.companyModel.value.name!;
    String evaluate = _isChecked1 ? 'Phù hợp' : 'Không phù hợp';
    String comment = _commentController.text;
    try {
      switch (status) {
        case 'applied':
          String reason = 'đã chấp nhận';
          await Database().updateApplicantStatus(
              jid, uid, 'approved', nameC, evaluate, comment, reason);

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
      await _sendEmailUserApplied();
      setState(() {
        isSubmit = false;
      });

      Get.back(result: 'accepted');
    } catch (e) {
      print(e);
    }
  }

  // void _handleSubmit() async {
  //   String nameC = controller.companyModel.value.name!;
  //   String evaluate = _isChecked1 ? 'Phù hợp' : 'Không phù hợp';
  //   String comment = _commentController.text;
  //   try {
  //     switch (status) {
  //       case 'applied':
  //         String reason = 'bị từ chối';
  //         await Database().updateApplicantStatus(
  //             jid, uid, 'rejected', nameC, evaluate, comment, reason);
  //         break;
  //       case 'approved':
  //       case 'rejected':
  //       case 'cancelled':
  //         Get.snackbar(
  //             'Thông báo', 'Tính năng đang trong quá trình phát triển');
  //         break;
  //       default:
  //         Get.snackbar('Lỗi', 'Trạng thái không xác định');
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

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
        title: Text(title),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                                  'Tuổi: $age',
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  child: Text(
                                                    'Giới tính: ${userData['gender']}',
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.black),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                              isLoadContact
                                  ? Container(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Icon(
                                                  Icons.email,
                                                  size: 30,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              Text(
                                                contact['email'],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Icon(
                                                  Icons.phone,
                                                  size: 30,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              Text(
                                                contact['phone'],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 15),
                                child: isLoadContact
                                    ? null
                                    : ElevatedButton(
                                        onPressed: () {
                                          fetchContact();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blueAccent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                    fetchPdf();
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
                          (status == 'approved' || status == 'rejected')
                              ? SizedBox(
                                  width: 20,
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                              'Thực hiện đánh giá để tối ưu chiến dịch tuyển dụng của bạn',
                                              style: TextStyle(fontSize: 16)),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                height: 50,
                                                width: 170,
                                                decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 64, 205, 68),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
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
                                                          fontSize: 16,
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 50,
                                                width: 170,
                                                decoration: BoxDecoration(
                                                    color: Colors.red[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
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
                                                          fontSize: 16,
                                                          color: Colors.red),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          if (_isChecked1 || _isChecked2)
                                            Container(
                                              width: 350,
                                              height: 225,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black)),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                          width: 150,
                                                          height: 50,
                                                          decoration: BoxDecoration(
                                                              border: BorderDirectional(
                                                                  bottom: BorderSide(
                                                                      color: Colors
                                                                          .black),
                                                                  end: BorderSide(
                                                                      color: Colors
                                                                          .black))),
                                                          child: Center(
                                                              child: Text(
                                                            'Trạng thái',
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .grey[600],
                                                            ),
                                                          ))),
                                                      Container(
                                                        width: 197,
                                                        height: 50,
                                                        decoration:
                                                            BoxDecoration(
                                                                border:
                                                                    BorderDirectional(
                                                          bottom: BorderSide(
                                                              color:
                                                                  Colors.black),
                                                        )),
                                                        child: Center(
                                                          child: Text(
                                                            _isChecked1
                                                                ? 'Phù hợp'
                                                                : 'Không phù hợp',
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .yellow[700],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextField(
                                                      controller:
                                                          _commentController,
                                                      maxLines: 5,
                                                      maxLength: 255,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText:
                                                            'Nhập nhận xét...',
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
          ),
          if (isSubmit)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
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
                        // _handleSubmit();
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
                        if (!_isChecked1 && !_isChecked2) {
                          Get.snackbar('Lỗi', 'Vui lòng chọn đánh giá!',
                              backgroundColor: Colors.red,
                              colorText: Colors.white);
                          return;
                        }

                        String comment = _commentController.text;

                        if (comment.isEmpty) {
                          Get.snackbar('Lỗi', 'Vui lòng nhập nhận xét!',
                              backgroundColor: Colors.red,
                              colorText: Colors.white);
                          return;
                        }
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              insetPadding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(24, 20, 24, 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              title: const Text('Lên lịch phỏng vấn'),
                              content: SizedBox(
                                width: 400,
                                height: 300,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    TextField(
                                      controller: addressController,
                                      maxLines: 2,
                                      maxLength: 255,
                                      decoration: const InputDecoration(
                                        hintText: 'Địa điểm phỏng vấn',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    TextField(
                                      controller: timeController,
                                      maxLines: 1,
                                      maxLength: 255,
                                      decoration: const InputDecoration(
                                        hintText: 'Thời gian phỏng vấn',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: TextButton(
                                        onPressed: () {
                                          _showCvBottomSheet(context);
                                        },
                                        child: Text('Mẫu lịch phỏng vấn'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Hủy'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Gửi'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _handleSubmitRight();
                                  },
                                ),
                              ],
                            );
                          },
                        );
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

  void _showCvBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[200],
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return FractionallySizedBox(
            heightFactor: 0.6,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'Danh sách mẫu lịch phỏng vấn',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      calenderController.calenderData.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 20),
                              child: Container(
                                height: 120,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.grey),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Text(
                                          'Bạn chưa có mẫu lịch phỏng vấn',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 300,
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              final result = await Get.toNamed(
                                                  '/uploadCV');
                                              if (result == true) {
                                                setState(() {});
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.add,
                                                  color: Color.fromARGB(
                                                      136, 0, 0, 0),
                                                ),
                                                Text(
                                                  'Thêm mẫu lịch phỏng vấn',
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
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: calenderController.calenderData.length,
                              itemBuilder: (context, index) {
                                final cv =
                                    calenderController.calenderData[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5),
                                  child: Container(
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Radio<int>(
                                          value: index,
                                          groupValue: _selectedCvIndex,
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedCvIndex = value;
                                            });
                                            this.setState(() {
                                              _selectedCvIndex = value;
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(cv.name),
                                              Text(
                                                'Cập nhật lần cuối: ${DateTime.parse(cv.time.toString()).year}/${DateTime.parse(cv.time.toString()).month}/${DateTime.parse(cv.time.toString()).day}',
                                              ),
                                            ],
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {},
                                          child: Text('Xem'),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ],
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
// _handleSubmitRight();
// Get.back(result: 'accepted');
