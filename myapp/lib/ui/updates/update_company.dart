import 'package:flutter/material.dart';
import '../../models/company.dart';
import '../../provider/company_provider copy.dart';
import '../../ui/screens.dart';

class UpdateCompany extends StatefulWidget {
  const UpdateCompany({super.key});

  @override
  State<UpdateCompany> createState() => _UpdateCompanyState();
}

class _UpdateCompanyState extends State<UpdateCompany> {
  Career? selectedCareer;
  CareerManager careerManager = CareerManager();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _careerController = TextEditingController();
  final _diachiController = TextEditingController();
  final _thueController = TextEditingController();
  final _describeController = TextEditingController();

  Future<void> _handleUpdateCompany() async {
    if (_formKey.currentState!.validate()) {
      final companyProvider =
          Provider.of<CompanyProvider>(context, listen: false);
      String? email = companyProvider.email;
      final name = _nameController.text;
      int phone = (int.tryParse(_phoneController.text) ?? 0);
      final career = _careerController.text;
      final address = _diachiController.text;
      final tax = _thueController.text;
      final description = _describeController.text;
      final companyDataMap = {
        'email': email,
        'name': name,
        'career': career,
        'address': address,
        'tax': tax,
        'description': description,
        'phone': phone,
      };
      final companyData = CompanyData.fromMap(companyDataMap);
      print(companyDataMap);
      try {
        DatabaseConnection().updateCompanyData(
            email!, name, phone, career, address, tax, description);
        Provider.of<CompanyProvider>(context, listen: false)
            .setCompanyData(companyData);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CompanyScreen()),
        );
      } catch (e) {
        return;
      }
    }
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
            ],
          ),
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
                'Hãy nhập thông tin công ty để xác nhận tài khoản',
                style: TextStyle(fontSize: 20, color: Colors.blue),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Tên Công ty',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 12.0),
                ),
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
                              ? const Color.fromARGB(255, 0, 0, 0)
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
                controller: _thueController,
                decoration: InputDecoration(
                  hintText: 'Mã số thuế',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 12.0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mã số thuế không được để trống';
                  } else if (!RegExp(r'^\d{10,13}$').hasMatch(value)) {
                    return 'Mã số thuế phải chứa từ 10 đến 13 chữ số';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _describeController,
                decoration: InputDecoration(
                  hintText: 'Giới thiệu công ty',
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
                      await _handleUpdateCompany();
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
