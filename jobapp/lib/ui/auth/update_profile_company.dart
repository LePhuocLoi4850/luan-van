import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobapp/models/career.dart';
import 'package:diacritic/diacritic.dart';
import 'package:jobapp/models/company_data.dart';

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
  String? _selectScale;
  final Map<String, String> _scale = {
    'Dưới 50 nhân viên': 'Dưới 50 nhân viên',
    '50 - 100 nhân viên': '50 - 100 nhân viên',
    '100 - 500 nhân viên': '100 - 500 nhân viên',
    'Trên 500 nhân viên': 'Trên 500 nhân viên',
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
    'An Giang': [
      'Thành phố Long Xuyên',
      'Thành phố Châu Đốc',
      'Thị xã Tân Châu',
      'Huyện An Phú',
      'Huyện Châu Phú',
      'Huyện Châu Thành',
      'Huyện Chợ Mới',
      'Huyện Phú Tân',
      'Huyện Thoại Sơn',
      'Huyện Tịnh Biên',
      'Huyện Tri Tôn'
    ],
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
    if (_formKey.currentState!.validate()) {
      final email = controller.email;
      final name = _nameController.text;
      String career = _careerController.text;
      int phone = (int.tryParse(_phoneController.text) ?? 0);
      String address = '$_selectedCity, $_selectedDistrict';
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
      print(base64String);
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
                              items: _districts.keys.map((String city) {
                                return DropdownMenuItem<String>(
                                  value: city,
                                  child: Text(city),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedCity = newValue;
                                  // _selectedDistrict = null;
                                });
                              },
                            ),
                            // if (_selectedCity != null)
                            //   Padding(
                            //     padding:
                            //         const EdgeInsets.only(left: 20.0, top: 20),
                            //     child: DropdownButtonFormField<String>(
                            //       decoration: InputDecoration(
                            //         border: OutlineInputBorder(
                            //           borderRadius: BorderRadius.circular(20),
                            //         ),
                            //       ),
                            //       hint: const Text('Chọn Quận/Huyện'),
                            //       value: _selectedDistrict,
                            //       items: _districts[_selectedCity]!
                            //           .map((String district) {
                            //         return DropdownMenuItem<String>(
                            //           value: district,
                            //           child: Text(district),
                            //         );
                            //       }).toList(),
                            //       onChanged: (newValue) {
                            //         setState(() {
                            //           _selectedDistrict = newValue;
                            //         });
                            //       },
                            //     ),
                            //   ),
                          ],
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
// 'Bà Rịa - Vũng Tàu': [
//       'Thành phố Vũng Tàu',
//       'Thành phố Bà Rịa',
//       'Huyện Châu Đức',
//       'Huyện Đất Đỏ',
//       'Huyện Long Điền',
//       'Huyện Tân Thành',
//       'Huyện Xuyên Mộc',
//       'Huyện Côn Đảo'
//     ],
//     'Bắc Giang': [
//       'Thành phố Bắc Giang',
//       'Huyện Hiệp Hòa',
//       'Huyện Lạng Giang',
//       'Huyện Lục Nam',
//       'Huyện Lục Ngạn',
//       'Huyện Sơn Động',
//       'Huyện Tân Yên',
//       'Huyện Việt Yên',
//       'Huyện Yên Dũng',
//       'Huyện Yên Thế'
//     ],
//     'Bắc Kạn': [
//       'Thành phố Bắc Kạn',
//       'Huyện Ba Bể',
//       'Huyện Bạch Thông',
//       'Huyện Chợ Đồn',
//       'Huyện Chợ Mới',
//       'Huyện Na Rì',
//       'Huyện Ngân Sơn',
//       'Huyện Pác Nặm'
//     ],
//     'Bạc Liêu': [
//       'Thành phố Bạc Liêu',
//       'Huyện Đông Hải',
//       'Huyện Giá Rai',
//       'Huyện Hòa Bình',
//       'Huyện Hồng Dân',
//       'Huyện Phước Long',
//       'Huyện Vĩnh Lợi'
//     ],
//     'Bắc Ninh': [
//       'Thành phố Bắc Ninh',
//       'Huyện Gia Bình',
//       'Huyện Lương Tài',
//       'Huyện Quế Võ',
//       'Huyện Thuận Thành',
//       'Huyện Tiên Du',
//       'Huyện Yên Phong',
//       'Thị xã Từ Sơn'
//     ],
//     'Bến Tre': [
//       'Thành phố Bến Tre',
//       'Huyện Ba Tri',
//       'Huyện Bình Đại',
//       'Huyện Châu Thành',
//       'Huyện Chợ Lách',
//       'Huyện Giồng Trôm',
//       'Huyện Mỏ Cày Bắc',
//       'Huyện Mỏ Cày Nam',
//       'Huyện Thạnh Phú'
//     ],
//     'Bình Định': [
//       'Thành phố Quy Nhơn',
//       'Huyện An Lão',
//       'Huyện Hoài Ân',
//       'Huyện Hoài Nhơn',
//       'Huyện Phù Cát',
//       'Huyện Phù Mỹ',
//       'Huyện Tây Sơn',
//       'Huyện Tuy Phước',
//       'Huyện Vân Canh',
//       'Huyện Vĩnh Thạnh',
//       'Thị xã An Nhơn'
//     ],
//     'Bình Dương': [
//       'Thành phố Thủ Dầu Một',
//       'Huyện Bàu Bàng',
//       'Huyện Bến Cát',
//       'Huyện Dầu Tiếng',
//       'Huyện Dĩ An',
//       'Huyện Phú Giáo',
//       'Huyện Tân Uyên',
//       'Huyện Thuận An'
//     ],
//     'Bình Phước': [
//       'Thành phố Đồng Xoài',
//       'Huyện Bù Đăng',
//       'Huyện Bù Đốp',
//       'Huyện Bù Gia Mập',
//       'Huyện Chơn Thành',
//       'Huyện Đồng Phú',
//       'Huyện Hớn Quản',
//       'Huyện Lộc Ninh',
//       'Huyện Phú Riềng'
//     ],
//     'Bình Thuận': [
//       'Thành phố Phan Thiết',
//       'Thị xã La Gi',
//       'Huyện Bắc Bình',
//       'Huyện Đức Linh',
//       'Huyện Hàm Tân',
//       'Huyện Hàm Thuận Bắc',
//       'Huyện Hàm Thuận Nam',
//       'Huyện Phú Quý',
//       'Huyện Tánh Linh',
//       'Huyện Tuy Phong'
//     ],
//     'Cà Mau': [
//       'Thành phố Cà Mau',
//       'Huyện Cái Nước',
//       'Huyện Đầm Dơi',
//       'Huyện Năm Căn',
//       'Huyện Ngọc Hiển',
//       'Huyện Phú Tân',
//       'Huyện Thới Bình',
//       'Huyện Trần Văn Thời',
//       'Huyện U Minh'
//     ],
//     'Cao Bằng': [
//       'Thành phố Cao Bằng',
//       'Huyện Bảo Lạc',
//       'Huyện Bảo Lâm',
//       'Huyện Hạ Lang',
//       'Huyện Hà Quảng',
//       'Huyện Hòa An',
//       'Huyện Nguyên Bình',
//       'Huyện Phục Hòa',
//       'Huyện Quảng Uyên',
//       'Huyện Thạch An',
//       'Huyện Trùng Khánh'
//     ],
//     'Đắk Lắk': [
//       'Thành phố Buôn Ma Thuột',
//       'Huyện Buôn Đôn',
//       'Huyện Cư Kuin',
//       'Huyện Cư Mgar',
//       'Huyện Ea Hleo',
//       'Huyện Ea Kar',
//       'Huyện Ea Súp',
//       'Huyện Krông Ana',
//       'Huyện Krông Bông',
//       'Huyện Krông Buk',
//       'Huyện Krông Năng',
//       'Huyện Krông Pắc',
//       'Huyện Lắk',
//       'Huyện MDrak',
//       'Thị xã Buôn Hồ'
//     ],
//     'Đắk Nông': [
//       'Thành phố Gia Nghĩa',
//       'Huyện Cư Jút',
//       'Huyện Đắk Glong',
//       'Huyện Đắk Mil',
//       'Huyện Đắk Rlấp',
//       'Huyện Đắk Song',
//       'Huyện Krông Nô',
//       'Huyện Tuy Đức'
//     ],
//     'Điện Biên': [
//       'Thành phố Điện Biên Phủ',
//       'Thị xã Mường Lay',
//       'Huyện Điện Biên',
//       'Huyện Điện Biên Đông',
//       'Huyện Mường Ảng',
//       'Huyện Mường Chà',
//       'Huyện Mường Nhé',
//       'Huyện Nậm Pồ',
//       'Huyện Tủa Chùa',
//       'Huyện Tuần Giáo'
//     ],
//     'Đồng Nai': [
//       'Thành phố Biên Hòa',
//       'Thành phố Long Khánh',
//       'Huyện Cẩm Mỹ',
//       'Huyện Định Quán',
//       'Huyện Long Thành',
//       'Huyện Nhơn Trạch',
//       'Huyện Tân Phú',
//       'Huyện Thống Nhất',
//       'Huyện Trảng Bom',
//       'Huyện Vĩnh Cửu',
//       'Huyện Xuân Lộc'
//     ],
//     'Đồng Tháp': [
//       'Thành phố Cao Lãnh',
//       'Thành phố Sa Đéc',
//       'Thành phố Hồng Ngự',
//       'Huyện Cao Lãnh',
//       'Huyện Châu Thành',
//       'Huyện Hồng Ngự',
//       'Huyện Lai Vung',
//       'Huyện Lấp Vò',
//       'Huyện Tam Nông',
//       'Huyện Tân Hồng',
//       'Huyện Thanh Bình',
//       'Huyện Tháp Mười'
//     ],
//     'Gia Lai': [
//       'Thành phố Pleiku',
//       'Thị xã An Khê',
//       'Thị xã Ayun Pa',
//       'Huyện Chư Păh',
//       'Huyện Chư Prông',
//       'Huyện Chư Sê',
//       'Huyện Chư Pưh',
//       'Huyện Đăk Đoa',
//       'Huyện Đăk Pơ',
//       'Huyện Đức Cơ',
//       'Huyện Ia Grai',
//       'Huyện Ia Pa',
//       'Huyện KBang',
//       'Huyện Kông Chro',
//       'Huyện Krông Pa',
//       'Huyện Mang Yang',
//       'Huyện Phú Thiện'
//     ],
//     'Hà Giang': [
//       'Thành phố Hà Giang',
//       'Huyện Bắc Mê',
//       'Huyện Bắc Quang',
//       'Huyện Đồng Văn',
//       'Huyện Hoàng Su Phì',
//       'Huyện Mèo Vạc',
//       'Huyện Quản Bạ',
//       'Huyện Quang Bình',
//       'Huyện Vị Xuyên',
//       'Huyện Xín Mần',
//       'Huyện Yên Minh'
//     ],
//     'Hà Nam': [
//       'Thành phố Phủ Lý',
//       'Huyện Bình Lục',
//       'Huyện Duy Tiên',
//       'Huyện Kim Bảng',
//       'Huyện Lý Nhân',
//       'Huyện Thanh Liêm'
//     ],
//     'Hà Tĩnh': [
//       'Thành phố Hà Tĩnh',
//       'Thị xã Hồng Lĩnh',
//       'Thị xã Kỳ Anh',
//       'Huyện Cẩm Xuyên',
//       'Huyện Can Lộc',
//       'Huyện Đức Thọ',
//       'Huyện Hương Khê',
//       'Huyện Hương Sơn',
//       'Huyện Kỳ Anh',
//       'Huyện Lộc Hà',
//       'Huyện Nghi Xuân',
//       'Huyện Thạch Hà',
//       'Huyện Vũ Quang'
//     ],
//     'Hải Dương': [
//       'Thành phố Hải Dương',
//       'Thị xã Chí Linh',
//       'Huyện Bình Giang',
//       'Huyện Cẩm Giàng',
//       'Huyện Gia Lộc',
//       'Huyện Kim Thành',
//       'Huyện Kinh Môn',
//       'Huyện Nam Sách',
//       'Huyện Ninh Giang',
//       'Huyện Thanh Hà',
//       'Huyện Thanh Miện',
//       'Huyện Tứ Kỳ'
//     ],
//     'Hậu Giang': [
//       'Thành phố Vị Thanh',
//       'Thị xã Long Mỹ',
//       'Huyện Châu Thành',
//       'Huyện Châu Thành A',
//       'Huyện Long Mỹ',
//       'Huyện Phụng Hiệp',
//       'Huyện Vị Thủy',
//       'Thị xã Ngã Bảy'
//     ],
//     'Hòa Bình': [
//       'Thành phố Hòa Bình',
//       'Huyện Cao Phong',
//       'Huyện Đà Bắc',
//       'Huyện Kim Bôi',
//       'Huyện Kỳ Sơn',
//       'Huyện Lạc Sơn',
//       'Huyện Lạc Thủy',
//       'Huyện Lương Sơn',
//       'Huyện Mai Châu',
//       'Huyện Tân Lạc',
//       'Huyện Yên Thủy'
//     ],
//     'Hưng Yên': [
//       'Thành phố Hưng Yên',
//       'Huyện Ân Thi',
//       'Huyện Khoái Châu',
//       'Huyện Kim Động',
//       'Huyện Mỹ Hào',
//       'Huyện Phù Cừ',
//       'Huyện Tiên Lữ',
//       'Huyện Văn Giang',
//       'Huyện Văn Lâm',
//       'Huyện Yên Mỹ'
//     ],
//     'Khánh Hòa': [
//       'Thành phố Nha Trang',
//       'Thành phố Cam Ranh',
//       'Thị xã Ninh Hòa',
//       'Huyện Diên Khánh',
//       'Huyện Khánh Sơn',
//       'Huyện Khánh Vĩnh',
//       'Huyện Trường Sa',
//       'Huyện Vạn Ninh',
//       'Huyện Cam Lâm'
//     ],
//     'Kiên Giang': [
//       'Thành phố Rạch Giá',
//       'Thị xã Hà Tiên',
//       'Huyện An Biên',
//       'Huyện An Minh',
//       'Huyện Châu Thành',
//       'Huyện Giang Thành',
//       'Huyện Giồng Riềng',
//       'Huyện Gò Quao',
//       'Huyện Hòn Đất',
//       'Huyện Kiên Hải',
//       'Huyện Kiên Lương',
//       'Huyện Phú Quốc',
//       'Huyện Tân Hiệp',
//       'Huyện U Minh Thượng',
//       'Huyện Vĩnh Thuận'
//     ],
//     'Kon Tum': [
//       'Thành phố Kon Tum',
//       'Huyện Đăk Glei',
//       'Huyện Đăk Hà',
//       'Huyện Đăk Tô',
//       'Huyện Ia H\'Drai',
//       'Huyện Kon Plông',
//       'Huyện Kon Rẫy',
//       'Huyện Ngọc Hồi',
//       'Huyện Sa Thầy',
//       'Huyện Tu Mơ Rông'
//     ],
//     'Lai Châu': [
//       'Thành phố Lai Châu',
//       'Huyện Mường Tè',
//       'Huyện Nậm Nhùn',
//       'Huyện Phong Thổ',
//       'Huyện Sìn Hồ',
//       'Huyện Tam Đường',
//       'Huyện Tân Uyên',
//       'Huyện Than Uyên'
//     ],
//     'Lâm Đồng': [
//       'Thành phố Đà Lạt',
//       'Thành phố Bảo Lộc',
//       'Huyện Bảo Lâm',
//       'Huyện Cát Tiên',
//       'Huyện Đạ Huoai',
//       'Huyện Đạ Tẻh',
//       'Huyện Đam Rông',
//       'Huyện Di Linh',
//       'Huyện Đơn Dương',
//       'Huyện Đức Trọng',
//       'Huyện Lạc Dương',
//       'Huyện Lâm Hà'
//     ],
//     'Lạng Sơn': [
//       'Thành phố Lạng Sơn',
//       'Huyện Bắc Sơn',
//       'Huyện Bình Gia',
//       'Huyện Cao Lộc',
//       'Huyện Chi Lăng',
//       'Huyện Đình Lập',
//       'Huyện Hữu Lũng',
//       'Huyện Lộc Bình',
//       'Huyện Tràng Định',
//       'Huyện Văn Lãng',
//       'Huyện Văn Quan'
//     ],
//     'Lào Cai': [
//       'Thành phố Lào Cai',
//       'Huyện Bảo Thắng',
//       'Huyện Bảo Yên',
//       'Huyện Bát Xát',
//       'Huyện Bắc Hà',
//       'Huyện Mường Khương',
//       'Huyện Sa Pa',
//       'Huyện Si Ma Cai',
//       'Huyện Văn Bàn'
//     ],
//     'Long An': [
//       'Thành phố Tân An',
//       'Thị xã Kiến Tường',
//       'Huyện Bến Lức',
//       'Huyện Cần Đước',
//       'Huyện Cần Giuộc',
//       'Huyện Châu Thành',
//       'Huyện Đức Hòa',
//       'Huyện Đức Huệ',
//       'Huyện Mộc Hóa',
//       'Huyện Tân Hưng',
//       'Huyện Tân Thạnh',
//       'Huyện Tân Trụ',
//       'Huyện Thạnh Hóa',
//       'Huyện Thủ Thừa',
//       'Huyện Vĩnh Hưng'
//     ],
//     'Nam Định': [
//       'Thành phố Nam Định',
//       'Huyện Giao Thủy',
//       'Huyện Hải Hậu',
//       'Huyện Mỹ Lộc',
//       'Huyện Nam Trực',
//       'Huyện Nghĩa Hưng',
//       'Huyện Trực Ninh',
//       'Huyện Vụ Bản',
//       'Huyện Xuân Trường',
//       'Huyện Ý Yên'
//     ],
//     'Nghệ An': [
//       'Thành phố Vinh',
//       'Thị xã Cửa Lò',
//       'Thị xã Hoàng Mai',
//       'Thị xã Thái Hòa',
//       'Huyện Anh Sơn',
//       'Huyện Con Cuông',
//       'Huyện Diễn Châu',
//       'Huyện Đô Lương',
//       'Huyện Hưng Nguyên',
//       'Huyện Kỳ Sơn',
//       'Huyện Nam Đàn',
//       'Huyện Nghi Lộc',
//       'Huyện Nghĩa Đàn',
//       'Huyện Quế Phong',
//       'Huyện Quỳ Châu',
//       'Huyện Quỳ Hợp',
//       'Huyện Quỳnh Lưu',
//       'Huyện Tân Kỳ',
//       'Huyện Thanh Chương',
//       'Huyện Tương Dương',
//       'Huyện Yên Thành'
//     ],
//     'Ninh Bình': [
//       'Thành phố Ninh Bình',
//       'Thành phố Tam Điệp',
//       'Huyện Gia Viễn',
//       'Huyện Hoa Lư',
//       'Huyện Kim Sơn',
//       'Huyện Nho Quan',
//       'Huyện Yên Khánh',
//       'Huyện Yên Mô'
//     ],
//     'Ninh Thuận': [
//       'Thành phố Phan Rang-Tháp Chàm',
//       'Huyện Bác Ái',
//       'Huyện Ninh Hải',
//       'Huyện Ninh Phước',
//       'Huyện Ninh Sơn',
//       'Huyện Thuận Bắc',
//       'Huyện Thuận Nam'
//     ],
//     'Phú Thọ': [
//       'Thành phố Việt Trì',
//       'Thị xã Phú Thọ',
//       'Huyện Cẩm Khê',
//       'Huyện Đoan Hùng',
//       'Huyện Hạ Hòa',
//       'Huyện Lâm Thao',
//       'Huyện Phù Ninh',
//       'Huyện Tam Nông',
//       'Huyện Tân Sơn',
//       'Huyện Thanh Ba',
//       'Huyện Thanh Sơn',
//       'Huyện Thanh Thủy',
//       'Huyện Yên Lập'
//     ],
//     'Phú Yên': [
//       'Thành phố Tuy Hòa',
//       'Thị xã Sông Cầu',
//       'Huyện Đồng Xuân',
//       'Huyện Phú Hòa',
//       'Huyện Sơn Hòa',
//       'Huyện Sông Hinh',
//       'Huyện Tây Hòa',
//       'Huyện Tuy An'
//     ],
//     'Quảng Bình': [
//       'Thành phố Đồng Hới',
//       'Thị xã Ba Đồn',
//       'Huyện Bố Trạch',
//       'Huyện Lệ Thủy',
//       'Huyện Minh Hóa',
//       'Huyện Quảng Ninh',
//       'Huyện Quảng Trạch',
//       'Huyện Tuyên Hóa'
//     ],
//     'Quảng Nam': [
//       'Thành phố Tam Kỳ',
//       'Thành phố Hội An',
//       'Huyện Bắc Trà My',
//       'Huyện Đại Lộc',
//       'Huyện Điện Bàn',
//       'Huyện Đông Giang',
//       'Huyện Duy Xuyên',
//       'Huyện Hiệp Đức',
//       'Huyện Nam Giang',
//       'Huyện Nam Trà My',
//       'Huyện Nông Sơn',
//       'Huyện Núi Thành',
//       'Huyện Phú Ninh',
//       'Huyện Phước Sơn',
//       'Huyện Quế Sơn',
//       'Huyện Tây Giang',
//       'Huyện Thăng Bình',
//       'Huyện Tiên Phước'
//     ],
//     'Quảng Ngãi': [
//       'Thành phố Quảng Ngãi',
//       'Huyện Ba Tơ',
//       'Huyện Bình Sơn',
//       'Huyện Đức Phổ',
//       'Huyện Lý Sơn',
//       'Huyện Minh Long',
//       'Huyện Mộ Đức',
//       'Huyện Nghĩa Hành',
//       'Huyện Sơn Hà',
//       'Huyện Sơn Tây',
//       'Huyện Sơn Tịnh',
//       'Huyện Tây Trà',
//       'Huyện Trà Bồng',
//       'Huyện Tư Nghĩa'
//     ],
//     'Quảng Ninh': [
//       'Thành phố Hạ Long',
//       'Thành phố Móng Cái',
//       'Thành phố Uông Bí',
//       'Thành phố Cẩm Phả',
//       'Thị xã Đông Triều',
//       'Thị xã Quảng Yên',
//       'Huyện Ba Chẽ',
//       'Huyện Bình Liêu',
//       'Huyện Cô Tô',
//       'Huyện Đầm Hà',
//       'Huyện Hải Hà',
//       'Huyện Hoành Bồ',
//       'Huyện Tiên Yên',
//       'Huyện Vân Đồn'
//     ],
//     'Sóc Trăng': [
//       'Thành phố Sóc Trăng',
//       'Thị xã Vĩnh Châu',
//       'Huyện Cù Lao Dung',
//       'Huyện Kế Sách',
//       'Huyện Long Phú',
//       'Huyện Mỹ Tú',
//       'Huyện Mỹ Xuyên',
//       'Huyện Ngã Năm',
//       'Huyện Thạnh Trị',
//       'Huyện Trần Đề'
//     ],
//     'Sơn La': [
//       'Thành phố Sơn La',
//       'Huyện Bắc Yên',
//       'Huyện Mai Sơn',
//       'Huyện Mộc Châu',
//       'Huyện Mường La',
//       'Huyện Phù Yên',
//       'Huyện Quỳnh Nhai',
//       'Huyện Sông Mã',
//       'Huyện Sốp Cộp',
//       'Huyện Thuận Châu',
//       'Huyện Vân Hồ',
//       'Huyện Yên Châu'
//     ],
//     'Tây Ninh': [
//       'Thành phố Tây Ninh',
//       'Huyện Bến Cầu',
//       'Huyện Châu Thành',
//       'Huyện Dương Minh Châu',
//       'Huyện Gò Dầu',
//       'Huyện Hòa Thành',
//       'Huyện Tân Biên',
//       'Huyện Tân Châu',
//       'Huyện Trảng Bàng'
//     ],
//     'Thái Bình': [
//       'Thành phố Thái Bình',
//       'Huyện Đông Hưng',
//       'Huyện Hưng Hà',
//       'Huyện Kiến Xương',
//       'Huyện Quỳnh Phụ',
//       'Huyện Thái Thụy',
//       'Huyện Tiền Hải',
//       'Huyện Vũ Thư'
//     ],
//     'Thái Nguyên': [
//       'Thành phố Thái Nguyên',
//       'Thành phố Sông Công',
//       'Huyện Đại Từ',
//       'Huyện Định Hóa',
//       'Huyện Đồng Hỷ',
//       'Huyện Phú Bình',
//       'Huyện Phú Lương',
//       'Huyện Võ Nhai',
//       'Thị xã Phổ Yên'
//     ],
//     'Thanh Hóa': [
//       'Thành phố Thanh Hóa',
//       'Thị xã Bỉm Sơn',
//       'Thị xã Sầm Sơn',
//       'Huyện Bá Thước',
//       'Huyện Cẩm Thủy',
//       'Huyện Đông Sơn',
//       'Huyện Hà Trung',
//       'Huyện Hậu Lộc',
//       'Huyện Hoằng Hóa',
//       'Huyện Lang Chánh',
//       'Huyện Mường Lát',
//       'Huyện Nga Sơn',
//       'Huyện Ngọc Lặc',
//       'Huyện Như Thanh',
//       'Huyện Như Xuân',
//       'Huyện Nông Cống',
//       'Huyện Quan Hóa',
//       'Huyện Quan Sơn',
//       'Huyện Quảng Xương',
//       'Huyện Thạch Thành',
//       'Huyện Thiệu Hóa',
//       'Huyện Thọ Xuân',
//       'Huyện Thường Xuân',
//       'Huyện Triệu Sơn',
//       'Huyện Vĩnh Lộc',
//       'Huyện Yên Định'
//     ],
//     'Thừa Thiên Huế': [
//       'Thành phố Huế',
//       'Thị xã Hương Thủy',
//       'Thị xã Hương Trà',
//       'Huyện A Lưới',
//       'Huyện Nam Đông',
//       'Huyện Phong Điền',
//       'Huyện Phú Lộc',
//       'Huyện Phú Vang',
//       'Huyện Quảng Điền'
//     ],
//     'Tiền Giang': [
//       'Thành phố Mỹ Tho',
//       'Thị xã Gò Công',
//       'Thị xã Cai Lậy',
//       'Huyện Cái Bè',
//       'Huyện Cai Lậy',
//       'Huyện Châu Thành',
//       'Huyện Chợ Gạo',
//       'Huyện Gò Công Đông',
//       'Huyện Gò Công Tây',
//       'Huyện Tân Phú Đông',
//       'Huyện Tân Phước'
//     ],
//     'Trà Vinh': [
//       'Thành phố Trà Vinh',
//       'Huyện Càng Long',
//       'Huyện Cầu Kè',
//       'Huyện Cầu Ngang',
//       'Huyện Châu Thành',
//       'Huyện Duyên Hải',
//       'Huyện Tiểu Cần',
//       'Huyện Trà Cú'
//     ],
//     'Tuyên Quang': [
//       'Thành phố Tuyên Quang',
//       'Huyện Chiêm Hóa',
//       'Huyện Hàm Yên',
//       'Huyện Lâm Bình',
//       'Huyện Na Hang',
//       'Huyện Sơn Dương',
//       'Huyện Yên Sơn'
//     ],
//     'Vĩnh Long': [
//       'Thành phố Vĩnh Long',
//       'Huyện Bình Minh',
//       'Huyện Bình Tân',
//       'Huyện Long Hồ',
//       'Huyện Mang Thít',
//       'Huyện Tam Bình',
//       'Huyện Trà Ôn',
//       'Huyện Vũng Liêm'
//     ],
//     'Vĩnh Phúc': [
//       'Thành phố Vĩnh Yên',
//       'Thị xã Phúc Yên',
//       'Huyện Bình Xuyên',
//       'Huyện Lập Thạch',
//       'Huyện Sông Lô',
//       'Huyện Tam Đảo',
//       'Huyện Tam Dương',
//       'Huyện Vĩnh Tường',
//       'Huyện Yên Lạc'
//     ],
//     'Yên Bái': [
//       'Thành phố Yên Bái',
//       'Thị xã Nghĩa Lộ',
//       'Huyện Lục Yên',
//       'Huyện Mù Căng Chải',
//       'Huyện Trạm Tấu',
//       'Huyện Trấn Yên',
//       'Huyện Văn Chấn',
//       'Huyện Văn Yên',
//       'Huyện Yên Bình'
//     ]