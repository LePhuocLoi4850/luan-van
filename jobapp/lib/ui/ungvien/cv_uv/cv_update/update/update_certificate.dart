import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jobapp/server/database.dart';

import '../../../../auth/auth_controller.dart';

class UpdateCertificate extends StatefulWidget {
  const UpdateCertificate({super.key});

  @override
  State<UpdateCertificate> createState() => _UpdateCertificateState();
}

class _UpdateCertificateState extends State<UpdateCertificate> {
  final AuthController controller = Get.find<AuthController>();

  final _certificateNameController = TextEditingController();
  final _nameHostController = TextEditingController();
  final _startController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _endController = TextEditingController();
  int certId = 0;
  DateTime? _startDate;
  DateTime? _endDate;
  bool isLoading = false;
  Map<String, dynamic> _certificate = {};

  @override
  void initState() {
    super.initState();
    _certificate = Get.arguments;
    certId = _certificate['cerTi_id'];
    _certificateNameController.text = _certificate['nameCertificate'];
    _nameHostController.text = _certificate['nameHost'];
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    _startDate = formatter.parse(_certificate['time_from'].toString());
    _endDate = formatter.parse(_certificate['time_to'].toString());
    _startController.text = formatter.format(_startDate!);
    _endController.text = formatter.format(_endDate!);
    _descriptionController.text = _certificate['description'];
  }

  Future<void> _handleUpdateCertificate() async {
    setState(() {
      isLoading = true;
    });
    String nameCertificate = _certificateNameController.text;
    String nameHost = _nameHostController.text;
    final DateFormat formatter = DateFormat('yyyy-M-d');
    DateTime timeFrom = formatter.parse(_startController.text);
    DateTime timeTo = formatter.parse(_endController.text);
    String description = _descriptionController.text;

    try {
      await Database().updateCertificate(
          certId, nameCertificate, nameHost, timeFrom, timeTo, description);
      setState(() {
        isLoading = false;
      });
      Get.back(result: true);
    } catch (e) {
      print('Cập nhật học vấn lỗi: $e');
    }
  }

  void _handleDelete(BuildContext context, String message) async {
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
              Database().deleteCertificate(certId);
              Navigator.of(ctx).pop(false);
              Get.back(result: true);
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
      appBar: AppBar(
        title: Text('Cập nhật chứng chỉ'),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Tên chứng chỉ',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Nhập tên chứng chỉ',
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    controller:
                        _certificateNameController, // Sử dụng controller cho tên công ty
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Tên tổ chức',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Nhập tên tổ chức',
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    controller: _nameHostController,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Thời gian',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 180,
                        child: TextFormField(
                          readOnly: true,
                          onTap: () => _selectStartDate(context),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.date_range_outlined,
                              color: Colors.grey[800],
                            ),
                            hintText: 'Bắt đầu',
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey[800],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          controller: _startController,
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: TextFormField(
                          readOnly: true,
                          onTap: () => _selectEndDate(context),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.date_range_outlined,
                              color: Colors.grey[800],
                            ),
                            hintText: 'Kết thúc',
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey[800],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          controller: _endController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Mô tả chi tiết',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Mô tả chi tiết chứng chỉ',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    maxLines: 6,
                    controller: _descriptionController,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            _handleDelete(context, 'Bạn có muốn xóa chứng chỉ');
                          },
                          child: Text(
                            'Xóa kinh nghiệm',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
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
      bottomNavigationBar: Container(
        height: 80,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ElevatedButton(
            onPressed: () {
              _handleUpdateCertificate();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Cập nhật',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _startDate) {
      setState(() {
        _startDate = pickedDate;
        _startController.text =
            "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _endDate) {
      setState(() {
        _endDate = pickedDate;
        _endController.text =
            "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
      });
    }
  }
}
