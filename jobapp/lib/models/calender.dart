class Calender {
  final int cldId;
  final int cid;
  final String name;
  final String address;
  final String time;
  final DateTime createAt;
  final String? note;

  Calender({
    required this.cldId,
    required this.cid,
    required this.name,
    required this.address,
    required this.time,
    required this.createAt,
    this.note,
  });

  factory Calender.fromMap(Map<String, dynamic> map) {
    return Calender(
      cldId: map['cld_id'] as int,
      cid: map['cid'] as int,
      name: map['name'] as String,
      address: map['address'] as String,
      time: map['time'] as String,
      createAt: map['createAt'],
      note: map['note'] != null ? map['note'] as String : '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cld_id': cldId,
      'cid': cid,
      'name': name,
      'address': address,
      'time': time,
      'createAt': createAt.toIso8601String(),
      'note': note,
    };
  }

  Calender copyWith(
      {int? cldId,
      int? cid,
      String? name,
      String? address,
      String? time,
      DateTime? createAt,
      String? note}) {
    return Calender(
      cid: cid ?? this.cid,
      cldId: cldId ?? this.cldId,
      name: name ?? this.name,
      address: address ?? this.address,
      time: time ?? this.time,
      createAt: createAt ?? this.createAt,
      note: note ?? this.note,
    );
  }
}

class CalenderManager {
  List<Map<String, dynamic>> _calenderData = [];

  List<Map<String, dynamic>> get calenderData => _calenderData;

  void addCld(Map<String, dynamic> cld) {
    _calenderData.add(cld);
  }

  void removeCld(int cldId) {
    _calenderData.removeWhere((cld) => cld['cld_id'] == cldId);
  }

  void updateCldName(int cldId, String newName) {
    final index = _calenderData.indexWhere((cld) => cld['cld_id'] == cldId);
    if (index != -1) {
      _calenderData[index]['name'] = newName;
    }
  }

  void clearCldData() {
    _calenderData.clear();
  }
}
