import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jobapp/server/database.dart';

import '../../../../auth/auth_controller.dart';

class UpdateExperience extends StatefulWidget {
  const UpdateExperience({super.key});

  @override
  State<UpdateExperience> createState() => _UpdateExperienceState();
}

class _UpdateExperienceState extends State<UpdateExperience> {
  final AuthController controller = Get.find<AuthController>();

  final _companyNameController = TextEditingController();
  final _positionController = TextEditingController();
  final _startController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _endController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  int expeId = 0;
  bool isLoading = false;
  Map<String, dynamic> _experience = {};

  @override
  void initState() {
    super.initState();

    _experience = Get.arguments;
    expeId = _experience['expe_id'];

    _companyNameController.text = _experience['nameCompany'];
    _positionController.text = _experience['position'];
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    _startDate = formatter.parse(_experience['time_from'].toString());
    _endDate = formatter.parse(_experience['time_to'].toString());
    _startController.text = formatter.format(_startDate!);
    _endController.text = formatter.format(_endDate!);
    _descriptionController.text = _experience['description'];
  }

  Future<void> _handleUpdateExperience() async {
    setState(() {
      isLoading = true;
    });
    String nameCompany = _companyNameController.text;
    String position = _positionController.text;
    final DateFormat formatter = DateFormat('yyyy-M-d');
    DateTime timeFrom = formatter.parse(_startController.text);
    DateTime timeTo = formatter.parse(_endController.text);
    String description = _descriptionController.text;

    try {
      await Database().updateExperience(
          expeId, nameCompany, position, timeFrom, timeTo, description);
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
              Database().deleteExperience(expeId);
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
        title: Text('Cập nhật kinh nghiệm'),
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
                      'Tên công ty',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Nhập tên công ty',
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
                    controller: _companyNameController,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Vị trí công việc',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Nhập vị trí công việc',
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
                        _positionController, // Sử dụng controller cho vị trí làm việc
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Thời gian làm việc',
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
                      hintText:
                          'Mô tả chi tiết những gì đạt được trong quá trình làm việc tại công ty',
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
                            _handleDelete(
                                context, 'Bạn có muốn xóa kinh nghiệm');
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
              _handleUpdateExperience();
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
