import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobapp/server/database.dart';

import '../../../../auth/auth_controller.dart';

class InsertExperience extends StatefulWidget {
  const InsertExperience({super.key});

  @override
  State<InsertExperience> createState() => _InsertExperienceState();
}

class _InsertExperienceState extends State<InsertExperience> {
  final AuthController controller = Get.find<AuthController>();

  final _companyNameController = TextEditingController();
  final _positionController = TextEditingController();
  final _startController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _endController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  bool isLoading = false;

  Future<void> _handleInsertExperience() async {
    setState(() {
      isLoading = true;
    });
    int uid = controller.userModel.value.id!;
    String nameCompany = _companyNameController.text;
    String position = _positionController.text;
    DateTime timeFrom = DateTime.parse(_startController.text);
    DateTime timeTo = DateTime.parse(_endController.text);
    String description = _descriptionController.text;

    try {
      await Database().insertExperience(
          uid, nameCompany, position, timeFrom, timeTo, description);
      setState(() {
        isLoading = false;
      });
      Get.back(result: true);
    } catch (e) {
      print('Cập nhật học vấn lỗi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm kinh nghiệm'),
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
                    child: Text('Tên công ty'),
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
                    controller:
                        _companyNameController, // Sử dụng controller cho tên công ty
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Vị trí công việc'),
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
                    child: Text('Thời gian làm việc'),
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
                    child: Text('Mô tả chi tiết'),
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
              _handleInsertExperience();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Thêm thông tin',
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
