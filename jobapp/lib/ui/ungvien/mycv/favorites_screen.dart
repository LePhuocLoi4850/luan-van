import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../../controller/user_controller.dart';
import '../../../server/database.dart';
import '../../auth/auth_controller.dart';
import '../home_uv/job_gird_title_vertical.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final AuthController controller = Get.find<AuthController>();
  final UserController userController = Get.find<UserController>();

  List<Map<String, dynamic>> _allJobs = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchAllJobs();
  }

  void _fetchAllJobs() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    int uid = controller.userModel.value.id!;
    _allJobs = await Database().fetchAllJobFavoriteForUid(uid);
    setState(() {});
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Công việc yêu thích'),
      ),
      body: isLoading
          ? const Center(
              child: SpinKitChasingDots(
                color: Colors.blue,
                size: 50.0,
              ),
            )
          : SingleChildScrollView(
              child: SizedBox(
                height: 415,
                child: GestureDetector(
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)),
                      child: JobGirdTitleVertical(
                        allJobs: _allJobs,
                      )),
                ),
              ),
            ),
    );
  }
}
