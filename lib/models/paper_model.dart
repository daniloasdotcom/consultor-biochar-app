import 'question_model.dart';

class StudyPaper {
  final String id;
  final String title;
  final String author;
  final String description;
  final List<QuizQuestion> questions;

  StudyPaper({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.questions,
  });

  factory StudyPaper.fromJson(Map<String, dynamic> json) {
    var list = json['questions'] as List;
    List<QuizQuestion> questionsList = list.map((i) => QuizQuestion.fromJson(i)).toList();

    return StudyPaper(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Sem Título',
      author: json['author'] ?? 'Desconhecido',
      description: json['description'] ?? '',
      questions: questionsList,
    );
  }
}