import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobapp/server/database.dart';
import 'package:jobapp/ui/auth/auth_controller.dart';

import '../../../../../models/career.dart';

class UpdateName extends StatefulWidget {
  const UpdateName({super.key});

  @override
  _UpdateNameState createState() => _UpdateNameState();
}

class _UpdateNameState extends State<UpdateName> {
  final AuthController controller = Get.find<AuthController>();

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _careerController = TextEditingController();
  final _searchController = TextEditingController();

  Career? selectedCareer;
  CareerManager careerManager = CareerManager();

  @override
  void initState() {
    super.initState();
    _nameController.text = controller.userModel.value.name!;
    _careerController.text = controller.userModel.value.career!;
  }

  void _handleUpdate() async {
    int uid = controller.userModel.value.id!;
    String email = controller.userModel.value.email!;
    String name = _nameController.text;
    String career = _careerController.text;
    int phone = int.tryParse(controller.userModel.value.phone!)!;
    DateTime birthday =
        DateTime.tryParse(controller.userModel.value.birthday.toString())!;
    String gender = controller.userModel.value.gender!;
    int salaryFrom =
        int.parse(controller.userModel.value.salaryFrom.toString());
    int salaryTo = int.parse(controller.userModel.value.salaryTo.toString());
    String address = controller.userModel.value.address!;
    String experience = controller.userModel.value.experience!;
    try {
      await Database().updatePersonalInformationUser(uid, email, name, career,
          phone, birthday, gender, salaryFrom, salaryTo, address, experience);

      controller.userModel.value = controller.userModel.value.copyWith(
        name: name,
        career: career,
      );
      await controller.saveUserData(controller.userModel.value);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cập nhật thông tin cơ bản thành công'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Get.back();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật thông tin cơ bản'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Họ và tên'),
              ),
              TextFormField(
                controller: _nameController,
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên kỹ năng';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
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
            onPressed: () {
              _handleUpdate();
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
}
