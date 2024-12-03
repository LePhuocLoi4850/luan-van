import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobapp/server/database.dart';

import '../../../controller/calender_controller.dart';
import '../../../models/calender.dart';
import '../../auth/auth_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController controller = Get.find<AuthController>();
  CalenderController calenderController = Get.find<CalenderController>();
  File? _image;
  String? base64String;
  final ImagePicker _picker = ImagePicker();
  bool isExpanded = false;
  List<Map<String, dynamic>> allCalender = [];
  late DateTime day;
  bool hasPackage = false;
  @override
  void initState() {
    super.initState();
    fetchCalender();
    fetchPaymentDay();
  }

  void fetchPaymentDay() async {
    try {
      day = await Database()
          .fetchDayPaymentCompany(controller.companyModel.value.id!);
      if (day.isAfter(DateTime.now())) {
        print('gói còn hạn');
        setState(() {
          hasPackage = true;
        });
      } else {
        print('gói hết hạn');

        setState(() {
          hasPackage = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchCalender() async {
    int cid = controller.companyModel.value.id!;

    try {
      allCalender = await Database().fetchAllCalenderForCid(cid);

      calenderController.clearCldData();
      for (final calenderMap in allCalender) {
        final cld = Calender.fromMap(calenderMap);
        calenderController.addCld(cld);
      }
    } catch (e) {
      print('lỗi fetch calender: $e');
    }
  }

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
                              border: hasPackage
                                  ? GradientBoxBorder(
                                      width: 5, // Độ dày của border
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.red,
                                          Colors.yellow,
                                          Colors.green,
                                          Colors.blue
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    )
                                  : null,
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
                      child: const Text("Thông tin"),
                    ),
                  ),
                  Tab(
                    child: Container(
                      width: 120, // Chiều rộng cho tab nhỏ
                      alignment: Alignment.center,
                      child: const Text("Lịch phỏng vấn"),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  color: Colors.grey[200],
                  child: TabBarView(children: [
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
                        child: SingleChildScrollView(
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
                                  SizedBox(
                                    width: 290,
                                    height: 100,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Địa chỉ',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        Expanded(
                                          child: Text(
                                            controller
                                                .companyModel.value.address
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                        color: Colors.grey[200],
                        width: double.infinity,
                        padding: const EdgeInsets.all(0.0),
                        child: calenderController.calenderData.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 20),
                                child: Container(
                                  height: 120,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.grey),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Text(
                                            'Bạn chưa có mẫu lịch phỏng vấn',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 300,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              final result = await Get.toNamed(
                                                  '/calenderScreen');
                                              if (result == true) {
                                                setState(() {});
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.add,
                                                  color: Color.fromARGB(
                                                      136, 0, 0, 0),
                                                ),
                                                Text(
                                                  'Thêm mẫu lịch phỏng vấn',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                    height: 500,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 10),
                                          child: ElevatedButton.icon(
                                            onPressed: () async {
                                              final result = await Get.toNamed(
                                                  '/calenderScreen');

                                              if (result == true) {
                                                setState(() {});
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            icon: const Icon(Icons.add),
                                            label: const Text('Thêm'),
                                          ),
                                        ),
                                        Expanded(
                                          child: SingleChildScrollView(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                children: calenderController
                                                    .calenderData
                                                    .asMap()
                                                    .entries
                                                    .map((entry) {
                                                  final colors = [
                                                    Colors.grey[200],
                                                    Colors.grey[50],
                                                  ];
                                                  final index = entry.key;
                                                  final cld = entry.value;
                                                  final color = colors[
                                                      index % colors.length];
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                        color: color,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: ListTile(
                                                      title: Text(cld.name),
                                                      trailing: Text(
                                                        'Xem',
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                      onTap: () async {
                                                        Map<String, dynamic>
                                                            data = {
                                                          'cld_id': cld.cldId,
                                                          'cid': cld.cid,
                                                          'name': cld.name,
                                                          'time': cld.time,
                                                          'address':
                                                              cld.address,
                                                          'createAt':
                                                              cld.createAt,
                                                          'note': cld.note,
                                                        };
                                                        final result =
                                                            await Get.toNamed(
                                                          '/calenderDetail',
                                                          arguments: data,
                                                        );
                                                        if (result == true) {
                                                          setState(() {});
                                                        }
                                                      },
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ))
                  ]),
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

    int id = int.parse(controller.companyModel.value.id.toString());
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      List<int> imageBytes = File(_image!.path).readAsBytesSync();
      base64String = base64Encode(imageBytes);
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
