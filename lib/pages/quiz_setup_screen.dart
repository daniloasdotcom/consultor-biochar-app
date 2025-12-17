import 'package:flutter/material.dart';
import '../models/question_model.dart'; // Certifique-se de que o import está correto
import '../pages/biochar.quiz.page.dart';

class QuizSetupScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const QuizSetupScreen({super.key, required this.onToggleTheme});

  @override
  State<QuizSetupScreen> createState() => _QuizSetupScreenState();
}

class _QuizSetupScreenState extends State<QuizSetupScreen> {
  double _numberOfQuestions = 10;
  
  // Variável para guardar a categoria selecionada (null = Todas)
  QuestionCategory? _selectedCategory; 

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF3F4F6);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Configurar Treino"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: textColor,
        actions: [
          IconButton(onPressed: widget.onToggleTheme, icon: const Icon(Icons.brightness_6)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
             Icon(Icons.tune, size: 64, color: Colors.green[700]),
             const SizedBox(height: 32),

             // --- SELEÇÃO DE CATEGORIA ---
             Text(
              "Foco do Estudo",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
            ),
             const SizedBox(height: 12),
             Container(
               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
               decoration: BoxDecoration(
                 color: cardColor,
                 borderRadius: BorderRadius.circular(20),
                 boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                 ],
               ),
               child: DropdownButtonHideUnderline(
                 child: DropdownButton<QuestionCategory?>(
                   value: _selectedCategory,
                   isExpanded: true,
                   dropdownColor: cardColor,
                   icon: Icon(Icons.arrow_drop_down_circle, color: Colors.green[700]),
                   hint: Text("Todas as Categorias", style: TextStyle(color: textColor)),
                   items: [
                     // Opção "Todas"
                     DropdownMenuItem(
                       value: null,
                       child: Row(
                         children: [
                           Icon(Icons.list, color: Colors.green[700], size: 20),
                           const SizedBox(width: 12),
                           Text("Todas as Categorias", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                         ],
                       ),
                     ),
                     // Gera a lista baseada no ENUM
                     ...QuestionCategory.values.map((category) {
                       // Removemos a categoria 'geral' da lista de seleção específica se desejar, 
                       // ou mantemos todas. Aqui mantive todas.
                       return DropdownMenuItem(
                         value: category,
                         child: Text(
                           category.displayName, // Requer a extension no model
                           style: TextStyle(color: textColor),
                         ),
                       );
                     }), 
                   ],
                   onChanged: (value) {
                     setState(() {
                       _selectedCategory = value;
                     });
                   },
                 ),
               ),
             ),

             const SizedBox(height: 32),
            
             // --- SELEÇÃO DE QUANTIDADE ---
             Text(
              "Quantidade de Questões",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 12),
            
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "${_numberOfQuestions.round()}",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.green[700]),
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: _numberOfQuestions,
                    min: 5,
                    max: 50,
                    divisions: 9,
                    activeColor: Colors.green[700],
                    inactiveColor: isDark ? Colors.grey[800] : Colors.grey[300],
                    onChanged: (double value) {
                      setState(() {
                        _numberOfQuestions = value;
                      });
                    },
                  ),
                  Text(
                    "Deslize para ajustar",
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 48),

            // --- BOTÃO INICIAR ---
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BiocharQuizScreen(
                        onToggleTheme: widget.onToggleTheme,
                        totalQuestions: _numberOfQuestions.round(),
                        categoryFilter: _selectedCategory, // Passamos a escolha aqui!
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 6,
                  shadowColor: Colors.green.withOpacity(0.4),
                ),
                child: const Text("INICIAR TREINO", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}