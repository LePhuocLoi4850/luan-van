import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../server/database.dart';

class CvProfileScreen extends StatefulWidget {
  const CvProfileScreen({super.key});

  @override
  State<CvProfileScreen> createState() => _CvProfileScreenState();
}

class _CvProfileScreenState extends State<CvProfileScreen> {
  // AuthController controller = Get.find<AuthController>();
  List<Map<String, dynamic>> _allEducation = [];
  List<Map<String, dynamic>> _allExperience = [];
  List<Map<String, dynamic>> _allCertificate = [];
  List<Map<String, dynamic>> _allSkill = [];
  Map<String, dynamic> userData = {};
  bool isLoading = false;
  int id = 0;
  @override
  void initState() {
    super.initState();
    id = Get.arguments;
    _fetchData();
  }

  void _fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      await _fetchEducation();
      await _fetchExperience();
      await _fetchCertificate();
      await _fetchSkill();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _fetchEducation() async {
    int uid = id;
    try {
      _allEducation = await Database().fetchEducation(uid);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _fetchExperience() async {
    int uid = id;
    try {
      _allExperience = await Database().fetchExperience(uid);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _fetchCertificate() async {
    int uid = id;
    try {
      _allCertificate = await Database().fetchCertificate(uid);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _fetchSkill() async {
    int uid = id;
    try {
      userData = await Database().fetchUserDataForUid(uid);
      _allSkill = await Database().fetchSkill(uid);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('CV Profile'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              color: Colors.white,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: ClipOval(
                                      child: Container(
                                        width: 130,
                                        height: 130,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: imageFromBase64String(
                                          userData['image'].toString(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userData['name'],
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Information(
                                        icon: Icon(
                                          Icons.cake,
                                          color: Colors.blue,
                                        ),
                                        data: DateFormat('yyyy-MM-dd')
                                            .format(userData['birthday']),
                                      ),
                                      Information(
                                        icon: Icon(
                                          Icons.email,
                                          color: Colors.blue,
                                        ),
                                        data: userData['email'],
                                      ),
                                      Information(
                                        icon: Icon(
                                          Icons.phone,
                                          color: Colors.blue,
                                        ),
                                        data: userData['phone'],
                                      ),
                                      Information(
                                        icon: Icon(
                                          Icons.location_on_rounded,
                                          color: Colors.blue,
                                        ),
                                        data: userData['address'],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            child: Container(
                              color: Colors.white,
                              padding: EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Học vấn',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Center(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: _allEducation.length,
                                        itemBuilder: (context, index) {
                                          var education = _allEducation[index];
                                          return Row(
                                            children: [
                                              Image(
                                                image: AssetImage(
                                                    'assets/images/education.jpg'),
                                                width: 80,
                                                height: 80,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    education['name'],
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    education['career'],
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    '${DateFormat('yyyy-MM-dd').format(education['time_from'])} - ${DateFormat('yyyy-MM-dd').format(education['time_to'])}',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Colors.grey[500]),
                                                  ),
                                                ],
                                              )
                                            ],
                                          );
                                        }),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              color: Colors.white,
                              padding: EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Kỹ năng',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Center(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: _allSkill.length,
                                        itemBuilder: (context, index) {
                                          var skill = _allSkill[index];
                                          return Row(
                                            children: [
                                              Image(
                                                image: AssetImage(
                                                    'assets/images/skill.jpg'),
                                                width: 80,
                                                height: 80,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    skill['nameSkill'],
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  RatingBar.builder(
                                                    initialRating:
                                                        skill['rating']
                                                            .toDouble(),
                                                    ignoreGestures: true,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: false,
                                                    itemCount: 5,
                                                    itemSize: 20,
                                                    itemBuilder: (context, _) =>
                                                        const Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                    onRatingUpdate: (rating) {},
                                                  ),
                                                ],
                                              )
                                            ],
                                          );
                                        }),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              color: Colors.white,
                              padding: EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Chứng chỉ',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Center(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: _allCertificate.length,
                                        itemBuilder: (context, index) {
                                          var certificate =
                                              _allCertificate[index];
                                          return Row(
                                            children: [
                                              Image(
                                                image: AssetImage(
                                                    'assets/images/certificate.jpg'),
                                                width: 80,
                                                height: 80,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    certificate[
                                                        'nameCertificate'],
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    certificate['nameHost'],
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    '${DateFormat('yyyy-MM-dd').format(certificate['time_from'])} - ${DateFormat('yyyy-MM-dd').format(certificate['time_to'])}',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Colors.grey[500]),
                                                  ),
                                                ],
                                              )
                                            ],
                                          );
                                        }),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            child: Container(
                              color: Colors.white,
                              padding: EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Kinh nghiệm',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Center(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: _allExperience.length,
                                        itemBuilder: (context, index) {
                                          var experience =
                                              _allExperience[index];
                                          return Row(
                                            children: [
                                              Image(
                                                image: AssetImage(
                                                    'assets/images/experience.jpg'),
                                                width: 80,
                                                height: 80,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    experience['nameCompany'],
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(experience['position'],
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  Text(
                                                    '${DateFormat('yyyy-MM-dd').format(experience['time_from'])} - ${DateFormat('yyyy-MM-dd').format(experience['time_to'])}',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Colors.grey[500]),
                                                  ),
                                                ],
                                              )
                                            ],
                                          );
                                        }),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
    );
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
}

class Information extends StatelessWidget {
  final Icon icon;
  final String data;

  const Information({
    super.key,
    required this.icon,
    required this.data,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            data,
            style: TextStyle(fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}
