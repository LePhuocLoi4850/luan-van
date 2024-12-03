import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:jobapp/controller/calender_controller.dart';
import 'package:jobapp/models/calender.dart';
import 'package:jobapp/models/wards_data.dart';
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
  final _dayController = TextEditingController();
  final _noteController = TextEditingController();

  late TextEditingController _houseNumberStreetController;
  Map<String, dynamic> userData = {};
  Map<String, dynamic> data = {};
  Map<String, dynamic> contact = {};
  bool isLoadContact = false;
  TimeOfDay? time;
  late int uid;
  late int jid;
  late int cvId;
  late String age;
  late String nameCv;
  late String status;
  late String title;
  late String pdf;
  bool _isLoading = true;
  bool isSubmit = false;
  bool _isCheckedAccept = false;
  bool _isCheckedReject = false;
  int? _selectedCvIndex;
  String? _selectedCity;
  String? _selectedDistrict;
  String? _selectedWard;
  DateTime? _selectedDate;
  TimeOfDay? selectedTime;
  TimePickerEntryMode entryMode = TimePickerEntryMode.dial;
  Orientation? orientation;
  TextDirection textDirection = TextDirection.ltr;
  MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded;
  bool use24HourTime = false;
  final String service_id = "service_r199mx5";
  final String template_applied = "template_16wojjr";
  final String template_rejected = "template_n1narzo";
  final String user_id = "lJfz7eGLdrRrnAL79";
  String? nameCalender;
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
      _fetchCalender();
    } catch (e) {
      print('fetchUserData error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _fetchCalender() async {
    int cid = controller.companyModel.value.id!;

    try {
      final calenderData = await Database().fetchAllCalenderForCid(cid);

      calenderController.clearCldData();
      for (final calenderMap in calenderData) {
        final cld = Calender.fromMap(calenderMap);
        calenderController.addCld(cld);
      }
    } catch (e) {
      print('lỗi fetch calender: $e');
    }
  }

  void _resetBothStates() {
    setState(() {
      _isCheckedAccept = false;
      _isCheckedReject = false;
    });
  }

  TimeOfDay parseTimeOfDay(String timeString) {
    // Parse the input string and convert to TimeOfDay
    final format = RegExp(r'^(\d{1,2}):(\d{2})\s?(AM|PM)$');
    final match = format.firstMatch(timeString);

    if (match == null) {
      throw FormatException('Invalid time format: $timeString');
    }

    final hour = int.parse(match.group(1)!); // Get the hour
    final minute = int.parse(match.group(2)!); // Get the minutes
    final period = match.group(3)!; // Get AM/PM

    // Convert hour to 24-hour format if needed
    final adjustedHour = (period == 'PM' && hour != 12)
        ? hour + 12
        : (period == 'AM' && hour == 12)
            ? 0
            : hour;

    return TimeOfDay(hour: adjustedHour, minute: minute);
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
    print(nameCv);
    try {
      if (nameCv == 'CV Profile') {
        Get.toNamed('/cvProfileScreen', arguments: uid);
      } else {
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
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _sendEmailUserApplied() async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    String address =
        '${_houseNumberStreetController.text}, $_selectedWard, $_selectedDistrict, $_selectedCity';
    String time = selectedTime!.format(context);
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
              'address': address,
              'time': time,
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

  Future<bool> _onSubmit() async {
    if (_dayController.text.isEmpty || selectedTime == null) {
      _showErrorMessage('Vui lòng chọn ngày và giờ trước khi gửi.');
      return false; // Trả về false nếu không hợp lệ
    }
    if (_selectedCity == null) {
      _showErrorMessage('Vui lòng chọn Tỉnh/Thành phố');
      return false;
    }
    if (_selectedDistrict == null) {
      _showErrorMessage('Vui lòng chọn Quận/Huyện');
      return false;
    }
    if (_selectedWard == null) {
      _showErrorMessage('Vui lòng chọn Xã/Phường');
      return false;
    }
    if (_houseNumberStreetController.text.isEmpty) {
      _showErrorMessage('Vui lòng nhập số nhà và tên đường');
      return false;
    }

    // Nếu tất cả hợp lệ
    return true;
  }

  void _showErrorMessage(String message) {
    Get.snackbar('Lỗi', message,
        backgroundColor: Colors.red, colorText: Colors.white);
    return;
  }

  void _handleSubmitRight() async {
    setState(() {
      isSubmit = true;
    });

    String nameC = controller.companyModel.value.name!;
    String evaluate = _isCheckedAccept ? 'Phù hợp' : 'Không phù hợp';
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

  void _handleSubmit() async {
    String nameC = controller.companyModel.value.name!;
    String evaluate = _isCheckedAccept ? 'Phù hợp' : 'Không phù hợp';
    String comment = _commentController.text;
    try {
      switch (status) {
        case 'applied':
          String reason = 'bị từ chối';
          await Database().updateApplicantStatus(
              jid, uid, 'rejected', nameC, evaluate, comment, reason);
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dayController.text =
            "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
      });
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                  color:
                                      const Color.fromARGB(255, 255, 226, 230),
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
                            (status == 'approved' || status == 'rejected')
                                ? SizedBox(
                                    width: 20,
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 130,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
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
                                                            color:
                                                                Colors.white),
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
                                                          MainAxisAlignment
                                                              .start,
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
                                                          width: 180,
                                                          height: 50,
                                                          decoration:
                                                              BoxDecoration(
                                                                  border:
                                                                      BorderDirectional(
                                                            bottom: BorderSide(
                                                                color: Colors
                                                                    .black),
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
                                                                        .yellow[
                                                                    700],
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
                      onPressed: _isCheckedAccept
                          ? null
                          : () async {
                              if (!_isCheckedAccept && !_isCheckedReject) {
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
                      onPressed: _isCheckedReject
                          ? null
                          : () async {
                              if (!_isCheckedAccept && !_isCheckedReject) {
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
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return AlertDialog(
                                      insetPadding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          24, 20, 24, 0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      title: const Text('Lên lịch phỏng vấn'),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: _selectedCvIndex == null
                                                  ? SizedBox.shrink()
                                                  : Row(
                                                      children: [
                                                        Text(
                                                          'Tên mẫu:',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(nameCalender!)
                                                      ],
                                                    ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.all(5.0),
                                                      child: Text(
                                                        'Ngày',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 130,
                                                      child: TextFormField(
                                                        readOnly: true,
                                                        onTap: () =>
                                                            _selectDate(
                                                                context),
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              '0000-00-00',
                                                          hintStyle: TextStyle(
                                                              fontSize: 18),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                        controller:
                                                            _dayController,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.all(5.0),
                                                      child: Text(
                                                        'Giờ',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.white,
                                                        elevation: 0,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          side: BorderSide(
                                                              color:
                                                                  Colors.grey),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        minimumSize:
                                                            const Size(100, 58),
                                                        padding:
                                                            EdgeInsets.all(10),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Center(
                                                            child:
                                                                selectedTime !=
                                                                        null
                                                                    ? Text(
                                                                        selectedTime!
                                                                            .format(context),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                      )
                                                                    : Text(
                                                                        '00:00 PM',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            color:
                                                                                Colors.black54),
                                                                      ),
                                                          ),
                                                        ],
                                                      ),
                                                      onPressed: () async {
                                                        time =
                                                            await showTimePicker(
                                                          context: context,
                                                          initialTime:
                                                              selectedTime ??
                                                                  TimeOfDay
                                                                      .now(),
                                                          initialEntryMode:
                                                              entryMode,
                                                          orientation:
                                                              orientation,
                                                          builder: (BuildContext
                                                                  context,
                                                              Widget? child) {
                                                            return Theme(
                                                              data: Theme.of(
                                                                      context)
                                                                  .copyWith(
                                                                materialTapTargetSize:
                                                                    tapTargetSize,
                                                              ),
                                                              child:
                                                                  Directionality(
                                                                textDirection:
                                                                    textDirection,
                                                                child:
                                                                    MediaQuery(
                                                                  data: MediaQuery.of(
                                                                          context)
                                                                      .copyWith(
                                                                    alwaysUse24HourFormat:
                                                                        use24HourTime,
                                                                  ),
                                                                  child: child!,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                        setState(() {
                                                          selectedTime = time;
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                )
                                              ],
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Text(
                                                'Địa điểm',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                DropdownButtonFormField<String>(
                                                  decoration: InputDecoration(
                                                    prefixIcon: Icon(
                                                      Icons
                                                          .location_on_outlined,
                                                      color: Colors.grey[800],
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                  hint: const Text(
                                                      'Chọn Tỉnh/Thành phố'),
                                                  value: _selectedCity,
                                                  items: wardsData.keys
                                                      .map((String city) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: city,
                                                      child: Text(city),
                                                    );
                                                  }).toList(),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      _selectedCity = newValue;
                                                      _selectedDistrict = null;
                                                      _selectedWard = null;
                                                    });
                                                  },
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Vui lòng chọn Tỉnh/Thành phố';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                if (_selectedCity != null)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20.0,
                                                            top: 20),
                                                    child:
                                                        DropdownButtonFormField<
                                                            String>(
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                      hint: const Text(
                                                          'Chọn Quận/Huyện'),
                                                      value: _selectedDistrict,
                                                      items: wardsData[
                                                              _selectedCity]!
                                                          .entries
                                                          .map((MapEntry<String,
                                                                  List<String>>
                                                              entry) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: entry.key,
                                                          child:
                                                              Text(entry.key),
                                                        );
                                                      }).toList(),
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          _selectedDistrict =
                                                              newValue;
                                                          _selectedWard = null;
                                                        });
                                                      },
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Vui lòng chọn Quận/Huyện';
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                if (_selectedDistrict != null)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20.0,
                                                            top: 20),
                                                    child:
                                                        DropdownButtonFormField<
                                                            String>(
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                      hint: const Text(
                                                          'Chọn Phường/Xã'),
                                                      value: _selectedWard,
                                                      items: wardsData[
                                                                  _selectedCity]![
                                                              _selectedDistrict]!
                                                          .map((String ward) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: ward,
                                                          child: Text(ward),
                                                        );
                                                      }).toList(),
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          _selectedWard =
                                                              newValue;
                                                        });
                                                      },
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Vui lòng chọn Xã/Phường';
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                if (_selectedWard != null)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20.0,
                                                            top: 20),
                                                    child: TextFormField(
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            'Nhập số nhà và tên đường',
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                      controller:
                                                          _houseNumberStreetController,
                                                      onChanged: (value) {
                                                        setState(() {});
                                                      },
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Vui lòng nhập số nhà và tên đường';
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Text(
                                                'Ghi chú',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            TextFormField(
                                              decoration: InputDecoration(
                                                hintText: 'Ghi chú',
                                                hintStyle: TextStyle(
                                                  color: Colors.grey[600],
                                                ),
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior.never,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey,
                                                      width: 2),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white,
                                              ),
                                              controller: _noteController,
                                              maxLines: 3,
                                              maxLength: 255,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: TextButton(
                                                onPressed: () {
                                                  _showCalenderBottomSheet(
                                                      context, (int? index,
                                                          String? name,
                                                          String? day,
                                                          String? hours,
                                                          String? location,
                                                          String note) {
                                                    setState(() {
                                                      _houseNumberStreetController =
                                                          TextEditingController(
                                                        text: (location ?? '')
                                                            .split(",")[0],
                                                      );
                                                      _selectedCvIndex = index;
                                                      nameCalender = name;
                                                      _dayController.text =
                                                          day!;
                                                      _noteController.text =
                                                          note;
                                                      selectedTime =
                                                          parseTimeOfDay(
                                                              hours!);
                                                      List<String> parts =
                                                          location?.split(
                                                                  ", ") ??
                                                              [];
                                                      for (var part in parts) {
                                                        if (part.contains(
                                                            "Phường")) {
                                                          _selectedWard = part;
                                                        } else if (part
                                                            .contains("Xã")) {
                                                          _selectedWard = part;
                                                        } else if (part
                                                            .contains("Thị")) {
                                                          _selectedWard = part;
                                                        } else if (part
                                                            .contains("Quận")) {
                                                          _selectedDistrict =
                                                              part;
                                                        } else if (part
                                                            .contains(
                                                                "Huyện")) {
                                                          _selectedDistrict =
                                                              part;
                                                        } else {
                                                          _selectedCity = part;
                                                        }
                                                      }
                                                    });
                                                  });
                                                },
                                                child:
                                                    Text('Mẫu lịch phỏng vấn'),
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
                                          onPressed: () async {
                                            bool isValid = await _onSubmit();
                                            if (isValid) {
                                              Navigator.of(context)
                                                  .pop(); // Đóng dialog
                                              _handleSubmitRight(); // Gọi hàm xử lý tiếp theo
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  });
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

  void resetDialogState() {
    setState(() {
      _selectedCity = null;
      _selectedDistrict = null;
      _selectedWard = null;
      _houseNumberStreetController.clear();
    });
  }

  void _showCalenderBottomSheet(BuildContext context,
      Function(int?, String?, String?, String?, String?, String) onSelected) {
    String? extractBeforeM(String input) {
      final regex = RegExp(r'.*?M');
      final match = regex.firstMatch(input);
      return match?.group(0);
    }

    String? extractAfterM(String input) {
      final regex = RegExp(r'(?<=M\s).*');
      final match = regex.firstMatch(input);
      return match?.group(0);
    }

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
                                                  '/calenderScreen');
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
                                        Checkbox(
                                          value: _selectedCvIndex == index,
                                          onChanged: (value) {
                                            if (value == true) {
                                              final g = extractBeforeM(cv.time);
                                              final d = extractAfterM(cv.time);
                                              final a = cv.address;
                                              String n = cv.note!;
                                              onSelected(
                                                  index, cv.name, d, g, a, n);
                                            } else {
                                              resetDialogState(); // Reset trạng thái khi bỏ chọn
                                              onSelected(
                                                  null,
                                                  null,
                                                  '0000-00-00',
                                                  '00:00 PM',
                                                  null,
                                                  '');
                                            }
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
                                            ],
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Map<String, dynamic> data = {
                                              'cld_id': cv.cldId,
                                              'cid': cv.cid,
                                              'name': cv.name,
                                              'time': cv.time,
                                              'address': cv.address,
                                              'createAt': cv.createAt,
                                              'note': cv.note,
                                            };
                                            final result = await Get.toNamed(
                                                '/calenderDetail',
                                                arguments: data);
                                            if (result == true) {
                                              setState(() {});
                                            }
                                          },
                                          child: Text('Xem'),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                      if (calenderController.calenderData.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final result =
                                    await Get.toNamed('/calenderScreen');
                                if (result == true) {
                                  setState(() {});
                                }
                              },
                              icon: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              label: Text(
                                'Thêm lịch phỏng vấn mới',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
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
