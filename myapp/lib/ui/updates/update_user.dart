import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../ui/screens.dart';

class UpdateUser extends StatefulWidget {
  const UpdateUser({super.key});

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  DateTime? _selectedDate;
  Career? selectedCareer;
  CareerManager careerManager = CareerManager();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ngaysinhController = TextEditingController();
  final _gioitinhController = TextEditingController();
  final _careerController = TextEditingController();
  final _diachiController = TextEditingController();
  final _describeController = TextEditingController();

  Future<void> _handleUpdateUser() async {
    if (_formKey.currentState!.validate()) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      String? email = userProvider.email;
      final name = _nameController.text;
      int phone = (int.tryParse(_phoneController.text) ?? 0);
      String? birthday = formatDate(_selectedDate);
      final gender = _gioitinhController.text;
      final career = _careerController.text;
      final address = _diachiController.text;
      final description = _describeController.text;
      final userDataMap = {
        'email': email,
        'name': name,
        'phone': phone,
        'birthday': birthday,
        'career': career,
        'gender': gender,
        'address': address,
        'description': description,
      };
      final userData = UserData.fromMap(userDataMap);
      try {
        DatabaseConnection().updateUserData(email!, name, phone, birthday!,
            gender, career, address, description);
        Provider.of<UserProvider>(context, listen: false).setUserData(userData);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserScreen()),
        );
      } catch (e) {
        return;
      }
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
        _ngaysinhController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  String? formatDate(DateTime? date) {
    if (date == null) {
      return null;
    }
    // Define your desired format
    final DateFormat formatter =
        DateFormat('yyyy-MM-dd'); // or any other format
    return formatter.format(date);
  }

  void _showCareerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                SizedBox(
                  height: 900,
                  child: ListView.builder(
                    itemCount: careerManager.allCareer.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16),
                        child: ListTile(
                          title: Text(
                            careerManager.allCareer[index].name,
                          ),
                          onTap: () {
                            setState(() {
                              selectedCareer = careerManager.allCareer[index];
                              _careerController.text =
                                  careerManager.allCareer[index].name;
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                  ),
                ),
              ]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ',
            style: TextStyle(color: Colors.white, fontSize: 24)),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Hãy nhập thông tin cá nhân để xác nhận tài khoản',
                style: TextStyle(fontSize: 20, color: Colors.blue),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Nhập họ và tên',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 12.0),
                ),
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tên không được để trống';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: 'Nhập số điện thoại',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 12.0),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Số điện thoại không được bỏ trống';
                  }
                  if (value.length < 10 || value.length > 11) {
                    return 'Số điện thoại phải có từ 10 đến 11 chữ số';
                  }
                  if (!value.startsWith('0') ||
                      !['03', '05', '07', '08', '09']
                          .contains(value.substring(0, 2))) {
                    return 'Số điện thoại không hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _ngaysinhController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 12.0),
                  hintText: 'Ngày tháng năm sinh',
                  hintStyle: const TextStyle(color: Colors.grey),
                  suffixIcon: const Icon(Icons.calendar_month_rounded),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ngày tháng năm sinh không được để trống';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Giới tính:',
                    style: TextStyle(fontSize: 18),
                  ),
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
                ],
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  _showCareerBottomSheet(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _careerController.text.isNotEmpty
                            ? _careerController.text
                            : 'Loại Hình Công Việc',
                        style: TextStyle(
                          color: _careerController.text.isNotEmpty
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _diachiController,
                decoration: InputDecoration(
                  hintText: 'Nhập địa chỉ',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 12.0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Địa chỉ không được để trống';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _describeController,
                decoration: InputDecoration(
                  hintText: 'Giới thiệu bản thân',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: SizedBox(
                  width: 330,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: const BorderSide(color: Colors.blue),
                      ),
                      backgroundColor: Colors.blue,
                      textStyle: TextStyle(
                        color: Theme.of(context)
                            .primaryTextTheme
                            .titleLarge
                            ?.color,
                      ),
                    ),
                    onPressed: () async {
                      await _handleUpdateUser();
                    },
                    child: const Text(
                      'Cập nhật thông tin',
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
