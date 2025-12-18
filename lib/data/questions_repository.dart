import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/question_model.dart';
import '../models/paper_model.dart'; // Certifique-se de ter criado este model

class QuestionsRepository {
  List<QuizQuestion> _allQuestions = [];

  // --- MODO TREINO (Aleatório) ---

  // Carrega questões de um path específico (ex: 'assets/questions.json')
  Future<void> loadQuestions(String assetPath) async {
    try {
      final String response = await rootBundle.loadString(assetPath);
      final List<dynamic> data = json.decode(response);
      _allQuestions = data.map((item) => QuizQuestion.fromJson(item)).toList();
    } catch (e) {
      print("Erro ao carregar questões de $assetPath: $e");
      _allQuestions = []; 
    }
  }

  // Sorteia uma sessão baseada nas questões carregadas acima
  List<QuizQuestion> getQuizSession({
    int numberOfQuestions = 10,
    QuestionCategory? categoryFilter,
  }) {
    if (_allQuestions.isEmpty) return [];
    
    // 1. Filtra se houver categoria selecionada
    var list = _allQuestions;
    if (categoryFilter != null) {
      list = list.where((q) => q.category == categoryFilter).toList();
    }

    if (list.isEmpty) return [];

    // 2. Cria cópia e embaralha
    var shuffledList = List<QuizQuestion>.from(list);
    shuffledList.shuffle();
    
    // 3. Pega a quantidade pedida
    int count = numberOfQuestions > shuffledList.length ? shuffledList.length : numberOfQuestions;
    
    return shuffledList.take(count).toList();
  }

  // --- MODO PAPERS (Estudo Dirigido) ---

  // Carrega a lista de papers e suas questões aninhadas
  Future<List<StudyPaper>> loadPapers() async {
    try {
      // O arquivo deve estar registrado no pubspec.yaml
      final String response = await rootBundle.loadString('assets/papers.json');
      final List<dynamic> data = json.decode(response);
      return data.map((item) => StudyPaper.fromJson(item)).toList();
    } catch (e) {
      print("Erro ao carregar papers: $e");
      return [];
    }
  }
}