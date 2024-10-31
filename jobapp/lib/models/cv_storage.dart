class CvStorage {
  List<Map<String, dynamic>> _cvData = [];

  List<Map<String, dynamic>> get cvData => _cvData;

  void addCv(Map<String, dynamic> cv) {
    _cvData.add(cv);
  }

  void removeCv(int cvId) {
    _cvData.removeWhere((cv) => cv['cv_id'] == cvId);
  }

  void updateCvName(int cvId, String newName) {
    final index = _cvData.indexWhere((cv) => cv['cv_id'] == cvId);
    if (index != -1) {
      _cvData[index]['nameCv'] = newName;
    }
  }

  void clearCvData() {
    _cvData.clear();
  }

  Map<String, dynamic>? getCvById(int cvId) {
    final cv =
        _cvData.firstWhere((cv) => cv['cv_id'] == cvId, orElse: () => {});
    return cv.isNotEmpty ? cv : null;
  }
}
