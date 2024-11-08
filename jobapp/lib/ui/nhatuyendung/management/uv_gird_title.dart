import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
// import 'package:intl/intl.dart';

import '../../auth/auth_controller.dart';

class UVGirdTitle extends StatefulWidget {
  final Map<String, dynamic> girdUV;
  final VoidCallback onStatusChanged;

  const UVGirdTitle(
      {required this.girdUV, required this.onStatusChanged, super.key});

  @override
  State<UVGirdTitle> createState() => _UVGirdTitleState();
}

bool isFavorite = false;

class _UVGirdTitleState extends State<UVGirdTitle> {
  AuthController controller = Get.find<AuthController>();
  List<dynamic> application = [];
  String textStatus = 'Ứng tuyển';

  @override
  void initState() {
    super.initState();
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
    return GestureDetector(
      onTap: () async {
        Map<String, dynamic> data = {
          'uid': widget.girdUV['uid'],
          'status': widget.girdUV['status'],
          'jid': widget.girdUV['jid'],
          'cv_id': widget.girdUV['cv_id'],
          'nameCv': widget.girdUV['nameCv']
        };

        final result = await Get.toNamed('/uvDetail', arguments: data);
        if (result == 'accepted' || result == 'rejected') {
          widget.onStatusChanged();
        }
      },
      child: Card(
        color: Colors.white,
        elevation: 5.0,
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
                    ),
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
                            color: Colors.amber,
                            size: 23,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 5.0, top: 3),
                            child: Text(
                              '20',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Color.fromARGB(255, 158, 155, 145)),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const FaIcon(
                            FontAwesomeIcons.venusMars,
                            color: Colors.amber,
                            size: 18,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0, top: 3),
                            child: Text(
                              widget.girdUV['gender'],
                              style: const TextStyle(
                                  fontSize: 17,
                                  color: Color.fromARGB(255, 158, 141, 84)),
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
                      const Icon(Icons.co_present_rounded,
                          color: Colors.orange),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(widget.girdUV['career']),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.share_location_outlined,
                        color: Colors.orange,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          widget.girdUV['address'],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '$textStatus:',
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        widget.girdUV['title'],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
