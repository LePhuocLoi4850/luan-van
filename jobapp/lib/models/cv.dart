class CV {
  final int cvId;
  final String nameCv;
  final String pdf;
  final DateTime time;

  CV({
    required this.cvId,
    required this.nameCv,
    required this.pdf,
    required this.time,
  });

  factory CV.fromMap(Map<String, dynamic> map) {
    return CV(
      cvId: map['cv_id'] as int,
      nameCv: map['nameCv'] as String,
      pdf: map['pdf'] as String,
      time: DateTime.parse(map['time'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cv_id': cvId,
      'nameCv': nameCv,
      'pdf': pdf,
      'time': time.toIso8601String(),
    };
  }

  CV copyWith({
    int? cvId,
    String? nameCv,
    String? pdf,
    DateTime? time,
  }) {
    return CV(
      cvId: cvId ?? this.cvId,
      nameCv: nameCv ?? this.nameCv,
      pdf: pdf ?? this.pdf,
      time: time ?? this.time,
    );
  }

  @override
  String toString() {
    return 'CV{cvId: $cvId, nameCv: $nameCv, pdf: $pdf, time: $time}';
  }
}
