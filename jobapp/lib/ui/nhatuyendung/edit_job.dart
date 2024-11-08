import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jobapp/ui/auth/auth_controller.dart';

import '../../models/career.dart';
import '../../server/database.dart';

class EditJob extends StatefulWidget {
  const EditJob({super.key});

  @override
  State<EditJob> createState() => _EditJobState();
}

class _EditJobState extends State<EditJob> {
  AuthController controller = Get.find<AuthController>();
  final _titleController = TextEditingController();
  final _loaiController = TextEditingController();
  final _soluongController = TextEditingController();
  final _gioitinhController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _requestController = TextEditingController();
  final _interestController = TextEditingController();
  final _expirationDateController = TextEditingController();
  final _careerController = TextEditingController();
  final _searchController = TextEditingController();

  final fromController = TextEditingController();
  final toController = TextEditingController();

  final _editForm = GlobalKey<FormState>();

  CareerManager careerManager = CareerManager();
  Career? selectedCareer;
  DateTime? _selectedDate;
  String? _experience;
  int? jId;
  bool isLoading = true;
  Map<String, dynamic> job = {};
  final Map<String, String> _scale = {
    'Không yêu cầu': 'Không yêu cầu',
    'Sắp đi làm': 'Sắp đi làm',
    'Dưới 1 năm': 'Dưới 1 năm',
    '1 năm': '1 năm',
    '2 năm': '2 năm',
    '3 năm': '3 năm',
    '5 năm': '5 năm',
    'Trên 5 năm': 'Trên 5 năm',
  };
  String? selectedDay1;
  String? selectedDay2;
  String? selectedHour1;
  String? selectedHour2;
  final List<String> daysOfWeek = [
    'Thứ 2',
    'Thứ 3',
    'Thứ 4',
    'Thứ 5',
    'Thứ 6',
    'Thứ 7'
  ];
  final List<String> hourFrom = [
    '07:00',
    '08:00',
    '09:00',
    '10:00',
  ];
  final List<String> hourTo = [
    '17:00',
    '18:00',
    '19:00',
    '20:00',
  ];
  @override
  void initState() {
    super.initState();
    jId = Get.arguments;
    fetchJob();
  }

