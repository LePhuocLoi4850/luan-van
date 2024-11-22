import 'package:get/get.dart';
import 'package:jobapp/server/database.dart';

import '../ui/auth/auth_controller.dart';

class CompanyController extends GetxController {
  AuthController controller = Get.find<AuthController>();
  RxInt countPostJob = 0.obs;
  RxInt countUserApply = 0.obs;

  Future<void> countJob(int cid) async {
    try {
      final jobCount =
          await Database().countJobForCid(controller.companyModel.value.id!);
      countPostJob.value = jobCount;
    } catch (e) {
      print('Lỗi khi đếm số job: $e');
    }
  }

  Future<void> countUser(int cid) async {
    try {
      final userCount =
          await Database().countUserForCid(controller.companyModel.value.id!);
      countUserApply.value = userCount;
    } catch (e) {
      print('Lỗi khi đếm số job: $e');
    }
  }

  Future<void> addCountJob() async {
    countPostJob.value++;
  }
}
