import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jobapp/server/database.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class UvDetailAdmin extends StatefulWidget {
  const UvDetailAdmin({super.key});

  @override
  State<UvDetailAdmin> createState() => _UvDetailAdminState();
}

class _UvDetailAdminState extends State<UvDetailAdmin> {
  bool isLoading = false;
  Map<String, dynamic> data = {};
  Map<String, dynamic> userData = {};
  int? uid;
  int? jid;
  String? image;
  final _commentController = TextEditingController();
  final addressController = TextEditingController();
  final timeController = TextEditingController();

  Map<String, dynamic> contact = {};
  bool isLoadContact = true;
  TimeOfDay? time;

  late int cvId;
  late String age;
  late String title;
  late String name;
  late String pdf;
  bool isSubmit = false;
  bool _isCheckedAccept = false;
  bool _isCheckedReject = false;

  TimeOfDay? selectedTime;
  TimePickerEntryMode entryMode = TimePickerEntryMode.dial;
  Orientation? orientation;

  MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded;
  bool use24HourTime = false;
  String? nameCalender;
  @override
  void initState() {
    super.initState();
    data = Get.arguments;
    uid = data['uid'];
    jid = data['jid'];
    title = data['title'];
    image = data['image'];
    name = data['name'];
    print('$uid, $jid');
    fetchFile();
  }

  int calculateAge(String birthDateString) {
    DateTime birthDate = DateFormat('yyyy-MM-dd').parse(birthDateString);

    DateTime currentDate = DateTime.now();

    int age = currentDate.year - birthDate.year;

    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Future<void> fetchPdf() async {
    print(userData['namecv']);
    try {
      if (userData['namecv'] == 'CV Profile') {
        Get.toNamed('/cvProfileScreen', arguments: uid);
      } else {
        pdf = await Database().fetchPdfForCvId(userData['cv_id']);
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
      }
    } catch (e) {
      print(e);
    }
  }

  void fetchFile() async {
    setState(() {
      isLoading = true;
    });
    try {
      userData = await Database().fetchApplyJidUid(jid!, uid!);
      if (userData['status'] == 'rejected') {
        _isCheckedReject = true;
        _commentController.text = userData['comment'];
      } else if (userData['status'] == 'approved') {
        _isCheckedAccept = true;
        _commentController.text = userData['comment'];
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _resetBothStates() {
    setState(() {
      _isCheckedAccept = false;
      _isCheckedReject = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
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
                                            image!,
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
                                              name,
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
                                                  'Tuổi:12',
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
                                                userData['email'],
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
                                                userData['phone'],
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
                                        onPressed: () {},
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
                                              fontSize: 18),
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
                                    userData['namecv'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await fetchPdf();
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
                          (userData['status'] == 'approved' ||
                                  userData['status'] == 'rejected')
                              ? Column(
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
                                                width: 130,
                                                decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 64, 205, 68),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Row(
                                                  children: [
                                                    Checkbox(
                                                      value: _isCheckedAccept,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _isCheckedAccept =
                                                              value!;
                                                          if (value)
                                                            _isCheckedReject =
                                                                false;
                                                          if (!_isCheckedAccept &&
                                                              !_isCheckedReject) {
                                                            _resetBothStates();
                                                          }
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
                                                      value: _isCheckedReject,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _isCheckedReject =
                                                              value!;
                                                          if (value)
                                                            _isCheckedAccept =
                                                                false;
                                                          if (!_isCheckedAccept &&
                                                              !_isCheckedReject) {
                                                            _resetBothStates();
                                                          }
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
                                          if (_isCheckedAccept ||
                                              _isCheckedReject)
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
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                          width: 130,
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
                                                        width: 218,
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
                                                            _isCheckedAccept
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
                                                      maxLines: 4,
                                                      maxLength: 255,
                                                      autofocus: false,
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
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox(
                                  width: 20,
                                )
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

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
}
