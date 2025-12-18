import 'package:biochar_consulting/pages/biochar.quiz.page.dart';
import 'package:flutter/material.dart';
import '../data/questions_repository.dart';
import '../models/paper_model.dart';

class PapersLibraryScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const PapersLibraryScreen({super.key, required this.onToggleTheme});

  @override
  State<PapersLibraryScreen> createState() => _PapersLibraryScreenState();
}

class _PapersLibraryScreenState extends State<PapersLibraryScreen> {
  final QuestionsRepository _repo = QuestionsRepository();
  List<StudyPaper> _papers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPapers();
  }

  Future<void> _loadPapers() async {
    final papers = await _repo.loadPapers();
    if (mounted) {
      setState(() {
        _papers = papers;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text("Papers & Insights"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: textColor,
        actions: [
          IconButton(onPressed: widget.onToggleTheme, icon: const Icon(Icons.brightness_6)),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _papers.length,
              itemBuilder: (context, index) {
                final paper = _papers[index];
                return _buildPaperCard(paper, isDark);
              },
            ),
    );
  }

  Widget _buildPaperCard(StudyPaper paper, bool isDark) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 20),
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          // AQUI ESTÁ A MÁGICA:
          // Navega para o Quiz, mas passando a lista fixa de perguntas deste paper
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BiocharQuizScreen(
                onToggleTheme: widget.onToggleTheme,
                fixedQuestions: paper.questions, // Passa as perguntas diretas
                quizTitle: "Paper: ${paper.title}", // Título personalizado
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.article, color: Colors.blue[700]),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      paper.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                paper.author,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                paper.description,
                style: TextStyle(
                  color: isDark ? Colors.grey[300] : Colors.grey[800],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text("${paper.questions.length} Questões"),
                    backgroundColor: isDark ? Colors.blue[900]!.withOpacity(0.5) : Colors.blue[50],
                    labelStyle: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.arrow_forward, color: Colors.blue[700]),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}