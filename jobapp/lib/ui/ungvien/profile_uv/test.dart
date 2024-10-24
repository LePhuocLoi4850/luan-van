import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../../../server/database.dart';
import '../../auth/auth_controller.dart';

class SkillListPage extends StatefulWidget {
  const SkillListPage({Key? key}) : super(key: key);

  @override
  State<SkillListPage> createState() => _SkillListPageState();
}

class _SkillListPageState extends State<SkillListPage> {
  final AuthController controller = Get.find<AuthController>();
  bool isLoading = true;
  List<Map<String, dynamic>> _allSkill = [];
  @override
  void initState() {
    super.initState();

    _fetchSkill();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách kỹ năng'),
      ),
      body: ListView.builder(
        itemCount: _allSkill.length,
        itemBuilder: (context, index) {
          final skill = _allSkill[index];
          return ListTile(
            title: Text(skill['nameSkill']),
            subtitle: RatingBar.builder(
              initialRating: skill['rating'].toDouble(),
              ignoreGestures: true,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemSize: 20,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {},
            ),
          );
        },
      ),
    );
  }
}
