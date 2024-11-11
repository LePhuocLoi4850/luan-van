class Calender {
  final int cldId;
  final int cid;
  final String name;
  final String address;
  final DateTime date;
  final String time;

  Calender({
    required this.cldId,
    required this.cid,
    required this.name,
    required this.address,
    required this.date,
    required this.time,
  });

  factory Calender.fromMap(Map<String, dynamic> map) {
    return Calender(
      cldId: map['cldId'] as int,
      cid: map['cid'] as int,
      name: map['name'] as String,
      address: map['address'] as String,
      date: DateTime.parse(map['date'] as String),
      time: map['name'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cld_id': cldId,
      'cid': cid,
      'name': name,
      'address': address,
      'date': date.toIso8601String(),
      'time': time,
    };
  }

  Calender copyWith({
    int? cldId,
    int? cid,
    String? name,
    String? address,
    DateTime? date,
    String? time,
  }) {
    return Calender(
      cid: cid ?? this.cid,
      cldId: cldId ?? this.cldId,
      name: name ?? this.name,
      address: address ?? this.address,
      date: date ?? this.date,
      time: time ?? this.time,
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
