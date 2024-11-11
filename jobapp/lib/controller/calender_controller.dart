import 'package:get/get.dart';
import 'package:jobapp/models/calender.dart';

class CalenderController extends GetxController {
  final _calenderManager = CalenderManager();

  final _calenderData = <Calender>[].obs;

  List<Calender> get calenderData => _calenderData;
  bool isLoad = true;
  void addCld(Calender cld) {
    _calenderManager.addCld(cld.toMap());
    _calenderData.add(cld);
  }

  void removeCld(int cldId) {
    _calenderManager.removeCld(cldId);
    _calenderData.removeWhere((cld) => cld.cldId == cldId);
  }

  void updateCldName(int cldId, String newName) {
    _calenderManager.updateCldName(cldId, newName);
    final index = _calenderData.indexWhere((cld) => cld.cldId == cldId);
    if (index != -1) {
      _calenderData[index] = _calenderData[index].copyWith(name: newName);
    }
  }

  void clearCldData() {
    _calenderManager.clearCldData();
    _calenderData.clear();
  }

  void fetchCldData() {
    _calenderData.assignAll(
        _calenderManager.calenderData.map((map) => Calender.fromMap(map)));
  }
}
