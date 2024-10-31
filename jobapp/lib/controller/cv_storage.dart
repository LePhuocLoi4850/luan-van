// import 'package:get/get.dart';

// import '../models/cv.dart';
// import '../models/cv_storage.dart';

// class CvStorageController extends GetxController {
//   final _cvStorage = CvStorage();

//   List<CV> get cvData {
//     return _cvStorage.cvData.map((map) => CV.fromMap(map)).toList();
//   }

//   void addCv(CV cv) {
//     _cvStorage.addCv(cv.toMap());
//     update();
//   }

//   void removeCv(int cvId) {
//     _cvStorage.removeCv(cvId);
//     update();
//   }

//   void updateCvName(int cvId, String newName) {
//     _cvStorage.updateCvName(cvId, newName);
//     update();
//   }

//   void clearCvData() {
//     _cvStorage.clearCvData();
//     update();
//   }
// }
import 'package:get/get.dart';

import '../models/cv.dart';
import '../models/cv_storage.dart';

class CvStorageController extends GetxController {
  final _cvStorage = CvStorage();

  // Sử dụng RxList để Obx có thể lắng nghe thay đổi
  final _cvData = <CV>[].obs;

  List<CV> get cvData => _cvData;

  void addCv(CV cv) {
    _cvStorage.addCv(cv.toMap());
    _cvData.add(cv); // Thêm CV vào RxList
  }

  void removeCv(int cvId) {
    _cvStorage.removeCv(cvId);
    _cvData.removeWhere((cv) => cv.cvId == cvId); // Xóa CV khỏi RxList
  }

  void updateCvName(int cvId, String newName) {
    _cvStorage.updateCvName(cvId, newName);
    final index = _cvData.indexWhere((cv) => cv.cvId == cvId);
    if (index != -1) {
      _cvData[index] = _cvData[index].copyWith(nameCv: newName);
    }
  }

  void clearCvData() {
    _cvStorage.clearCvData();
    _cvData.clear(); // Xóa tất cả CV khỏi RxList
  }

  // Hàm để fetch dữ liệu CV và cập nhật vào RxList
  void fetchCvData() {
    _cvData.assignAll(_cvStorage.cvData.map((map) => CV.fromMap(map)));
  }
}
