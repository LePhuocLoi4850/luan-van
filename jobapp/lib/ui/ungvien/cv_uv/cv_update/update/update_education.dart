import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jobapp/server/database.dart';

import '../../../../../models/career.dart';
import '../../../../auth/auth_controller.dart';

class UpdateEducation extends StatefulWidget {
  const UpdateEducation({super.key});

  @override
  State<UpdateEducation> createState() => _UpdateEducationState();
}

class _UpdateEducationState extends State<UpdateEducation> {
  final AuthController controller = Get.find<AuthController>();

  final _nameController = TextEditingController();
  final _levelController = TextEditingController();
  final _startController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _endController = TextEditingController();
  final _careerController = TextEditingController();
  final _searchController = TextEditingController();

  Career? selectedCareer;
  CareerManager careerManager = CareerManager();
  DateTime? _startDate;
  DateTime? _endDate;
  bool isLoading = false;
  Map<String, dynamic> _education = {};
  @override
  void initState() {
    super.initState();
    _education = Get.arguments;
    _nameController.text = _education['name'];
    _levelController.text = _education['level'];
    _careerController.text = _education['career'];

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    _startDate = formatter.parse(_education['time_from'].toString());
    _endDate = formatter.parse(_education['time_to'].toString());

    _startController.text = formatter.format(_startDate!);
    _endController.text = formatter.format(_endDate!);
    _descriptionController.text = _education['description'];
  }

  Future<void> _handleUpdateEducation() async {
    int eduId = _education['edu_id'];
    String level = _levelController.text;
    String name = _nameController.text;
    String career = _careerController.text;
    print(career);
    final DateFormat formatter = DateFormat('yyyy-M-d');
    DateTime timeFrom = formatter.parse(_startController.text);
    DateTime timeTo = formatter.parse(_endController.text);
    String description = _descriptionController.text;

    try {
      await Database().updateEducation(
          eduId, level, name, timeFrom, timeTo, description, career);

      Get.back(result: true);
    } catch (e) {
      print('Cập nhật học vấn lỗi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Học vấn'),
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
                    child: Text('Cấp bậc'),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showEducationBottomSheet(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _levelController.text.isEmpty ||
                                            _levelController.text ==
                                                'Không yêu cầu'
                                        ? 'Chọn cấp bậc'
                                        : _levelController.text,
                                    style: _levelController.text.isEmpty ||
                                            _levelController.text ==
                                                'Không yêu cầu'
                                        ? TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[500])
                                        : TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Tên trường học'),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Nhập tên trường học',
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
                    controller: _nameController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'hãy cho tôi biết email của bạn';
                      } else if (!value.contains('@')) {
                        return 'email không hợp lệ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Ngành nghề'),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showCareerBottomSheet(context, () {
                        setState(() {});
                      });
                    },
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _careerController.text.isNotEmpty
                                  ? _careerController.text
                                  : 'Loại Hình Công Việc',
                              style: TextStyle(
                                color: _careerController.text.isNotEmpty
                                    ? Colors.black
                                    : const Color.fromARGB(255, 69, 69, 69),
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Thời gian học tập'),
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
                          'Mô tả chi tiết những gì đạt được trong quá trình học tập',
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
              _handleUpdateEducation();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Cập nhật thông tin',
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

  void _showEducationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: 400,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Chọn trình độ học vấn',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    TextButton(onPressed: () {}, child: const Text('Xong'))
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: education.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(education[index]),
                      onTap: () {
                        setState(
                          () {
                            _levelController.text = education[index];
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCareerBottomSheet(
      BuildContext context, Function updateParentState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (ctx, setState) {
          List<Career> filteredCareers = careerManager.allCareer
              .where((career) => removeDiacritics(career.name.toLowerCase())
                  .contains(
                      removeDiacritics(_searchController.text.toLowerCase())))
              .toList();

          return FractionallySizedBox(
            heightFactor: 0.85,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Chọn ngành nghề',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search_rounded),
                      hintText: 'Tìm kiếm',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchController.text = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredCareers.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          child: ListTile(
                            title: Text(filteredCareers[index].name),
                            onTap: () {
                              selectedCareer = filteredCareers[index];
                              _careerController.text =
                                  filteredCareers[index].name;

                              updateParentState();

                              Navigator.of(context).pop();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  List<String> education = [
    'Không yêu cầu',
    'Chưa tốt nghiệp THPT',
    'Tốt nghiệp THPT',
    'Tốt nghiệp Trung cấp',
    'Tốt nghiệp Cao đẳng',
    'Tốt nghiệp Đại học',
    'Trên đại học',
  ];
}
