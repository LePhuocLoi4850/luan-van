class Favorite {
  final int uid;
  final int jid;
  final int cid;
  final String title;
  final String name;
  final String address;
  final String experienceJ;
  final String salaryFromJ;
  final String salaryToJ;
  final String image;
  final DateTime createAt;

  Favorite({
    required this.uid,
    required this.jid,
    required this.cid,
    required this.title,
    required this.name,
    required this.address,
    required this.experienceJ,
    required this.salaryFromJ,
    required this.salaryToJ,
    required this.image,
    required this.createAt,
  });

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      uid: map['uid'] as int,
      jid: map['jid'] as int,
      cid: map['cid'] as int,
      title: map['title'] as String,
      name: map['name'] as String,
      address: map['address'] as String,
      experienceJ: map['experienceJ'] as String,
      salaryFromJ: map['salaryFromJ'] as String,
      salaryToJ: map['salaryToJ'] as String,
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
      'name': name,
      'address': address,
      'experienceJ': experienceJ,
      'salaryFromJ': salaryFromJ,
      'salaryToJ': salaryToJ,
      'image': image,
      'create_at': createAt.toIso8601String(),
    };
  }
}
