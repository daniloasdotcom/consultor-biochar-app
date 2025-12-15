import 'package:biochar_consulting/best.pratices.dart';
import 'package:flutter/material.dart';

// --- IMPORTS ---
import 'calculos/total_area_screen.dart';
import 'calculos/cova_screen.dart';
import 'calculos/sulco_screen.dart';
import 'certification_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;
  const HomeScreen({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    // Verificação de tema para ajustar cores do Container do Expander
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final expanderColor = isDark ? Colors.grey[900] : Colors.white;
    final expanderBorderColor = isDark ? Colors.grey[800] : Colors.grey[300];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Consultor Biochar',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Merriweather', // Fonte aplicada
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: onToggleTheme,
            icon: const Icon(Icons.brightness_6),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              
              // --- SEÇÃO 1: FERRAMENTAS (EXPANDER) ---
              // Envolvi o ExpansionTile em um Container para dar visual de "Cartão"
              Container(
                decoration: BoxDecoration(
                  color: expanderColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: expanderBorderColor!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Theme(
                  // Remove as bordas padrão feias do ExpansionTile quando aberto
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    initiallyExpanded: false, // Começa fechado para limpar a tela
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.calculate, color: Colors.blueGrey.shade800),
                    ),
                    title: const Text(
                      "Ferramentas de Cálculo",
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Merriweather',
                      ),
                    ),
                    subtitle: const Text("Calculadoras de dosagem"),
                    childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    children: [
                      const SizedBox(height: 10),
                      // 1. Área Total
                      _menuButton(
                        context,
                        title: "Área Total (Broadcast)",
                        subtitle: "Incorporação em toda a lavoura",
                        icon: Icons.landscape,
                        color: const Color(0xFF1A365D),
                        target: (ctx) => TotalAreaScreen(onToggleTheme: onToggleTheme),
                        isSmall: true, // Flag para botão menor dentro da lista
                      ),
                      const SizedBox(height: 10),

                      // 2. Cova
                      _menuButton(
                        context,
                        title: "Aplicação em Cova",
                        subtitle: "Plantio localizado (g/cova)",
                        icon: Icons.grass,
                        color: Colors.green.shade800,
                        target: (ctx) => const CovaScreen(),
                        isSmall: true,
                      ),
                      const SizedBox(height: 10),

                      // 3. Sulco
                      _menuButton(
                        context,
                        title: "Aplicação em Sulco",
                        subtitle: "Plantio linear (g/metro)",
                        icon: Icons.linear_scale,
                        color: Colors.orange.shade900,
                        target: (ctx) => const SulcoScreen(),
                        isSmall: true,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
              
              // Título da Seção
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Base de Conhecimento",
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Merriweather'
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // --- SEÇÃO 2: BOTÕES DE CONTEÚDO ---

              // 4. Certificação
              _menuButton(
                context,
                title: "Certificação & Padrões",
                subtitle: "Guia passo a passo e requisitos",
                icon: Icons.verified_user,
                color: const Color(0xFF00695C), // Teal mais sóbrio
                target: (ctx) => CertificationScreen(onToggleTheme: onToggleTheme),
              ),
              
              const SizedBox(height: 16),

              // 5. Boas Práticas (NOVO)
              _menuButton(
                context,
                title: "Boas Práticas de Uso",
                subtitle: "Mistura, segurança e aplicação",
                icon: Icons.school, // Ícone de aprendizado
                color: const Color(0xFFE65100), // Laranja queimado (destaque)
                target: (ctx) => BestPracticesScreen(onToggleTheme: onToggleTheme),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Widget do botão refatorado para aceitar modo "Compacto" (isSmall)
  Widget _menuButton(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget Function(BuildContext) target,
    bool isSmall = false, // Parâmetro novo
  }) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: target)),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(isSmall ? 16 : 24), // Padding menor se for pequeno
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(isSmall ? 8 : 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: isSmall ? 24 : 32),
            ),
            SizedBox(width: isSmall ? 16 : 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmall ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Merriweather', // Fonte aplicada aqui
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                      fontFamily: 'Roboto', // Mantive Roboto para leitura fácil
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white70,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}