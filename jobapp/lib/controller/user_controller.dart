import 'package:get/get.dart';
import 'package:jobapp/server/database.dart';

import '../models/user_data.dart';
import '../ui/auth/auth_controller.dart';

class UserController extends GetxController {
  AuthController controller = Get.find<AuthController>();

  var isSwitchStatus = false.obs;
  var isSwitchContact = false.obs;
  var isSwitchDetail = false.obs;
  var isSwitchMore = false.obs;
  var isScroll = false.obs;
  var favoriteCount = 0.obs;
  var linkfb = ''.obs;

  Map<String, dynamic> data = {};
  var user = Rxn<UserModel>();
  var isLoading = false.obs;

  Future<void> getUserData(int uid) async {
    try {
      isLoading(true);
      Map<String, dynamic> userData = await Database().fetchContactStatus(uid);
      isSwitchContact.value = userData['contact_status'];
      linkfb.value = userData['link'];
    } catch (e) {
      print("Error fetching user data: $e");
    } finally {
      isLoading(false);
    }
  }
}
