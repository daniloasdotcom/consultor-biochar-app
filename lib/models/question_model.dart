// lib/models/question_model.dart

// 1. ATUALIZAÇÃO DAS CATEGORIAS
// Adicionei 'engenharia', 'seguranca', 'mercado' e 'tecnologia'
// para cobrir as novas questões do JSON (IDs 21 a 30).
enum QuestionCategory { 
  regulamentacao, 
  producao, 
  quimica, 
  processo, 
  carbono, 
  agronomia, 
  risco, 
  certificacao, 
  aplicacao, 
  consultoria, 
  engenharia, // Novo (Q21)
  seguranca,  // Novo (Q22)
  mercado,    // Novo (Q23)
  tecnologia, // Novo (Q30)
  geral 
}

// 2. ATUALIZAÇÃO DA DIFICULDADE
// Mantive a estrutura que já suporta 'muito_dificil'
enum Difficulty { 
  facil, 
  medio, 
  dificil, 
  muitoDificil 
}

class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  final QuestionCategory category;
  final Difficulty difficulty;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    this.category = QuestionCategory.geral,
    this.difficulty = Difficulty.medio,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] ?? '',
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswerIndex: json['correctAnswerIndex'] ?? 0,
      explanation: json['explanation'] ?? '',
      
      // Mapeamento automático:
      // Agora o enum contém as novas categorias, então o match funcionará corretamente.
      category: QuestionCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => QuestionCategory.geral,
      ),
      
      // Helper de dificuldade
      difficulty: _parseDifficulty(json['difficulty']),
    );
  }

  static Difficulty _parseDifficulty(String? value) {
    switch (value) {
      case 'facil': 
        return Difficulty.facil;
      case 'medio': 
        return Difficulty.medio;
      case 'dificil': 
        return Difficulty.dificil;
      case 'muito_dificil': 
        return Difficulty.muitoDificil;
      default: 
        return Difficulty.medio;
    }
  }
}

// No final do arquivo question_model.dart, fora da classe QuizQuestion

extension CategoryExtension on QuestionCategory {
  String get displayName {
    switch (this) {
      case QuestionCategory.regulamentacao: return 'Regulamentação';
      case QuestionCategory.producao: return 'Produção';
      case QuestionCategory.quimica: return 'Química';
      case QuestionCategory.processo: return 'Processo Térmico';
      case QuestionCategory.carbono: return 'Créditos de Carbono';
      case QuestionCategory.agronomia: return 'Agronomia';
      case QuestionCategory.risco: return 'Riscos & Segurança';
      case QuestionCategory.certificacao: return 'Certificação';
      case QuestionCategory.aplicacao: return 'Aplicação';
      case QuestionCategory.consultoria: return 'Consultoria';
      case QuestionCategory.engenharia: return 'Engenharia';
      case QuestionCategory.seguranca: return 'Segurança Operacional';
      case QuestionCategory.mercado: return 'Mercado';
      case QuestionCategory.tecnologia: return 'Tecnologia';
      case QuestionCategory.geral: return 'Geral';
    }
  }
}