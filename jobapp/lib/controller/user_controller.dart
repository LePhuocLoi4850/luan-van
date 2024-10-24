import 'package:get/get.dart';

import '../models/user_data.dart';
import '../ui/auth/auth_controller.dart';

class UserController extends GetxController {
  AuthController controller = Get.find<AuthController>();

  var isSwitchStatus = false.obs;
  var isSwitchContact = false.obs;
  var isSwitchDetail = false.obs;
  var isSwitchMore = false.obs;
  var isFavorite = false.obs;

  var user = Rxn<UserModel>();
  var isLoading = false.obs;

  Future<void> getUserData(String email) async {
    try {
      isLoading(true);
      final userData = controller.userModel.value;
      user.value = userData;
    } catch (e) {
      print("Error fetching user data: $e");
    } finally {
      isLoading(false);
    }
  }
}
