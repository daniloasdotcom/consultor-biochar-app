import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../data/questions_repository.dart';

class BiocharQuizScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final int totalQuestions;
  final QuestionCategory? categoryFilter; // Novo parâmetro opcional

  const BiocharQuizScreen({
    super.key, 
    required this.onToggleTheme,
    this.totalQuestions = 10,
    this.categoryFilter, // Recebe do construtor
  });

  @override
  State<BiocharQuizScreen> createState() => _BiocharQuizScreenState();
}

class _BiocharQuizScreenState extends State<BiocharQuizScreen> {
  final QuestionsRepository _repository = QuestionsRepository();
  
  // Estados do Quiz
  List<QuizQuestion> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  bool _isAnswered = false;
  int? _selectedAnswerIndex;
  bool _showScoreScreen = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  // 1. Carrega o JSON e inicia o sorteio
  Future<void> _initializeData() async {
    await _repository.loadQuestions();
    _startNewQuiz();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 2. Sorteia as questões com FILTRO
  void _startNewQuiz() {
    setState(() {
      // Passamos o categoryFilter para o repositório
      _questions = _repository.getQuizSession(
        numberOfQuestions: widget.totalQuestions,
        categoryFilter: widget.categoryFilter, 
      );
      
      _currentIndex = 0;
      _score = 0;
      _isAnswered = false;
      _selectedAnswerIndex = null;
      _showScoreScreen = false;
    });
  }

  void _answerQuestion(int index) {
    if (_isAnswered) return;

    setState(() {
      _isAnswered = true;
      _selectedAnswerIndex = index;
      if (index == _questions[_currentIndex].correctAnswerIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _isAnswered = false;
        _selectedAnswerIndex = null;
      });
    } else {
      setState(() {
        _showScoreScreen = true;
      });
    }
  }

  // --- UI PRINCIPAL ---
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF121212) : const Color(0xFFF3F4F6);

