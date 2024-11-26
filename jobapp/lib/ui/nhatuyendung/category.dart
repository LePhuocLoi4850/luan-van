import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 32,
        child: Wrap(
          spacing: 15.0,
          runSpacing: 10.0,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: SizedBox(
                width: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed("/postJob");
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color.fromARGB(255, 252, 228, 212),
                              border: Border.all(
                                  color: Color.fromARGB(255, 252, 185, 140),
                                  width: 2)),
                          child: const Center(
                            child: FaIcon(
                              FontAwesomeIcons.solidPaperPlane,
                              size: 30,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      'Đăng tin tuyển dụng',
                      style: TextStyle(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: SizedBox(
                width: 80,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed('/listJob');
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color.fromARGB(255, 187, 253, 187),
                              border: Border.all(
                                  color: Color.fromARGB(255, 143, 244, 143),
                                  width: 2)),
                          child: const Center(
                            child: FaIcon(
                              FontAwesomeIcons.clipboardList,
                              size: 30,
                              color: Color.fromARGB(255, 49, 171, 54),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      'Quản lý tin đăng',
                      style: TextStyle(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: SizedBox(
                width: 80,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed('/managementUV');
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color.fromARGB(255, 214, 235, 255),
                              border: Border.all(
                                  color: Color.fromARGB(255, 131, 191, 247),
                                  width: 2)),
                          child: const Center(
                            child: FaIcon(
                              FontAwesomeIcons.addressBook,
                              size: 30,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      'Quản lý ứng viên',
                      style: TextStyle(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: SizedBox(
                width: 80,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed('/searchUvScreen');
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color.fromARGB(255, 234, 214, 255),
                              border: Border.all(
                                  color: Color.fromARGB(255, 234, 131, 247),
                                  width: 2)),
                          child: const Center(
                            child: Icon(
                              Icons.person_search,
                              size: 30,
                              color: Color.fromARGB(255, 234, 33, 243),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      'Tìm kiếm ứng viên',
                      style: TextStyle(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 80,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed('/profileScreen');
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color.fromARGB(255, 214, 255, 254),
                            border: Border.all(
                                color: Color.fromARGB(255, 131, 247, 253),
                                width: 2)),
                        child: const Center(
                          child: Icon(
                            Icons.location_city_sharp,
                            size: 30,
                            color: Color.fromARGB(255, 33, 243, 222),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'Hồ sơ nhà tuyển dụng',
                    style: TextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: SizedBox(
                width: 80,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed('/momo');
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color.fromARGB(255, 255, 214, 214),
                              border: Border.all(
                                  color: Color.fromARGB(255, 253, 131, 131),
                                  width: 2)),
                          child: const Center(
                            child: Icon(
                              Icons.shopping_bag_rounded,
                              size: 30,
                              color: Color.fromARGB(255, 243, 33, 33),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      'Gói dịch vụ',
                      style: TextStyle(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
