import 'package:biochar_consulting/pages/best.pratices.dart';
import 'package:biochar_consulting/pages/biochar_reactions_page.dart';
import 'package:biochar_consulting/pages/biochar_risks_screen.dart';
import 'package:biochar_consulting/pages/biochar_transformations_page.dart';
import 'package:biochar_consulting/pages/certification_standards_screen.dart';
import 'package:biochar_consulting/pages/evaluation.factors.dart';
import 'package:biochar_consulting/pages/quiz_setup_screen.dart';
import 'package:flutter/material.dart';

// --- IMPORTS DAS FERRAMENTAS ---
import 'calculos/total_area_screen.dart';
import 'calculos/cova_screen.dart';
import 'calculos/sulco_screen.dart';
import 'pages/certification_screen.dart';

// --- NOVOS IMPORTS DE ESTUDO ---
import 'package:biochar_consulting/pages/netzero.producer.dart';

import 'package:biochar_consulting/pages/papers_library_screen.dart'; // <--- Import da nova tela

class HomeScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;
  final String developerName = "Danilo Andrade";

  const HomeScreen({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Cores base
    final backgroundColor = isDark
        ? const Color(0xFF121212)
        : const Color(0xFFF0F2F5);
    final sectionTitleColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Scaffold(
      backgroundColor: backgroundColor,

      // MANTIVE O FAB: Acesso rápido ao modo aleatório é sempre útil
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => QuizSetupScreen(onToggleTheme: onToggleTheme),
          ),
        ),
        backgroundColor: isDark ? Colors.purple[700] : const Color(0xFF6A1B9A),
        icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
        label: const Text(
          "Quiz Rápido",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. App Bar (Mantida igual)
          SliverAppBar(
            expandedHeight: 160.0,
            floating: false,
            pinned: true,
            stretch: true,
            backgroundColor: isDark
                ? const Color(0xFF1E1E1E)
                : Colors.green[900],
            elevation: 0,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: onToggleTheme,
                  icon: const Icon(
                    Icons.brightness_6,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Consultor Biochar',
                    style: TextStyle(
                      fontFamily: 'Merriweather',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: isDark
                            ? [Colors.grey[900]!, Colors.black]
                            : [
                                const Color(0xFF1B5E20),
                                const Color(0xFF43A047),
                              ],
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: 0.1,
                    child: Image.network(
                      "https://www.transparenttextures.com/patterns/cubes.png",
                      fit: BoxFit.cover,
                      errorBuilder: (c, o, s) => const SizedBox(),
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black45],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 20,
                    child: Text(
                      "Bem-vindo, $developerName",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Conteúdo Principal
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- SEÇÃO 1: FERRAMENTAS RÁPIDAS ---
                  Row(
                    children: [
                      Icon(
                        Icons.handyman_outlined,
                        size: 18,
                        color: sectionTitleColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "FERRAMENTAS DE CAMPO",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: sectionTitleColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    height: 110,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _toolCard(
                          context,
                          title: "Área Total",
                          icon: Icons.landscape_rounded,
                          color: Colors.blue,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) =>
                                  TotalAreaScreen(onToggleTheme: onToggleTheme),
                            ),
                          ),
                        ),
                        _toolCard(
                          context,
                          title: "Por Cova",
                          icon: Icons.grass_rounded,
                          color: Colors.green,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => const CovaScreen(),
                            ),
                          ),
                        ),
                        _toolCard(
                          context,
                          title: "Por Sulco",
                          icon: Icons.linear_scale_rounded,
                          color: Colors.orange,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => const SulcoScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // --- NOVA SEÇÃO 2: ESTUDO INTERATIVO ---
                  Row(
                    children: [
                      Icon(
                        Icons.psychology,
                        size: 18,
                        color: sectionTitleColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "ESTUDO INTERATIVO",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: sectionTitleColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Grid de 2 Botões para os modos de estudo
                  Row(
                    children: [
                      Expanded(
                        child: _studyActionCard(
                          context,
                          title: "Quiz Geral",
                          subtitle: "Treino Aleatório",
                          icon: Icons.quiz,
                          color: Colors.purple,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) =>
                                  QuizSetupScreen(onToggleTheme: onToggleTheme),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _studyActionCard(
                          context,
                          title: "Papers",
                          subtitle: "Lições Guiadas",
                          icon: Icons.library_books,
                          color: Colors.indigo,
                          // AQUI VAI PARA A NOVA TELA DE PAPERS
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => PapersLibraryScreen(
                                onToggleTheme: onToggleTheme,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // --- SEÇÃO 3: BASE DE CONHECIMENTO (TEORIA) ---
                  Row(
                    children: [
                      Icon(
                        Icons.menu_book_rounded,
                        size: 18,
                        color: sectionTitleColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "BASE TEÓRICA & NORMAS",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: sectionTitleColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _gradientCard(
                    context,
                    title: "Certificação & Padrões",
                    subtitle: "Guia passo a passo e requisitos IBI/EBC",
                    icon: Icons.verified_user_rounded,
                    gradientColors: [
                      const Color(0xFF00695C),
                      const Color(0xFF00897B),
                    ],
                    target: (ctx) =>
                        CertificationScreen(onToggleTheme: onToggleTheme),
                  ),

                  const SizedBox(height: 16),

                  _gradientCard(
                    context,
                    title: "Boas Práticas",
                    subtitle: "Segurança, mistura e aplicação",
                    icon: Icons.school_rounded,
                    gradientColors: [
                      const Color(0xFFE65100),
                      const Color(0xFFFF9800),
                    ],
                    target: (ctx) =>
                        BestPracticesScreen(onToggleTheme: onToggleTheme),
                  ),

                  const SizedBox(height: 16),

                  _gradientCard(
                    context,
                    title: "Avaliando Resultados",
                    subtitle: "Indicadores de sucesso no campo",
                    icon: Icons.analytics_rounded,
                    gradientColors: [
                      const Color(0xFF5D4037),
                      const Color(0xFF8D6E63),
                    ],
                    target: (ctx) =>
                        EvaluationFactorsScreen(onToggleTheme: onToggleTheme),
                  ),

                  const SizedBox(height: 16),

                  _gradientCard(
                    context,
                    title: "Dinâmica no Solo",
                    subtitle: "O ciclo de vida do Biochar",
                    icon: Icons.timelapse_rounded,
                    gradientColors: [
                      const Color(0xFF283593),
                      const Color(0xFF3F51B5),
                    ],
                    target: (ctx) => BiocharTransformationsScreen(
                      onToggleTheme: onToggleTheme,
                    ),
                  ),

                  const SizedBox(height: 16),

                  _gradientCard(
                    context,
                    title: "IBI & EBC",
                    subtitle: "Certificação Global e Europeia",
                    icon: Icons.public,
                    gradientColors: [
                      const Color(0xFF1B5E20),
                      const Color(0xFF43A047),
                    ],
                    target: (ctx) => CertificationStandardsScreen(
                      onToggleTheme: onToggleTheme,
                    ),
                  ),

                  const SizedBox(height: 16),

                  _gradientCard(
                    context,
                    title: "Análise de Riscos",
                    subtitle: "HPAs, Metais e Estabilidade",
                    icon: Icons.warning_amber_rounded,
                    gradientColors: [
                      const Color(0xFFC62828),
                      const Color(0xFFE53935),
                    ],
                    target: (ctx) =>
                        BiocharRisksScreen(onToggleTheme: onToggleTheme),
                  ),

                  const SizedBox(height: 16),

                  _gradientCard(
                    context,
                    title: "Produtor & Crédito de Carbono",
                    subtitle: "Quem gera valor e como ele é distribuído",
                    icon: Icons.balance_outlined,
                    gradientColors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                    target: (ctx) => NetZeroProducerRelationScreen(
                      onToggleTheme: onToggleTheme,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _gradientCard(
                    context,
                    title: "Química do Solo",
                    subtitle: "Reações, pH e Complexação",
                    icon: Icons.science_rounded, // Ícone de ciência
                    gradientColors: [
                      const Color(0xFF0097A7),
                      const Color(0xFF006064),
                    ], // Tons de Ciano/Teal
                    target: (ctx) =>
                        BiocharReactionsPage(onToggleTheme: onToggleTheme),
                  ),

                  // Rodapé
                  const SizedBox(height: 40),
                  Center(
                    child: Text(
                      "v1.1.0 • Módulo Avançado",
                      style: TextStyle(color: Colors.grey[400], fontSize: 10),
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  // NOVO: Card Quadrado para Ações de Estudo
  Widget _studyActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: isDark ? 0 : 2,
      shadowColor: Colors.black.withOpacity(0.05),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
            color: color.withOpacity(0.05),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Card Quadrado para Ferramentas (Carrossel)
  Widget _toolCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Material(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: isDark ? 0 : 2,
        shadowColor: Colors.black.withOpacity(0.05),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey[300] : Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Card Retangular com Gradiente
  Widget _gradientCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradientColors,
    required Widget Function(BuildContext) target,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () =>
              Navigator.push(context, MaterialPageRoute(builder: target)),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Merriweather',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 13,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white.withOpacity(0.6),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
