class Job {
  final int id;
  final String name;
  final String image;
  final double salary;
  final String category;
  final String address;
  final int quantity;
  final String schedule;
  final String gender;
  final String age;
  final String education;
  final String experience;
  final String career;
  final String description;
  final String otherRequirements;
  final String benefits;
  final int creatorId;

  Job({
    required this.id,
    required this.name,
    required this.image,
    required this.salary,
    required this.category,
    required this.address,
    required this.quantity,
    required this.schedule,
    required this.gender,
    required this.age,
    required this.education,
    required this.experience,
    required this.career,
    required this.description,
    required this.otherRequirements,
    required this.benefits,
    required this.creatorId,
  });

  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      salary: map['salary'],
      category: map['category'],
      address: map['address'],
      quantity: map['quantity'],
      schedule: map['schedule'],
      gender: map['gender'],
      age: map['age'],
      education: map['education'],
      experience: map['experience'],
      career: map['career'],
      description: map['description'],
      otherRequirements: map['other_req'],
      benefits: map['benefits'],
      creatorId: map['creator_id'],
    );
  }
}
