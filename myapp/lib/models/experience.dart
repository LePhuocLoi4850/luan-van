class Experience {
  final String? id;
  final String name;
  bool isSelected;

  Experience({
    this.id,
    required this.name,
    this.isSelected = false,
  });

  Experience copyWith({
    String? id,
    String? name,
    bool? isSelected,
  }) {
    return Experience(
      id: id ?? this.id,
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  static Experience fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'],
      name: json['name'],
    );
  }
}

class ExperienceManager {
  final List<Experience> allExperience = [
    Experience(name: 'Không yêu cầu'),
    Experience(name: 'Dưới 1 năm'),
    Experience(name: '1 - 3 năm'),
    Experience(name: '3 - 5 năm'),
    Experience(name: 'Trên 5 năm'),
  ];

  void selectExperience(String experienceName) {
    for (var experience in allExperience) {
      if (experience.name == experienceName) {
        experience.isSelected = !experience.isSelected;
      }
    }
  }
}
