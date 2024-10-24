import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jobapp/server/database.dart';

import '../../../../../controller/user_controller.dart';
import '../../../../auth/auth_controller.dart';

class UpdateInformation extends StatefulWidget {
  const UpdateInformation({super.key});

  @override
  State<UpdateInformation> createState() => _UpdateInformationState();
}

class _UpdateInformationState extends State<UpdateInformation> {
  final AuthController controller = Get.find<AuthController>();
  final UserController userController = Get.find<UserController>();
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  String? _selectedCity;
  String? _selectGender;
  final _birthdayController = TextEditingController();
  final _genderController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _experienceController = TextEditingController();
  Map<String, dynamic> information = {};

  @override
  void initState() {
    super.initState();
    _emailController.text = controller.userModel.value.email.toString();
    _phoneController.text = controller.userModel.value.phone.toString();
    _genderController.text = controller.userModel.value.gender.toString();
    _addressController.text = controller.userModel.value.address.toString();
    _selectedCity = _addressController.text;
    _selectGender = _genderController.text;
    _birthdayController.text = controller.userModel.value.birthday.toString();
    _fromController.text =
        controller.userModel.value.salaryFrom?.toString() ?? '';
    _toController.text = controller.userModel.value.salaryTo?.toString() ?? '';
    _experienceController.text =
        controller.userModel.value.experience?.toString() ?? '';
  }

