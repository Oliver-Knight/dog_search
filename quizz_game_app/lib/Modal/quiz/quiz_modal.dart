class QuizModal {
  int? id;
  String title;
  String description;
  String date;
  String photo;

  QuizModal({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.photo,
  });

  QuizModal copyWith({
    int? id,
    required String title,
    required String description,
    required String date,
    required String photo,
  }) =>
      QuizModal(
        title: title,
        description: description,
        date: date,
        photo: photo,
      );

  Map<String, dynamic> toMap() => {
        'title': title,
        'description': description,
        'date': date,
        'photo': photo,
      };

  factory QuizModal.fromMap(Map<String, dynamic> data) => QuizModal(
        id : data['id'],
        title: data['title'],
        description: data['description'],
        date: data['date'],
        photo: data['photo'],
      );
}
