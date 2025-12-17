import 'package:biochar_consulting/pages/best.pratices.dart';
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

// --- IMPORT DO NOVO QUIZ ---
import 'package:biochar_consulting/pages/biochar.quiz.page.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;
  final String developerName = "Danilo Andrade";

  const HomeScreen({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Cores base
    final backgroundColor = isDark ? const Color(0xFF121212) : const Color(0xFFF0F2F5);
    final textColor = isDark ? Colors.white : const Color(0xFF1A202C);
    final sectionTitleColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Scaffold(
      backgroundColor: backgroundColor,
      
      // Floating Action Button para Acesso Rápido ao Treino
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context, 
          MaterialPageRoute(builder: (ctx) => QuizSetupScreen(onToggleTheme: onToggleTheme))
        ),
        backgroundColor: isDark ? Colors.purple[700] : const Color(0xFF6A1B9A),
        icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
        label: const Text("Treinar Agora", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),

      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. App Bar com Imagem de Fundo (Textura)
          SliverAppBar(
            expandedHeight: 160.0,
            floating: false,
            pinned: true,
            stretch: true,
            backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.green[900],
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
                  icon: const Icon(Icons.brightness_6, color: Colors.white, size: 20),
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
                  // Imagem de fundo (pode ser asset ou network)
                  // Usando um container com gradiente decorativo simulando natureza
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: isDark
                            ? [Colors.grey[900]!, Colors.black]
                            : [const Color(0xFF1B5E20), const Color(0xFF43A047)],
                      ),
                    ),
                  ),
                  // Padrão visual sutil
                  Opacity(
                    opacity: 0.1,
                    child: Image.network(
                      "https://www.transparenttextures.com/patterns/cubes.png", // Textura leve
                      fit: BoxFit.cover,
                      errorBuilder: (c, o, s) => const SizedBox(), // Fallback se offline
                    ),
                  ),
                  // Gradiente escuro para garantir leitura do texto
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
                  // --- SEÇÃO: FERRAMENTAS RÁPIDAS (Horizontal Scroll) ---
                  Row(
                    children: [
                      Icon(Icons.handyman_outlined, size: 18, color: sectionTitleColor),
                      const SizedBox(width: 8),
                      Text(
                        "CALCULADORAS & FERRAMENTAS",
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
                  
                  // Carrossel de Calculadoras
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
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => TotalAreaScreen(onToggleTheme: onToggleTheme))),
                        ),
                        _toolCard(
                          context,
                          title: "Por Cova",
                          icon: Icons.grass_rounded,
                          color: Colors.green,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const CovaScreen())),
                        ),
                        _toolCard(
                          context,
                          title: "Por Sulco",
                          icon: Icons.linear_scale_rounded,
                          color: Colors.orange,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const SulcoScreen())),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // --- SEÇÃO: CONHECIMENTO ---
                  Row(
                    children: [
                      Icon(Icons.menu_book_rounded, size: 18, color: sectionTitleColor),
                      const SizedBox(width: 8),
                      Text(
                        "BASE DE CONHECIMENTO",
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

                  // Cards Grandes Verticais
                  _gradientCard(
                    context,
                    title: "Certificação & Padrões",
                    subtitle: "Guia passo a passo e requisitos IBI/EBC",
                    icon: Icons.verified_user_rounded,
                    gradientColors: [const Color(0xFF00695C), const Color(0xFF00897B)],
                    target: (ctx) => CertificationScreen(onToggleTheme: onToggleTheme),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _gradientCard(
                    context,
                    title: "Boas Práticas",
                    subtitle: "Segurança, mistura e aplicação",
                    icon: Icons.school_rounded,
                    gradientColors: [const Color(0xFFE65100), const Color(0xFFFF9800)],
                    target: (ctx) => BestPracticesScreen(onToggleTheme: onToggleTheme),
                  ),

                  const SizedBox(height: 16),

                  _gradientCard(
                    context,
                    title: "Avaliando Resultados",
                    subtitle: "Indicadores de sucesso no campo",
                    icon: Icons.analytics_rounded,
                    gradientColors: [const Color(0xFF5D4037), const Color(0xFF8D6E63)],
                    target: (ctx) => EvaluationFactorsScreen(onToggleTheme: onToggleTheme),
                  ),

                  const SizedBox(height: 16),

                  _gradientCard(
                    context,
                    title: "Dinâmica no Solo",
                    subtitle: "O ciclo de vida do Biochar",
                    icon: Icons.timelapse_rounded,
                    gradientColors: [const Color(0xFF283593), const Color(0xFF3F51B5)],
                    target: (ctx) => BiocharTransformationsScreen(onToggleTheme: onToggleTheme),
                  ),

                  const SizedBox(height: 16),

                  _gradientCard(
                    context,
                    title: "IBI & EBC",
                    subtitle: "Certificação Global e Europeia",
                    icon: Icons.public,
                    gradientColors: [const Color(0xFF1B5E20), const Color(0xFF43A047)],
                    target: (ctx) => CertificationStandardsScreen(onToggleTheme: onToggleTheme),
                  ),

                  const SizedBox(height: 16),

                  _gradientCard(
                    context,
                    title: "Análise de Riscos",
                    subtitle: "HPAs, Metais e Estabilidade",
                    icon: Icons.warning_amber_rounded,
                    gradientColors: [const Color(0xFFC62828), const Color(0xFFE53935)],
                    target: (ctx) => BiocharRisksScreen(onToggleTheme: onToggleTheme),
                  ),

                  // O Quiz agora está no FAB (Botão flutuante) e também aqui como destaque final
                  const SizedBox(height: 16),
                  
                  Container(
                    margin: const EdgeInsets.only(bottom: 40),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.purple[900]!.withOpacity(0.3) : Colors.purple[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? Colors.purple[700]! : Colors.purple[200]!,
                        width: 1.5
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(20),
                      leading: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.purple[600],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.emoji_events_rounded, color: Colors.white),
                      ),
                      title: Text(
                        "Teste de Certificação",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: isDark ? Colors.white : Colors.purple[900],
                        ),
                      ),
                      subtitle: const Text("Valide seus conhecimentos técnicos"),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => QuizSetupScreen(onToggleTheme: onToggleTheme))),
                    ),
                  ),

                  // Rodapé
                  Center(
                    child: Text(
                      "v1.0.0 • Personal Edition",
                      style: TextStyle(color: Colors.grey[400], fontSize: 10),
                    ),
                  ),
                  const SizedBox(height: 80), // Espaço para o FAB não cobrir nada
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  // Card Quadrado para Ferramentas (Carrossel)
  Widget _toolCard(BuildContext context, {required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
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
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: target)),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24), // Mais altura
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
                          fontSize: 17, // Um pouco menor para elegância
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
                Icon(Icons.arrow_forward_rounded, color: Colors.white.withOpacity(0.6), size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}