    // Título dinâmico baseado no filtro
    String appTitle = "Consultoria Técnica";
    if (widget.categoryFilter != null) {
      appTitle = widget.categoryFilter!.displayName;
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              appTitle,
              style: const TextStyle(fontFamily: 'Merriweather', fontWeight: FontWeight.bold, fontSize: 18),
            ),
            if (!_showScoreScreen && !_isLoading && _questions.isNotEmpty)
               Text(
                'Questão ${_currentIndex + 1} de ${_questions.length}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
              ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        actions: [
          IconButton(onPressed: widget.onToggleTheme, icon: const Icon(Icons.brightness_6)),
        ],
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : _showScoreScreen 
              ? _buildResultScreen(isDark) 
              : _buildQuizContent(isDark),
    );
  }

  // --- CONTEÚDO DA PERGUNTA ---
  Widget _buildQuizContent(bool isDark) {
    // Caso o filtro selecionado não retorne nenhuma questão (ex: categoria vazia no JSON)
    if (_questions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              const Text(
                "Nenhuma questão encontrada para esta categoria.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Voltar e Escolher Outra"),
              )
            ],
          ),
        ),
      );
    }

    final question = _questions[_currentIndex];
    final badgeColor = _getCategoryColor(question.category, isDark);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero).animate(animation),
            child: child,
          ),
        );
      },
      child: SingleChildScrollView(
        key: ValueKey<String>(question.id),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Badge da Categoria Colorido
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: badgeColor.withOpacity(0.5), width: 1),
                ),
                child: Text(
                  question.category.displayName.toUpperCase(), // Usa o display name aqui também
                  style: TextStyle(
                    color: isDark ? Colors.white : badgeColor.withOpacity(1.0),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Texto da Pergunta
            Text(
              question.question,
              style: TextStyle(
                fontFamily: 'Merriweather',
                fontSize: 20,
                height: 1.4,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1A202C),
              ),
            ),
            const SizedBox(height: 24),

            // Lista de Opções
            ...List.generate(question.options.length, (index) {
              return _buildOptionCard(index, question.options[index], isDark, question);
            }),

            const SizedBox(height: 24),

            // Explicação Técnica
            if (_isAnswered)
              _buildExplanationCard(isDark, question),

            const SizedBox(height: 30),

            // Botão de Próximo
            if (_isAnswered)
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white : Colors.black87,
                    foregroundColor: isDark ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                  ),
                  child: Text(
                    _currentIndex < _questions.length - 1 ? "Próxima Questão" : "Ver Resultado",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // --- CARD DE OPÇÃO ---
  Widget _buildOptionCard(int index, String text, bool isDark, QuizQuestion question) {
    Color borderColor = Colors.transparent;
    Color bgColor = isDark ? const Color(0xFF2C2C2E) : Colors.white;
    Color textColor = isDark ? Colors.grey[300]! : Colors.grey[800]!;
    
    if (_isAnswered) {
      if (index == question.correctAnswerIndex) {
        borderColor = Colors.green;
        bgColor = isDark ? Colors.green.withOpacity(0.2) : Colors.green[50]!;
        textColor = isDark ? Colors.green[100]! : Colors.green[900]!;
      } else if (index == _selectedAnswerIndex) {
        borderColor = Colors.red;
        bgColor = isDark ? Colors.red.withOpacity(0.2) : Colors.red[50]!;
        textColor = isDark ? Colors.red[100]! : Colors.red[900]!;
      } else {
         textColor = isDark ? Colors.grey[600]! : Colors.grey[400]!;
      }
    }

    return GestureDetector(
      onTap: () => _answerQuestion(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isAnswered ? borderColor : (isDark ? Colors.grey[800]! : Colors.grey[300]!),
            width: (_isAnswered && borderColor != Colors.transparent) ? 2 : 1,
          ),
          boxShadow: [
             if (!_isAnswered) BoxShadow(
               color: Colors.black.withOpacity(0.05),
               blurRadius: 4,
               offset: const Offset(0, 2),
             )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(text, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textColor)),
            ),
            if (_isAnswered && index == question.correctAnswerIndex)
               const Icon(Icons.check_circle, color: Colors.green),
            if (_isAnswered && index == _selectedAnswerIndex && index != question.correctAnswerIndex)
               const Icon(Icons.cancel, color: Colors.red),
          ],
        ),
      ),
    );
  }

  // --- CARD DE EXPLICAÇÃO ---
  Widget _buildExplanationCard(bool isDark, QuizQuestion question) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.blueGrey[900] : Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.blueGrey[700]! : Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.school, color: Colors.blue[700], size: 20),
              const SizedBox(width: 8),
              Text(
                "Nota Técnica",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800], fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            question.explanation,
            style: TextStyle(
              fontSize: 14, 
              height: 1.5, 
              color: isDark ? Colors.grey[300] : Colors.blue[900]
            ),
          ),
        ],
      ),
    );
  }

  // --- TELA DE RESULTADO ---
  Widget _buildResultScreen(bool isDark) {
    final percentage = _questions.isEmpty ? 0 : (_score / _questions.length) * 100;
    
    String title;
    Color resultColor;
    IconData icon;

    if (percentage >= 80) {
      title = "Excelência Técnica";
      resultColor = Colors.green;
      icon = Icons.workspace_premium;
    } else if (percentage >= 60) {
      title = "Bom Conhecimento";
      resultColor = Colors.blue;
      icon = Icons.thumb_up;
    } else {
      title = "Revisão Necessária";
      resultColor = Colors.orange;
      icon = Icons.warning_amber;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: resultColor),
            const SizedBox(height: 24),
            Text("Resultado Final", style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600])),
            Text(
              "$_score / ${_questions.length}",
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: resultColor),
            ),
            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context); // Volta para a tela de Setup
                },
                icon: const Icon(Icons.settings),
                label: const Text("Configurar Novo Treino"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: resultColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- AUXILIAR DE CORES ---
  Color _getCategoryColor(QuestionCategory category, bool isDark) {
    switch (category) {
      case QuestionCategory.risco:
      case QuestionCategory.seguranca: 
        return Colors.red;

      case QuestionCategory.agronomia:
      case QuestionCategory.aplicacao:
        return Colors.green;

      case QuestionCategory.quimica:
      case QuestionCategory.processo:
      case QuestionCategory.engenharia: 
      case QuestionCategory.tecnologia: 
      case QuestionCategory.carbono:
        return Colors.blue;

      case QuestionCategory.regulamentacao:
      case QuestionCategory.certificacao:
      case QuestionCategory.mercado: 
        return Colors.purple;

      case QuestionCategory.consultoria:
        return Colors.orange;

      default:
        return Colors.grey;
    }
  }
}