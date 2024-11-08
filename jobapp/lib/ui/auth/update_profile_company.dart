import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobapp/models/career.dart';
import 'package:diacritic/diacritic.dart';
import 'package:jobapp/models/company_data.dart';

import '../../models/wards_data.dart';
import 'auth_controller.dart';

class UpdateProfileCompany extends StatefulWidget {
  const UpdateProfileCompany({super.key});

  @override
  State<UpdateProfileCompany> createState() => _UpdateProfileCompanyState();
}

class _UpdateProfileCompanyState extends State<UpdateProfileCompany> {
  final AuthController controller = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  Career? selectedCareer;
  CareerManager careerManager = CareerManager();
  List<Career> filteredCareerList = CareerManager().allCareer;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String? base64String;
  late CompanyModel companyModel;
  final _careerController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _gioithieuController = TextEditingController();
  final _searchController = TextEditingController();
  String? _selectedCity;
  String? _selectedDistrict;
  String? _selectedWard;
  String? _houseNumberStreet;
  String? _selectScale;
  bool _isCareerSelected = false;
  final Map<String, String> _scale = {
    'Dưới 50 nhân viên': 'Dưới 50 nhân viên',
    '50 - 100 nhân viên': '50 - 100 nhân viên',
    '100 - 500 nhân viên': '100 - 500 nhân viên',
    'Trên 500 nhân viên': 'Trên 500 nhân viên',
  };

  // Future<void> _takePhoto() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.camera);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //     });
  //     List<int> imageBytes = File(_image!.path).readAsBytesSync();
  //     base64String = base64Encode(imageBytes);
  //     Provider.of<MyBase64>(context, listen: false).updateBase64(base64String!);
  //   }
  // }
  Future<void> _handleUpdateCompany() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên công ty')),
      );
      return;
    }
    if (!_isCareerSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ngành nghề')),
      );
      return;
    }
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập số điện thoại')),
      );
      return;
    }
    if (!RegExp(r'^(?:[+0]9)?[0-9]{10}$').hasMatch(_phoneController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Số điện thoại không hợp lệ')),
      );
    }
    if (_selectScale == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn quy mô công ty')),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      final email = controller.email;
      final name = _nameController.text;
      String career = _careerController.text;
      int phone = (int.tryParse(_phoneController.text) ?? 0);
      String address =
          '$_houseNumberStreet, $_selectedWard, $_selectedDistrict, $_selectedCity';
      String scale = '$_selectScale';
      final description = _gioithieuController.text;
      final image = base64String;
      try {
        controller.updateCompanyData(
            name, email!, career, phone, address, scale, description, image!);
      } catch (e) {
        return;
      }
    }
  }

  Future<void> _takePhotoGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      List<int> imageBytes = File(_image!.path).readAsBytesSync();
      base64String = base64Encode(imageBytes);
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
                              setState(() {
                                selectedCareer = filteredCareers[index];
                                _careerController.text =
                                    filteredCareers[index].name;
                                _isCareerSelected = true;
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(30))),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _takePhotoGallery();
                        },
                        child: Center(
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                width: 100,
                                height: 100,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: _image == null
                                      ? const Image(
                                          image: AssetImage(
                                            'assets/images/user.png',
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          _image!,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              Positioned(
                                bottom: -10,
                                right: 0,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_rounded,
                                    color: Color.fromARGB(255, 49, 49, 49),
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        width: 250,
                        child: TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Nhập tên công ty',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              filled: true,
                              fillColor: Colors.white),
                          controller: _nameController,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập tên công ty';
                            }
                            return null;
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showCareerBottomSheet(context);
                          },
                          child: Container(
                            height: 55,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(Icons.card_travel_outlined),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Text(
                                    _careerController.text.isNotEmpty
                                        ? _careerController.text
                                        : 'Ngành nghề hoạt động',
                                    style: TextStyle(
                                      color: _careerController.text.isNotEmpty
                                          ? Colors.black
                                          : const Color.fromARGB(
                                              255, 69, 69, 69),
                                    ),
                                  ),
                                ),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.phone_android_rounded,
                              color: Colors.grey[800],
                            ),
                            hintText: 'Số điện thoại liên hệ',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (!RegExp(r'^(?:[+0]9)?[0-9]{10}$')
                                .hasMatch(value!)) {
                              return 'Số điện thoại không hợp lệ';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.people_alt_outlined,
                              color: Colors.grey[800],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          hint: const Text('Quy mô công ty'),
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
                        const SizedBox(
                          height: 20,
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
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Giới thiệu',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          maxLines: 6,
                          controller: _gioithieuController,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: PreferredSize(
          preferredSize: const Size.fromHeight(200),
          child: BottomAppBar(
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: SizedBox(
                width: 180,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    await _handleUpdateCompany();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Cập nhật thông tin',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
