import 'package:get/get.dart';

import '../models/cv.dart';
import '../models/cv_storage.dart';

class CvStorageController extends GetxController {
  final _cvStorage = CvStorage();

  final _cvData = <CV>[].obs;

  List<CV> get cvData => _cvData;
  bool isLoad = true;
  void addCv(CV cv) {
    _cvStorage.addCv(cv.toMap());
    _cvData.add(cv);
  }

  void removeCv(int cvId) {
    _cvStorage.removeCv(cvId);
    _cvData.removeWhere((cv) => cv.cvId == cvId);
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
    _cvData.clear();
  }

  void fetchCvData() {
    _cvData.assignAll(_cvStorage.cvData.map((map) => CV.fromMap(map)));
  }
}
