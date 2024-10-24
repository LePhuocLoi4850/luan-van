import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobapp/server/database.dart';

import '../../auth/auth_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController controller = Get.find<AuthController>();
  File? _image;
  String? base64String;
  final ImagePicker _picker = ImagePicker();
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/background.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 200,
                    child: Container(
                      width: size.width,
                      height: size.height - 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    left: size.width * 0.05,
                    child: GestureDetector(
                      onTap: () {
                        _takePhotoGallery();
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                            child: ClipOval(
                              child: controller.companyModel.value.image != null
                                  ? imageFromBase64String(controller
                                      .companyModel.value.image
                                      .toString())
                                  : const Image(
                                      image:
                                          AssetImage('assets/images/user.png'),
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Positioned(
                            bottom: -5,
                            right: 10,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                color: Color.fromARGB(255, 49, 49, 49),
                                size: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 60.0, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.companyModel.value.name.toString(),
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const Text('100 người theo dõi'),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, right: 20),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextButton(
                            onPressed: () async {
                              final result = await Get.toNamed('/profileUpdate',
                                  arguments: controller.companyModel);
                              if (result != null) {
                                setState(() {
                                  controller.companyModel = result;
                                });
                              }
                            },
                            child: const Text(
                              'Chỉnh sửa thông tin công ty',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue,
                indicatorSize: TabBarIndicatorSize.tab,
                labelPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                tabs: [
                  Tab(
                    child: Container(
                      width: 70,
                      alignment: Alignment.centerLeft,
                      child: const Text("Giới thiệu"),
                    ),
                  ),
                  Tab(
                    child: Container(
                      width: 120, // Tab giữa lớn hơn
                      alignment: Alignment.center,
                      child: const Text("Thông tin công ty"),
                    ),
                  ),
                  Tab(
                    child: Container(
                      width: 60, // Chiều rộng cho tab nhỏ
                      alignment: Alignment.center,
                      child: const Text("Khác"),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  color: Colors.grey[200],
                  child: TabBarView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Quy mô công ty',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Text(
                                    '${controller.companyModel.value.scale}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Về công ty',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isExpanded = !isExpanded;
                                        });
                                      },
                                      child: Text(
                                        isExpanded ? 'Thu gọn' : 'Xem thêm',
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${controller.companyModel.value.description}',
                                  style: const TextStyle(fontSize: 16),
                                  maxLines: isExpanded ? null : 6,
                                  overflow: isExpanded
                                      ? TextOverflow.visible
                                      : TextOverflow.ellipsis,
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.grey[200]),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.email,
                                          size: 25, color: Colors.grey),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Email',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        controller.companyModel.value.email
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.grey[200]),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.phone,
                                          size: 25, color: Colors.grey),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Số điện thoại',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        controller.companyModel.value.phone
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.grey[200]),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.sticky_note_2,
                                          size: 25, color: Colors.grey),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'ngành nghề',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        controller.companyModel.value.career
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.grey[200]),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.location_on,
                                          size: 25, color: Colors.grey),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Địa chỉ',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        controller.companyModel.value.address
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        child: const Text(
                          'Các thông tin khác...',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  Image imageFromBase64String(String base64String) {
    if (base64String.isEmpty || base64String == 'null') {
      return const Image(
        image: AssetImage('assets/images/user.png'),
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      );
    }

    try {
      return Image.memory(
        base64Decode(base64String),
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      );
    } catch (e) {
      print('Error decoding Base64 image: $e');
      return const Image(
        image: AssetImage('assets/images/user.png'),
        fit: BoxFit.cover,
      );
    }
  }

  Future<void> _takePhotoGallery() async {
    print('chọn ảnh');
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    print(controller.companyModel.value.id);
    int id = int.parse(controller.companyModel.value.id.toString());
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      List<int> imageBytes = File(_image!.path).readAsBytesSync();
      base64String = base64Encode(imageBytes);
      print(base64String);
    }

    try {
      await Database().updateImageCompany(id, base64String!);
      if (base64String != null && base64String!.isNotEmpty) {
        await Database().updateImageCompany(id, base64String!);
        setState(() {
          controller.companyModel.value =
              controller.companyModel.value.copyWith(
            image: base64String,
          );
        });
      }
    } catch (e) {
      print('Cập nhật ảnh thất bại: $e');
    }
  }
}