  void _handleUpdate() async {
    int uid = controller.userModel.value.id!;
    String email = _emailController.text;
    String name = controller.userModel.value.name!;
    String career = controller.userModel.value.career!;
    int phone = int.tryParse(_phoneController.text)!;
    DateTime birthday = DateTime.tryParse(_birthdayController.text)!;
    String gender = _genderController.text;
    int salaryFrom = int.parse(_fromController.text);
    int salaryTo = int.parse(_toController.text);
    String address = _addressController.text;
    String experience = _experienceController.text;
    try {
      await Database().updatePersonalInformationUser(uid, email, name, career,
          phone, birthday, gender, salaryFrom, salaryTo, address, experience);

      controller.userModel.value = controller.userModel.value.copyWith(
        email: email,
        phone: phone.toString(),
        birthday: birthday,
        gender: gender,
        salaryFrom: salaryFrom,
        salaryTo: salaryTo,
        address: address,
        experience: experience,
      );
      await controller.saveUserData(controller.userModel.value);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cập nhật thông tin cá nhân thành công'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Get.back();
    } catch (e) {
      print('update profile error: $e');
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
        _birthdayController.text =
            "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
      });
    }
  }

  String? formatDate(DateTime? date) {
    if (date == null) {
      return null;
    }
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Cập nhật thông tin cá nhân'),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                            top: 5.0,
                            bottom: 10,
                          ),
                          child: Text(
                            'email',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Nhập email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                            top: 5.0,
                            bottom: 10,
                          ),
                          child: Text(
                            'Số điện thoại',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Nhập số điện thoại',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 180,
                              child: TextFormField(
                                readOnly: true,
                                onTap: () => _selectDate(context),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.date_range_outlined,
                                    color: Colors.grey[800],
                                  ),
                                  hintText: 'Ngày sinh',
                                  suffixIcon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey[800],
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                controller: _birthdayController,
                              ),
                            ),
                            SizedBox(
                              width: 180,
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.female,
                                    color: Colors.grey[800],
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                hint: const Text('Giới tính'),
                                value: _selectGender,
                                items: _gender.keys.map((String gender) {
                                  return DropdownMenuItem<String>(
                                    value: gender,
                                    child: Text(gender),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectGender = newValue;
                                    _genderController.text = newValue ?? '';
                                    print(_genderController.text);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                            top: 5.0,
                            bottom: 10,
                          ),
                          child: Text(
                            'Mức lương mong muốn',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 120,
                              height: 50,
                              child: TextField(
                                  controller: _fromController,
                                  keyboardType: TextInputType.none,
                                  decoration: InputDecoration(
                                    hintText: 'Từ',
                                    hintStyle: const TextStyle(fontSize: 18),
                                    border: const OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Colors.black,
                                          width:
                                              1), // Red border when not focused
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Colors.black,
                                          width:
                                              1), // Red border when not focused
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                  readOnly: true,
                                  onTap: () => _showSalaryBottomSheet(
                                      context, _fromController)),
                            ),
                            const Text(
                              '-',
                              style: TextStyle(fontSize: 30),
                            ),
                            SizedBox(
                              width: 120,
                              height: 50,
                              child: TextField(
                                controller: _toController,
                                keyboardType: TextInputType.none,
                                decoration: InputDecoration(
                                  hintText: 'Đến',
                                  hintStyle: const TextStyle(fontSize: 18),
                                  border: const OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Colors.black,
                                        width:
                                            1), // Red border when not focused
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Colors.black,
                                        width:
                                            1), // Red border when not focused
                                  ),
                                ),
                                textAlign: TextAlign.center,
                                readOnly: true,
                                onTap: () => _showSalaryBottomSheet(
                                    context, _toController),
                              ),
                            ),
                            const Text(
                              'Triệu',
                              style: TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(
                                top: 5.0,
                                bottom: 10,
                              ),
                              child: Text(
                                'Số năm kinh nghiệm',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _showExperienceBottomSheet(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _experienceController
                                                          .text.isEmpty ||
                                                      _experienceController
                                                              .text ==
                                                          'Tất cả'
                                                  ? 'Chọn số năm kinh nghiệm'
                                                  : _experienceController.text,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: const Icon(
                                          Icons.arrow_drop_down,
                                          size: 25,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                            top: 5.0,
                            bottom: 10,
                          ),
                          child: Text(
                            'Địa điểm',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              hint: const Text('Chọn Tỉnh/Thành phố'),
                              value: _selectedCity,
                              items: _districts.keys.map((String city) {
                                return DropdownMenuItem<String>(
                                  value: city,
                                  child: Text(city),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedCity = newValue;
                                  _addressController.text = newValue ?? '';
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            onPressed: () async {
                              _handleUpdate();
                            },
                            child: Text(
                              'Cập nhật thông tin',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
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

  void _showExperienceBottomSheet(BuildContext context) {
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
                      'Chọn số năm kinh nghiệm',
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
                  itemCount: experience.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(experience[index]),
                      onTap: () {
                        setState(
                          () {
                            experience[index] == 'Tất cả'
                                ? _experienceController.text = ''
                                : _experienceController.text =
                                    experience[index];
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

  List<String> experience = [
    'Tất cả',
    'Sắp đi làm',
    'Dưới 1 năm',
    '1 năm',
    '2 năm',
    '3 năm',
    '4 năm',
    '5 năm',
    'Trên 5 năm',
    'Không yêu cầu'
  ];
  final Map<String, String> _gender = {
    'Nam': 'Nam',
    'Nữ': 'Nữ',
    'Khác': 'Khác'
  };
  final Map<String, List<String>> _districts = {
    'Hà Nội': [
      'Quận Ba Đình',
      'Quận Hoàn Kiếm',
      'Quận Hai Bà Trưng',
      'Quận Đống Đa',
      'Quận Cầu Giấy',
      'Quận Tây Hồ',
      'Quận Thanh Xuân',
      'Quận Hoàng Mai',
      'Quận Long Biên',
      'Quận Bắc Từ Liêm',
      'Quận Nam Từ Liêm',
      'Huyện Thanh Trì',
      'Huyện Gia Lâm',
      'Huyện Đông Anh',
      'Huyện Sóc Sơn',
      'Huyện Hoài Đức',
      'Huyện Quốc Oai',
      'Huyện Thanh Oai',
      'Huyện Thường Tín',
      'Huyện Phú Xuyên',
      'Huyện Ba Vì',
      'Huyện Phúc Thọ',
      'Huyện Chương Mỹ',
      'Huyện Đan Phượng',
      'Huyện Mỹ Đức',
      'Huyện Thạch Thất',
      'Huyện Ứng Hòa',
      'Thị xã Sơn Tây'
    ],
    'Hồ Chí Minh': [
      'Quận 1',
      'Quận 3',
      'Quận 4',
      'Quận 5',
      'Quận 6',
      'Quận 7',
      'Quận 8',
      'Quận 10',
      'Quận 11',
      'Quận 12',
      'Quận Bình Thạnh',
      'Quận Tân Bình',
      'Quận Tân Phú',
      'Quận Phú Nhuận',
      'Quận Gò Vấp',
      'Quận Bình Tân',
      'Quận Thủ Đức',
      'Huyện Nhà Bè',
      'Huyện Hóc Môn',
      'Huyện Củ Chi',
      'Huyện Bình Chánh',
      'Huyện Cần Giờ'
    ],
    'Đà Nẵng': [
      'Quận Hải Châu',
      'Quận Thanh Khê',
      'Quận Sơn Trà',
      'Quận Ngũ Hành Sơn',
      'Quận Liên Chiểu',
      'Quận Cẩm Lệ',
      'Huyện Hòa Vang',
      'Huyện Hoàng Sa'
    ],
    'Hải Phòng': [
      'Quận Hồng Bàng',
      'Quận Lê Chân',
      'Quận Ngô Quyền',
      'Quận Kiến An',
      'Quận Hải An',
      'Quận Đồ Sơn',
      'Quận Dương Kinh',
      'Huyện An Dương',
      'Huyện An Lão',
      'Huyện Kiến Thụy',
      'Huyện Tiên Lãng',
      'Huyện Vĩnh Bảo',
      'Huyện Thủy Nguyên',
      'Huyện Cát Hải',
      'Huyện Bạch Long Vĩ'
    ],
    'Cần Thơ': [
      'Quận Ninh Kiều',
      'Quận Bình Thủy',
      'Quận Cái Răng',
      'Quận Ô Môn',
      'Quận Thốt Nốt',
      'Huyện Phong Điền',
      'Huyện Thới Lai',
      'Huyện Cờ Đỏ',
      'Huyện Vĩnh Thạnh'
    ],
    'Bà Rịa - Vũng Tàu': [
      'Thành phố Vũng Tàu',
      'Thành phố Bà Rịa',
      'Huyện Châu Đức',
      'Huyện Đất Đỏ',
      'Huyện Long Điền',
      'Huyện Tân Thành',
      'Huyện Xuyên Mộc',
      'Huyện Côn Đảo'
    ],
  };
}
