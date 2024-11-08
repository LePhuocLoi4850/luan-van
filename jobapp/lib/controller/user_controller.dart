import 'package:get/get.dart';
import 'package:jobapp/server/database.dart';

import '../models/favorites.dart';
import '../models/user_data.dart';
import '../ui/auth/auth_controller.dart';

class UserController extends GetxController {
  AuthController controller = Get.find<AuthController>();

  var isSwitchStatus = false.obs;
  var isSwitchContact = false.obs;
  var isSwitchDetail = false.obs;
  var isSwitchMore = false.obs;
  var favoriteCount = 0.obs;
  var favoriteJobs = <Favorite>[].obs;
  var user = Rxn<UserModel>();
  var isLoading = false.obs;

  Future<void> addFavoriteJob(
      int uid,
      int jid,
      int cid,
      String title,
      String name,
      String address,
      String experienceJ,
      String salaryFromJ,
      String salaryToJ,
      String image,
      DateTime createAt) async {
    final favorite = Favorite(
      uid: uid,
      jid: jid,
      cid: cid,
      title: title,
      name: name,
      address: address,
      experienceJ: experienceJ,
      salaryFromJ: salaryFromJ,
      salaryToJ: salaryToJ,
      image: image,
      createAt: DateTime.now(),
    );
    favoriteJobs.add(favorite);
    _printFavorites();
    Database().addFavorites(uid, jid, cid, title, name, address, experienceJ,
        salaryFromJ, salaryToJ, image, createAt);
    favoriteCount.value++;
  }

  Future<void> removeFavoriteJob(int uid, int jid) async {
    favoriteJobs
        .removeWhere((favorite) => favorite.uid == uid && favorite.uid == jid);
    _printFavorites();
    Database().removeFavorites(uid, jid);
    favoriteCount.value--;
  }

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

  Future<void> clearFavorites() async {
    int uid = controller.userModel.value.id!;
    favoriteJobs.removeWhere((favorite) => favorite.uid == uid);
    print('clear favorites thành công');
    _printFavorites();
  }

  void _printFavorites() {
    for (var favorite in favoriteJobs) {
      print('uid: ${favorite.uid}, jobId: ${favorite.jid}');
    }
  }
}
