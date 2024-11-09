class Favorite {
  final int uid;
  final int jid;
  final int cid;
  final String title;
  final String nameC;
  final String address;
  final String experience;
  final String salaryFrom;
  final String salaryTo;
  final String image;
  final DateTime createAt;

  Favorite({
    required this.uid,
    required this.jid,
    required this.cid,
    required this.title,
    required this.nameC,
    required this.address,
    required this.experience,
    required this.salaryFrom,
    required this.salaryTo,
    required this.image,
    required this.createAt,
  });

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      uid: map['uid'] as int,
      jid: map['jid'] as int,
      cid: map['cid'] as int,
      title: map['title'] as String,
      nameC: map['nameC'] as String,
      address: map['address'] as String,
      experience: map['experience'] as String,
      salaryFrom: map['salaryFrom'] as String,
      salaryTo: map['salaryTo'] as String,
      image: map['image'] as String,
      createAt: DateTime.parse(map['create_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'jid': jid,
      'cid': cid,
      'title': title,
      'nameC': nameC,
      'address': address,
      'experience': experience,
      'salaryFrom': salaryFrom,
      'salaryTo': salaryTo,
      'image': image,
      'create_at': createAt.toIso8601String(),
    };
  }
}
