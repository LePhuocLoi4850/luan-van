import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobapp/server/database.dart';

import '../../../models/career.dart';
import '../../../models/wards_data.dart';
import '../../auth/auth_controller.dart';

class ProfileUpdate extends StatefulWidget {
  const ProfileUpdate({super.key});

  @override
  State<ProfileUpdate> createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  final AuthController controller = Get.find<AuthController>();

  String? _selectedCity;
  String? _selectedDistrict;
  String? _selectedWard;
  String? _houseNumberStreet;
  Career? selectedCareer;
  CareerManager careerManager = CareerManager();
  String? _selectScale;
  String? address;
  bool isLoading = false;
  final Map<String, String> _scale = {
    'Dưới 50 nhân viên': 'Dưới 50 nhân viên',
    '50 - 100 nhân viên': '50 - 100 nhân viên',
    '100 - 500 nhân viên': '100 - 500 nhân viên',
    'Trên 500 nhân viên': 'Trên 500 nhân viên',
  };

  late TextEditingController _searchController;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _careerController;
  late TextEditingController _phoneController;
  late TextEditingController _scaleController;
  late TextEditingController _descriptionController;
  late TextEditingController _houseNumberStreetController;

  @override
  void initState() {
    super.initState();
    address = controller.companyModel.value.address;
    List<String> parts = address!.split(", ");
    for (var part in parts) {
      if (part.contains("Phường")) {
        _selectedWard = part;
      } else if (part.contains("Xã")) {
        _selectedWard = part;
      } else if (part.contains("Thị")) {
        _selectedWard = part;
      } else if (part.contains("Quận")) {
        _selectedDistrict = part;
      } else if (part.contains("Huyện")) {
        _selectedDistrict = part;
      } else {
        _selectedCity = part;
      }
    }
    _houseNumberStreetController =
        TextEditingController(text: address!.split(",")[0]);
    _houseNumberStreet = _houseNumberStreetController.text;
    _nameController =
        TextEditingController(text: controller.companyModel.value.name);
    _emailController =
        TextEditingController(text: controller.companyModel.value.email);
    _phoneController =
        TextEditingController(text: controller.companyModel.value.phone);
    _careerController =
        TextEditingController(text: controller.companyModel.value.career);
    _scaleController =
        TextEditingController(text: controller.companyModel.value.scale);
    _selectScale = _scaleController.text;
    _descriptionController =
        TextEditingController(text: controller.companyModel.value.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdateCompanyData() async {
    setState(() {
      isLoading = true;
    });
    int cid = int.parse(controller.companyModel.value.id.toString());
    String name = _nameController.text;
    String email = _emailController.text;
    int phone = int.parse(_phoneController.text);
    String scale = _selectScale.toString();
    String career = _careerController.text;
    String address =
        '$_houseNumberStreet, $_selectedWard, $_selectedDistrict, $_selectedCity';
    String description = _descriptionController.text;
    try {
      await Database().updateInformationCompany(
          cid, name, email, phone, scale, career, address, description);
      controller.companyModel.value = controller.companyModel.value.copyWith(
        id: cid,
        name: name,
        email: email,
        career: career,
        phone: phone.toString(),
        address: address,
        scale: scale,
        description: description,
      );
      await controller.saveCompanyData(controller.companyModel.value);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cập nhật thông tin công ty thành công'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Get.back();
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Hồ sơ công ty'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Tên công ty',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: controller.companyModel.value.name,
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.red, width: 3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.red, width: 3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                              fontWeight: FontWeight.w500),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Hãy nhập tên công ty';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Email công ty',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Số điện thoại',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: controller.companyModel.value.phone,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Quy mô công ty',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        hint: Text('${controller.companyModel.value.scale}'),
                        value: _selectScale,
                        items: _scale.keys.map((String scale) {
                          return DropdownMenuItem<String>(
                            value: scale,
                            child: Text(scale),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectScale = newValue;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Ngành nghề',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showCareerBottomSheet(context, () {
                            setState(() {});
                          });
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _careerController.text.isNotEmpty
                                            ? _careerController.text
                                            : 'Ngành nghề hoạt động',
                                        style: const TextStyle(
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
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Địa chỉ công ty',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.location_on_outlined,
                                color: Colors.grey[800],
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            hint: const Text('Chọn Tỉnh/Thành phố'),
                            value: _selectedCity,
                            items: wardsData.keys.map((String city) {
                              return DropdownMenuItem<String>(
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
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng chọn Tỉnh/Thành phố';
                              }
                              return null;
                            },
                          ),
                          if (_selectedCity != null)
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, top: 20),
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                hint: const Text('Chọn Quận/Huyện'),
                                value: _selectedDistrict,
                                items: wardsData[_selectedCity]!.entries.map(
                                    (MapEntry<String, List<String>> entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry.key,
                                    child: Text(entry.key),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedDistrict = newValue;
                                    _selectedWard = null;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng chọn Quận/Huyện';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          if (_selectedDistrict != null)
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, top: 20),
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                hint: const Text('Chọn Phường/Xã'),
                                value: _selectedWard,
                                items: wardsData[_selectedCity]![
                                        _selectedDistrict]!
                                    .map((String ward) {
                                  return DropdownMenuItem<String>(
                                    value: ward,
                                    child: Text(ward),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedWard = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng chọn Xã/Phường';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          if (_selectedWard != null)
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, top: 20),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Nhập số nhà và tên đường',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                controller: _houseNumberStreetController,
                                onChanged: (value) {
                                  setState(() {
                                    _houseNumberStreet = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng nhập số nhà và tên đường';
                                  }
                                  return null;
                                },
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Giới thiệu công ty',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextField(
                        controller: _descriptionController,
                        maxLines: 5,
                        minLines: 5,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          hintText: controller.companyModel.value.description,
                        ),
                      ),
                    ],
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
      bottomNavigationBar: Container(
        height: 80,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ElevatedButton(
            onPressed: _handleUpdateCompanyData,
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
}
