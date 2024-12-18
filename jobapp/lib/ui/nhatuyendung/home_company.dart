import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobapp/controller/company_controller.dart';
import 'package:jobapp/server/database.dart';
import 'package:jobapp/ui/auth/auth_controller.dart';
import 'package:gradient_borders/gradient_borders.dart';

import 'category.dart';

class HomeNTD extends StatefulWidget {
  const HomeNTD({super.key});

  @override
  State<HomeNTD> createState() => _HomeNTDState();
}

class _HomeNTDState extends State<HomeNTD> {
  final AuthController controller = Get.find<AuthController>();
  final CompanyController companyController = Get.find<CompanyController>();
  late DateTime day;
  bool hasPackage = false;
  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(220),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(
                30), // Adjust this value to control the roundness
          ),
          child: AppBar(
            toolbarHeight: 220,
            backgroundColor: Colors.blue,
            title: Obx(() {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 10, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Xin chào nhà tuyển dụng',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                            onPressed: () {
                              controller.logout();
                            },
                            icon: const Icon(Icons.logout))
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed('/profileScreen');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          border: Border.all(
                              color: const Color.fromARGB(255, 216, 216, 216),
                              width: 3),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.blue,
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
                                  child: controller.companyModel.value.image !=
                                          null
                                      ? imageFromBase64String(controller
                                          .companyModel.value.image
                                          .toString())
                                      : const Image(
                                          image: AssetImage(
                                              'assets/images/user.png'),
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              SizedBox(
                                width: 240,
                                height: 70,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      controller.companyModel.value.name
                                          .toString(),
                                      style: const TextStyle(fontSize: 22),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: 630,
          child: Column(
            children: [
              SizedBox(
                width: 400,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: Container(
                    height: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      border: Border.all(
                          color: const Color.fromARGB(255, 216, 216, 216),
                          width: 3),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10.0, bottom: 10),
                              child: Text(
                                'Danh mục của bạn ',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            //Danh mục
                            Category(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    border: Border.all(
                        color: const Color.fromARGB(255, 216, 216, 216),
                        width: 3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            Text(
                              'Tổng số tin đã đăng',
                              style: TextStyle(fontSize: 15),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Obx(() {
                              return Text(
                                companyController.countPostJob.toString(),
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              );
                            })
                          ],
                        ),
                      ),
                      VerticalDivider(
                        width: 2,
                        thickness: 3,
                        color: const Color.fromARGB(255, 216, 216, 216),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            Text(
                              'Ứng viên đã ứng tuyển',
                              style: TextStyle(fontSize: 15),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Obx(() {
                              return Text(
                                companyController.countUserApply.toString(),
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              );
                            })
                          ],
                        ),
                      ),
                    ],
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
//  Padding(
//                         padding: const EdgeInsets.all(5.0),
//                         child: Column(
//                           children: [
//                             Text(
//                               'Ứng viên đã ứng tuyển',
//                               style: TextStyle(fontSize: 15),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             Obx(() {
//                               return Text(
//                                 companyController.countPostJob.toString(),
//                                 style: TextStyle(
//                                     fontSize: 22, fontWeight: FontWeight.bold),
//                               );
//                             })
//                           ],
//                         ),
//                       )