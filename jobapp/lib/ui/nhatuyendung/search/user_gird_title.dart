import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../auth/auth_controller.dart';

class UserGirdTitle extends StatefulWidget {
  final Map<String, dynamic> girdUV;

  const UserGirdTitle({required this.girdUV, super.key});

  @override
  State<UserGirdTitle> createState() => _UserGirdTitleState();
}

bool isFavorite = false;

class _UserGirdTitleState extends State<UserGirdTitle> {
  AuthController controller = Get.find<AuthController>();
  List<dynamic> application = [];
  String textStatus = 'Ứng tuyển';
  int age = 0;
  String salary = '';
  @override
  void initState() {
    super.initState();
    age = calculateAge(widget.girdUV['birthday']);
    salary =
        '${widget.girdUV['salaryFrom']} - ${widget.girdUV['salaryTo']} Triệu';
  }

  int calculateAge(DateTime birthday) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthday.year;
    if (currentDate.month < birthday.month ||
        (currentDate.month == birthday.month &&
            currentDate.day < birthday.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Get.toNamed('/uvDetailScreen', arguments: widget.girdUV['uid']);
      },
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Colors.grey)),
        color: Colors.white,
        elevation: 3.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey)),
                    child: ClipOval(
                      child: imageFromBase64String(
                        widget.girdUV['image'],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text(
                              widget.girdUV['name'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                isFavorite = !isFavorite;
                              });
                            },
                            icon: FaIcon(isFavorite
                                ? FontAwesomeIcons.solidHeart
                                : FontAwesomeIcons.heart),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.cake_rounded,
                            color: Colors.blue,
                            size: 23,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5.0, top: 3),
                            child: Text(
                              '$age tuổi',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                          const FaIcon(
                            FontAwesomeIcons.venusMars,
                            color: Colors.blue,
                            size: 18,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0, top: 3),
                            child: Text(
                              widget.girdUV['gender'],
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          )
                        ],
                      )
                    ],
                  ))
                ],
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.sticky_note_2, color: Colors.blue),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          widget.girdUV['career'],
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.attach_money_outlined,
                              color: Colors.blue),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text(salary,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                          )
                        ],
                      ),
                      const SizedBox(width: 40),
                      Row(
                        children: [
                          const Icon(
                            Icons.share_location,
                            color: Colors.blue,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text(
                              widget.girdUV['address'],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Divider(),
              Row(
                children: [
                  Text('ngày cập nhật: '),
                  Text(DateFormat('dd/MM/yyyy')
                      .format(widget.girdUV['create_at'])),
                ],
              )
            ],
          ),
        ),
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
}
