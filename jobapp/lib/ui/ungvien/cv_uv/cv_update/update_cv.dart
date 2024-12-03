import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../server/database.dart';
import '../../../auth/auth_controller.dart';

class UpdateCv extends StatefulWidget {
  const UpdateCv({super.key});

  @override
  State<UpdateCv> createState() => _UpdateCvState();
}

class _UpdateCvState extends State<UpdateCv> {
  final AuthController controller = Get.find<AuthController>();
  List<Map<String, dynamic>> _allEducation = [];
  List<Map<String, dynamic>> _allExperience = [];
  List<Map<String, dynamic>> _allCertificate = [];
  List<Map<String, dynamic>> _allSkill = [];
  File? _image;
  String? base64String;
  final ImagePicker _picker = ImagePicker();
  bool isExpanded = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _fetchEducation();
    _fetchExperience();
    _fetchCertificate();
    _fetchSkill();
  }

  void _fetchEducation() async {
    setState(() {
      isLoading = true;
    });
    int uid = controller.userModel.value.id!;
    try {
      _allEducation = await Database().fetchEducation(uid);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void _fetchExperience() async {
    setState(() {
      isLoading = true;
    });
    int uid = controller.userModel.value.id!;
    try {
      _allExperience = await Database().fetchExperience(uid);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void _fetchCertificate() async {
    setState(() {
      isLoading = true;
    });
    int uid = controller.userModel.value.id!;
    try {
      _allCertificate = await Database().fetchCertificate(uid);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void _fetchSkill() async {
    setState(() {
      isLoading = true;
    });
    int uid = controller.userModel.value.id!;
    try {
      _allSkill = await Database().fetchSkill(uid);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return DefaultTabController(
        length: 5,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.grey,
          appBar: AppBar(
            title: const Text(
              'Hồ sơ của tui',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
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
                          image: AssetImage('assets/images/backgrounduser.jpg'),
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
                                border:
                                    Border.all(color: Colors.white, width: 4),
                              ),
                              child: ClipOval(
                                child: controller.userModel.value.image != null
                                    ? imageFromBase64String(controller
                                        .userModel.value.image
                                        .toString())
                                    : const Image(
                                        image: AssetImage(
                                            'assets/images/user.png'),
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
                        controller.userModel.value.name.toString(),
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, right: 20),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextButton(
                                  onPressed: () async {
                                    final result =
                                        await Get.toNamed('/updateName');
                                    if (result == true) {
                                      setState(() {});
                                    }
                                  },
                                  child: Text(
                                    'Cập nhật thông tin cơ bản',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                    onPressed: () {
                                      Get.toNamed('/cvProfileScreen',
                                          arguments:
                                              controller.userModel.value.id);
                                    },
                                    icon: Icon(Icons.remove_red_eye)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                TabBar(
                  isScrollable: true,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.blue,
                  indicatorSize: TabBarIndicatorSize.tab,
                  padding: EdgeInsets.zero,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  tabs: [
                    Tab(
                      child: Container(
                        width: 80,
                        alignment: Alignment.center,
                        child: const Text("Giới thiệu"),
                      ),
                    ),
                    Tab(
                      child: Container(
                        width: 80,
                        alignment: Alignment.center,
                        child: const Text("Kinh nghiệm"),
                      ),
                    ),
                    Tab(
                      child: Container(
                        width: 60,
                        alignment: Alignment.center,
                        child: const Text("Học vấn"),
                      ),
                    ),
                    Tab(
                      child: Container(
                        width: 140,
                        alignment: Alignment.center,
                        child: const Text("Kỹ năng & Chứng chỉ"),
                      ),
                    ),
                    Tab(
                      child: Container(
                        width: 120,
                        alignment: Alignment.center,
                        child: const Text("Thông tin cá nhân"),
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
                            child: IntrinsicHeight(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Giới thiệu bản thân',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Get.toNamed('/updateDescription');
                                        },
                                        icon: Icon(Icons.edit),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '${controller.userModel.value.description}',
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
                            height: 300,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Kinh nghiệm',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    IconButton(
                                      onPressed: () async {
                                        final result = await Get.toNamed(
                                            '/insertExperience');
                                        if (result == true) {
                                          _fetchExperience();
                                          setState(() {});
                                        }
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ),
                                isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : Expanded(
                                        child: ListView.builder(
                                          padding: EdgeInsets.only(bottom: 50),
                                          shrinkWrap: true,
                                          itemCount: _allExperience.length,
                                          itemBuilder: (context, index) {
                                            final experience =
                                                _allExperience[index];
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0, bottom: 10),
                                              child: Container(
                                                height: 100,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Colors.grey[200],
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child: Image(
                                                              image: AssetImage(
                                                                  'assets/images/experience.jpg'),
                                                              width: 60,
                                                              height: 60,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                experience[
                                                                    'nameCompany'],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Text(experience[
                                                                  'position']),
                                                            ],
                                                          ),
                                                        ),
                                                        IconButton(
                                                          onPressed: () async {
                                                            final result =
                                                                await Get.toNamed(
                                                                    '/updateExperience',
                                                                    arguments:
                                                                        experience);
                                                            if (result ==
                                                                true) {
                                                              _fetchExperience();
                                                              setState(() {});
                                                            }
                                                          },
                                                          icon:
                                                              Icon(Icons.edit),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      child: Text(
                                                        "${DateTime.parse(experience['time_from'].toString()).year}/"
                                                        "${DateTime.parse(experience['time_from'].toString()).month} - "
                                                        "${DateTime.parse(experience['time_to'].toString()).year}/"
                                                        "${DateTime.parse(experience['time_to'].toString()).month}",
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            height: 300,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Học vấn',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        final result = await Get.toNamed(
                                            '/insertEducation');
                                        if (result == true) {
                                          _fetchEducation();
                                          setState(() {});
                                        }
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ),
                                isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : Expanded(
                                        child: ListView.builder(
                                          padding: EdgeInsets.only(bottom: 50),
                                          shrinkWrap: true,
                                          itemCount: _allEducation.length,
                                          itemBuilder: (context, index) {
                                            var education =
                                                _allEducation[index];
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0, bottom: 10),
                                              child: Container(
                                                height: 100,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Colors.grey[200],
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child: Image(
                                                              image: AssetImage(
                                                                  'assets/images/education.jpg'),
                                                              width: 60,
                                                              height: 60,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                education[
                                                                    'name'],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Text(education[
                                                                  'career']),
                                                            ],
                                                          ),
                                                        ),
                                                        IconButton(
                                                          onPressed: () async {
                                                            final result =
                                                                await Get.toNamed(
                                                                    '/updateEducation',
                                                                    arguments:
                                                                        education);
                                                            if (result ==
                                                                true) {
                                                              setState(() {
                                                                _fetchEducation();
                                                              });
                                                            }
                                                          },
                                                          icon:
                                                              Icon(Icons.edit),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      child: Text(
                                                        "${DateTime.parse(education['time_from'].toString()).year}/"
                                                        "${DateTime.parse(education['time_from'].toString()).month} - "
                                                        "${DateTime.parse(education['time_to'].toString()).year}/"
                                                        "${DateTime.parse(education['time_to'].toString()).month}",
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: SizedBox(
                            height: 630,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white),
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Kỹ năng',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            IconButton(
                                              onPressed: () async {
                                                final result =
                                                    await Get.toNamed(
                                                        '/insertSkill');
                                                if (result == true) {
                                                  _fetchSkill();
                                                  setState(() {});
                                                }
                                              },
                                              icon: Icon(
                                                Icons.add,
                                                size: 30,
                                              ),
                                            ),
                                          ],
                                        ),
                                        isLoading
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator())
                                            : ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                padding:
                                                    EdgeInsets.only(bottom: 00),
                                                itemCount: _allSkill.length,
                                                itemBuilder: (context, index) {
                                                  final skill =
                                                      _allSkill[index];
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          color:
                                                              Colors.grey[200]),
                                                      child: ListTile(
                                                        title: Text(
                                                            skill['nameSkill']),
                                                        subtitle:
                                                            RatingBar.builder(
                                                          initialRating:
                                                              skill['rating']
                                                                  .toDouble(),
                                                          ignoreGestures: true,
                                                          direction:
                                                              Axis.horizontal,
                                                          allowHalfRating:
                                                              false,
                                                          itemCount: 5,
                                                          itemSize: 20,
                                                          itemBuilder:
                                                              (context, _) =>
                                                                  const Icon(
                                                            Icons.star,
                                                            color: Colors.amber,
                                                          ),
                                                          onRatingUpdate:
                                                              (rating) {},
                                                        ),
                                                        trailing: IconButton(
                                                          onPressed: () async {
                                                            final result =
                                                                await Get.toNamed(
                                                                    '/updateSkill',
                                                                    arguments:
                                                                        skill);
                                                            if (result ==
                                                                true) {
                                                              _fetchSkill();
                                                              setState(() {});
                                                            }
                                                          },
                                                          icon:
                                                              Icon(Icons.edit),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Container(
                                    height: 300,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white),
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Chứng chỉ',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            IconButton(
                                              onPressed: () async {
                                                final result =
                                                    await Get.toNamed(
                                                        '/insertCertificate');
                                                if (result == true) {
                                                  _fetchCertificate();
                                                  setState(() {});
                                                }
                                              },
                                              icon: Icon(
                                                Icons.add,
                                                size: 30,
                                              ),
                                            ),
                                          ],
                                        ),
                                        isLoading
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator())
                                            : ListView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                padding:
                                                    EdgeInsets.only(bottom: 00),
                                                shrinkWrap: true,
                                                itemCount:
                                                    _allCertificate.length,
                                                itemBuilder: (context, index) {
                                                  final certificate =
                                                      _allCertificate[index];
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5.0,
                                                            bottom: 10),
                                                    child: Container(
                                                      height: 100,
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: Colors.grey[200],
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  child: Image(
                                                                    image: AssetImage(
                                                                        'assets/images/certificate.jpg'),
                                                                    width: 60,
                                                                    height: 60,
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      certificate[
                                                                          'nameCertificate'],
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    Text(certificate[
                                                                        'nameHost']),
                                                                  ],
                                                                ),
                                                              ),
                                                              IconButton(
                                                                onPressed:
                                                                    () async {
                                                                  final result = await Get.toNamed(
                                                                      '/updateCertificate',
                                                                      arguments:
                                                                          certificate);
                                                                  if (result ==
                                                                      true) {
                                                                    _fetchCertificate();
                                                                    setState(
                                                                        () {});
                                                                  }
                                                                },
                                                                icon: Icon(
                                                                    Icons.edit),
                                                              ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 10),
                                                            child: Text(
                                                              "${DateTime.parse(certificate['time_from'].toString()).year}/"
                                                              "${DateTime.parse(certificate['time_from'].toString()).month} - "
                                                              "${DateTime.parse(certificate['time_to'].toString()).year}/"
                                                              "${DateTime.parse(certificate['time_to'].toString()).month}",
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SingleChildScrollView(
                            child: Container(
                              height: 500,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Thông tin cá nhân',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          await Get.toNamed(
                                              '/updateInformation');
                                        },
                                        icon: const Icon(
                                          Icons.edit_outlined,
                                          size: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_month_rounded,
                                          size: 30, color: Colors.grey),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Ngày sinh',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          Text(
                                            "${DateTime.parse(controller.userModel.value.birthday.toString()).year}/"
                                            "${DateTime.parse(controller.userModel.value.birthday.toString()).month}/"
                                            "${DateTime.parse(controller.userModel.value.birthday.toString()).day}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.person,
                                          size: 30, color: Colors.grey),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Giới tính',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          Text(
                                            controller.userModel.value.gender
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.email,
                                          size: 30, color: Colors.grey),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Email',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          Text(
                                            controller.userModel.value.email
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.phone,
                                          size: 30, color: Colors.grey),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Số điện thoại',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          Text(
                                            controller.userModel.value.phone
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.person,
                                          size: 30, color: Colors.grey),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Mức lương',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          Text(
                                            '${controller.userModel.value.salaryFrom} - ${controller.userModel.value.salaryTo} Triệu',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          size: 30, color: Colors.grey),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Số năm kinh nghiệm',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          Text(
                                            controller
                                                .userModel.value.experience
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          size: 30, color: Colors.grey),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Địa chỉ',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          Text(
                                            controller.userModel.value.address
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
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }),
        ));
  }

  Image imageFromBase64String(String base64String) {
    if (base64String.isEmpty || base64String == 'null') {
      return const Image(
        image: AssetImage('assets/images/user.png'),
        width: 70,
        height: 70,
        fit: BoxFit.cover,
      );
    }
    try {
      return Image.memory(
        base64Decode(base64String),
        width: 70,
        height: 70,
        fit: BoxFit.fitWidth,
      );
    } catch (e) {
      print('Error decoding Base64 image: $e');
      return const Image(
        image: AssetImage('assets/images/user.png'),
        width: 70,
        height: 70,
        fit: BoxFit.cover,
      );
    }
  }

  Future<void> _takePhotoGallery() async {
    print('chọn ảnh');
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    print(controller.userModel.value.id);
    int id = int.parse(controller.userModel.value.id.toString());
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      List<int> imageBytes = File(_image!.path).readAsBytesSync();
      base64String = base64Encode(imageBytes);
      print(base64String);
    }

    try {
      await Database().updateImageUser(id, base64String!);
      if (base64String != null && base64String!.isNotEmpty) {
        await Database().updateImageUser(id, base64String!);

        controller.userModel.value = controller.userModel.value.copyWith(
          image: base64String,
        );
        await controller.saveUserData(controller.userModel.value);
      }
    } catch (e) {
      print('Cập nhật ảnh thất bại: $e');
    }
  }
}
