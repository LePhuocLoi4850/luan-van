import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobapp/ui/auth/auth_controller.dart';
import 'package:jobapp/ui/ungvien/home_uv/Job_gird.dart';

// Tắt overscroll indicator cho cả iOS và Android
class NoOverscrollBehavior extends ScrollBehavior {
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class HomeUV extends StatefulWidget {
  const HomeUV({super.key});

  @override
  State<HomeUV> createState() => _HomeUVState();
}

class _HomeUVState extends State<HomeUV> {
  final AuthController controller = Get.find<AuthController>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: NoOverscrollBehavior(),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              floating: false,
              expandedHeight: 100,
              elevation: 10,
              stretch: true,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1,
                titlePadding: const EdgeInsets.only(left: 10),
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Obx(() {
                    return Row(
                      children: [
                        ClipOval(
                          child: imageFromBase64String(
                            controller.userModel.value.image.toString(),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text.rich(
                          TextSpan(
                            text: 'Hello ',
                            style: const TextStyle(fontSize: 18),
                            children: <InlineSpan>[
                              TextSpan(
                                text: '${controller.userModel.value.name}!',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  }),
                ),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.white],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.1, 1],
                    ),
                  ),
                ),
                centerTitle: true,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 1090,
                color: Colors.white,
                child: JobGird(),
              ),
            )
          ],
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
