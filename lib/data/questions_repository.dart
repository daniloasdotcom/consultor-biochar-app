import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/question_model.dart';

class QuestionsRepository {
  List<QuizQuestion> _allQuestions = [];

  // Carrega o JSON dos assets
  Future<void> loadQuestions() async {
    try {
      final String response = await rootBundle.loadString('assets/questions.json');
      final List<dynamic> data = json.decode(response);
      _allQuestions = data.map((item) => QuizQuestion.fromJson(item)).toList();
    } catch (e) {
      print("Erro ao carregar questões: $e");
      // Em produção, você trataria esse erro melhor
      _allQuestions = []; 
    }
  }

  // Retorna uma sessão de quiz aleatória
  List<QuizQuestion> getQuizSession({
    int numberOfQuestions = 10,
    QuestionCategory? categoryFilter, // Novo parâmetro (null = todas)
  }) {
    if (_allQuestions.isEmpty) return [];
    
    // 1. Filtra se houver categoria selecionada
    var list = _allQuestions;
    if (categoryFilter != null) {
      list = list.where((q) => q.category == categoryFilter).toList();
    }

    // Se não houver questões nessa categoria (segurança)
    if (list.isEmpty) return [];

    // 2. Cria cópia e embaralha
    var shuffledList = List<QuizQuestion>.from(list);
    shuffledList.shuffle();
    
    // 3. Pega a quantidade pedida (ou o máximo disponível naquela categoria)
    int count = numberOfQuestions > shuffledList.length ? shuffledList.length : numberOfQuestions;
    
    return shuffledList.take(count).toList();
  }
}