  Future<void> fetchJob() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      job = await Database().fetchJobForJid(jId!);
      print(job);
      _titleController.text = job['title'];
      _careerController.text = job['career'];
      _loaiController.text = job['type'];
      _soluongController.text = job['quantity'].toString();
      _gioitinhController.text = job['gender'];
      fromController.text = job['salary_from'].toString();
      toController.text = job['salary_to'].toString();
      _experience = job['experience'];
      String data = job['workingTime'];
      selectedDay1 = data.substring(0, 5);
      selectedDay2 = data.substring(8, 13);
      selectedHour1 = data.substring(18, 23);
      selectedHour2 = data.substring(28, 33);
      _descriptionController.text = job['description'];
      _requestController.text = job['request'];
      _interestController.text = job['interest'];
      _expirationDateController.text = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(job['expirationDate'].toString()));

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _handlePost() async {
    final isValid = _editForm.currentState!.validate();
    if (!isValid) {
      return;
    }
    _editForm.currentState!.save();

    final title = _titleController.text;
    final career = _careerController.text;
    final type = _loaiController.text;
    int quantity = int.parse(_soluongController.text);
    final gender = _gioitinhController.text;
    String salaryFrom = fromController.text;
    String salaryTo = toController.text;
    String? experience = _experience;
    String workingTime =
        '$selectedDay1 - $selectedDay2 (từ $selectedHour1 đến $selectedHour2)';
    final description = _descriptionController.text;
    final request = _requestController.text;
    final interest = _interestController.text;
    DateFormat format = DateFormat('yyyy-MM-dd');
    DateTime expirationDate = format.parse(_expirationDateController.text);
    try {
      await Database().updateJob(
        jId!,
        title,
        career,
        type,
        quantity,
        gender,
        salaryFrom,
        salaryTo,
        experience!,
        workingTime,
        description,
        request,
        interest,
        expirationDate,
      );
      Map<String, dynamic> data = {
        'title': title,
        'career': career,
      };
      print('update job nice');
      Get.back(result: data);
    } catch (e) {
      print('update job error: $e');
      return;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _expirationDateController.text =
            "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
      });
    }
  }

  void _showCareerBottomSheet(BuildContext context) {
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
                      prefixIcon: const Icon(Icons.search_rounded),
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
                              setState(() {
                                selectedCareer = filteredCareers[index];
                                _careerController.text =
                                    filteredCareers[index].name;
                              });
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

  void _showSalaryBottomSheet(
      BuildContext context, TextEditingController controller) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chọn Mức Lương',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 30,
                  itemBuilder: (context, index) {
                    final salary = (index + 1).toString();
                    return ListTile(
                      title: Text(salary),
                      onTap: () {
                        controller.text = salary;
                        Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text(
            'Cập nhật tin đăng',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _editForm,
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: RichText(
                          text: const TextSpan(
                            text: 'Tiêu đề tin tuyển dụng',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '(*)',
                                  style: TextStyle(color: Colors.red))
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 10),
                        child: buildTitleField(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: RichText(
                          text: const TextSpan(
                            text: 'Ngành nghề đăng tuyển',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '(*)',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 10),
                        child: buildCareerField(),
                      ),
                      // Loại hình công việc
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: RichText(
                          text: const TextSpan(
                            text: 'Loại hình công việc',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '(*)',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 10),
                        child: buildLoaiField(),
                      ),
                      // Số lượng cần tuyển
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: RichText(
                          text: const TextSpan(
                            text: 'Số lượng cần tuyển',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '(*)',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 10),
                        child: buildSoLuongField(),
                      ),

                      // Giới tính
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: RichText(
                          text: const TextSpan(
                            text: 'Giới tính yêu cầu',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '(*)',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'Nam',
                                  groupValue: _gioitinhController.text,
                                  onChanged: (value) {
                                    setState(() {
                                      _gioitinhController.text = value!;
                                    });
                                  },
                                ),
                                const Text(
                                  'Nam',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'Nữ',
                                  groupValue: _gioitinhController.text,
                                  onChanged: (value) {
                                    setState(() {
                                      _gioitinhController.text = value!;
                                    });
                                  },
                                ),
                                const Text(
                                  'Nữ',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'Không yêu cầu',
                                  groupValue: _gioitinhController.text,
                                  onChanged: (value) {
                                    setState(() {
                                      _gioitinhController.text = value!;
                                    });
                                  },
                                ),
                                const Text(
                                  'Không yêu cầu',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: RichText(
                          text: const TextSpan(
                            text: 'Mức lương',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '(*)',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 50,
                              child: TextField(
                                  controller: fromController,
                                  keyboardType: TextInputType.none,
                                  decoration: InputDecoration(
                                    hintText: 'Từ',
                                    hintStyle: const TextStyle(fontSize: 18),
                                    border: const OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                          color: Colors.black,
                                          width:
                                              1), // Red border when not focused
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                          color: Colors.black,
                                          width:
                                              1), // Red border when not focused
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                  readOnly: true,
                                  onTap: () => _showSalaryBottomSheet(
                                      context, fromController)),
                            ),
                            const Text(
                              '-',
                              style: TextStyle(fontSize: 30),
                            ),
                            SizedBox(
                              width: 100,
                              height: 50,
                              child: TextField(
                                controller: toController,
                                keyboardType: TextInputType.none,
                                decoration: InputDecoration(
                                  hintText: 'Đến',
                                  hintStyle: const TextStyle(fontSize: 18),
                                  border: const OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                        color: Colors.black,
                                        width:
                                            1), // Red border when not focused
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                        color: Colors.black,
                                        width:
                                            1), // Red border when not focused
                                  ),
                                ),
                                textAlign: TextAlign.center,
                                readOnly: true,
                                onTap: () => _showSalaryBottomSheet(
                                    context, toController),
                              ),
                            ),
                            const Text(
                              'Triệu / Tháng',
                              style: TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: RichText(
                          text: const TextSpan(
                            text: 'Kinh Nghiệm',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '(*)',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 10),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          hint: const Text('Kinh nghiệm yêu cầu'),
                          value: _experience,
                          items: _scale.keys.map((String scale) {
                            return DropdownMenuItem<String>(
                              value: scale,
                              child: Text(scale),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _experience = newValue;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: RichText(
                          text: const TextSpan(
                            text: 'Thời gian làm việc',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '(*)',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text(
                                  'Từ ',
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                  width: 75,
                                  height: 50,
                                  child: buildDayDropdown(
                                    selectedDay: selectedDay1,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedDay1 = value;
                                      });
                                    },
                                  ),
                                ),
                                const Text(
                                  'Đến',
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                  width: 75,
                                  height: 50,
                                  child: buildDayDropdown(
                                    selectedDay: selectedDay2,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedDay2 = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text(
                                  'Giờ',
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                  width: 75,
                                  height: 50,
                                  child: buildHourFromDropdown(
                                    selectedHour: selectedHour1,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedHour1 = value;
                                      });
                                    },
                                  ),
                                ),
                                const Text(
                                  'Đến',
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                  width: 75,
                                  height: 50,
                                  child: buildHourToDropdown(
                                    selectedHour: selectedHour2,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedHour2 = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 5),
                        child: RichText(
                          text: const TextSpan(
                            text: 'Mô tả chi tiết công việc',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '(*)',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 10),
                        child: buildDescriptionField(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: RichText(
                          text: const TextSpan(
                            text: 'Yêu cầu ứng viên',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '(*)',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 10),
                        child: buildRequestField(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: RichText(
                          text: const TextSpan(
                            text: 'Quyền lợi ứng viên',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '(*)',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 10),
                        child: buildInterestField(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: RichText(
                          text: const TextSpan(
                            text: 'Thời hạn ững tuyển',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '(*)',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: TextFormField(
                            readOnly: true,
                            onTap: () => _selectDate(context),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.date_range_outlined,
                                color: Colors.grey[800],
                              ),
                              hintText: 'Thời hạn ứng tuyển',
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey[800],
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            controller: _expirationDateController,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: Container(
          height: 80,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: _handlePost,
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
      ),
    );
  }

  TextFormField buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(
        hintText: 'Nhập tiêu đề',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
      ),
      textInputAction: TextInputAction.next,
      autofocus: false,
      validator: (value) {
        if (value!.isEmpty && value.length <= 10) {
          return 'Tên công việc phải hơn 10 kí tự';
        }
        return null;
      },
    );
  }

  GestureDetector buildCareerField() {
    return GestureDetector(
      onTap: () {
        _showCareerBottomSheet(context);
      },
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _careerController.text.isNotEmpty
                  ? _careerController.text
                  : 'Chọn ngành nghề',
              style: TextStyle(
                  color: _careerController.text.isNotEmpty
                      ? const Color.fromARGB(255, 0, 0, 0)
                      : const Color.fromARGB(255, 76, 76, 76),
                  fontSize: 16),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  DropdownButtonFormField<String> buildLoaiField() {
    return DropdownButtonFormField<String>(
      value: _loaiController.text.isNotEmpty ? _loaiController.text : null,
      items: const [
        DropdownMenuItem(
            value: 'Toàn thời gian', child: Text('Toàn thời gian')),
        DropdownMenuItem(value: 'Bán thời gian', child: Text('Bán thời gian')),
        DropdownMenuItem(value: 'Thực tập', child: Text('Thực tập')),
      ],
      onChanged: (value) {
        setState(() {
          _loaiController.text = value!;
        });
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
      ),
      hint: const Text('Loại hình công việc'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng chọn loại hình công việc.';
        }
        return null;
      },
    );
  }

  TextFormField buildSoLuongField() {
    return TextFormField(
      controller: _soluongController,
      decoration: InputDecoration(
        hintText: 'Số Lượng',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
      ),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.phone,
      autofocus: false,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a value.';
        }
        return null;
      },
    );
  }

  Widget buildDayDropdown(
      {String? selectedDay, ValueChanged<String?>? onChanged}) {
    return DropdownButtonFormField<String>(
      value: selectedDay,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
              color: Colors.black, width: 2), // Red border when not focused
        ),
      ),
      hint: const Center(
        child: Text(
          'Thứ 2',
          style: TextStyle(
            fontSize: 18,
            color: Color.fromARGB(255, 192, 192, 192),
          ),
        ),
      ),
      style: const TextStyle(
          fontSize: 18,
          color: Color.fromARGB(255, 0, 0, 0),
          fontWeight: FontWeight.bold),
      items: daysOfWeek.map((day) {
        return DropdownMenuItem(
          value: day,
          child: Text(day),
        );
      }).toList(),
      onChanged: onChanged,
      icon: const SizedBox.shrink(),
    );
  }

  Widget buildHourFromDropdown(
      {String? selectedHour, ValueChanged<String?>? onChanged}) {
    return DropdownButtonFormField<String>(
      value: selectedHour,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
              color: Colors.black, width: 2), // Red border when not focused
        ),
      ),
      hint: const Center(
        child: Text(
          '00:00',
          style: TextStyle(
            fontSize: 18,
            color: Color.fromARGB(255, 192, 192, 192),
          ),
        ),
      ),
      style: const TextStyle(
          fontSize: 18,
          color: Color.fromARGB(255, 0, 0, 0),
          fontWeight: FontWeight.bold),
      items: hourFrom.map((hour) {
        return DropdownMenuItem(
          value: hour,
          child: Text(hour),
        );
      }).toList(),
      onChanged: onChanged,
      icon: const SizedBox.shrink(),
      isDense: true,
    );
  }

  Widget buildHourToDropdown(
      {String? selectedHour, ValueChanged<String?>? onChanged}) {
    return DropdownButtonFormField<String>(
      value: selectedHour,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
              color: Colors.black, width: 2), // Red border when not focused
        ),
      ),
      hint: const Center(
        child: Text(
          '00:00',
          style: TextStyle(
            fontSize: 18,
            color: Color.fromARGB(255, 192, 192, 192),
          ),
        ),
      ),
      style: const TextStyle(
          fontSize: 18,
          color: Color.fromARGB(255, 0, 0, 0),
          fontWeight: FontWeight.bold),
      items: hourTo.map((hour) {
        return DropdownMenuItem(
          value: hour,
          child: Text(hour),
        );
      }).toList(),
      onChanged: onChanged,
      icon: const SizedBox.shrink(),
      isDense: true,
    );
  }

  TextFormField buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: InputDecoration(
        hintText: 'Mô tả công việc',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
      ),
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a description.';
        }
        if (value.length < 10) {
          return 'Should be at least 10 characters long';
        }
        return null;
      },
    );
  }

  TextFormField buildRequestField() {
    return TextFormField(
      controller: _requestController,
      decoration: InputDecoration(
        hintText: 'Yêu cầu ứng viên',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
      ),
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a description.';
        }
        if (value.length < 10) {
          return 'Should be at least 10 characters long';
        }
        return null;
      },
    );
  }

  TextFormField buildInterestField() {
    return TextFormField(
      controller: _interestController,
      decoration: InputDecoration(
        hintText: 'Quyền lợi ứng viên',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
      ),
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a description.';
        }
        if (value.length < 10) {
          return 'Should be at least 10 characters long';
        }
        return null;
      },
    );
  }
}
