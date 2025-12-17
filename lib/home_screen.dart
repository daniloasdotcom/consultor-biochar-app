import 'package:biochar_consulting/pages/best.pratices.dart';
import 'package:biochar_consulting/pages/biochar_risks_screen.dart';
import 'package:biochar_consulting/pages/biochar_transformations_page.dart';
import 'package:biochar_consulting/pages/certification_standards_screen.dart';
import 'package:biochar_consulting/pages/evaluation.factors.dart';
import 'package:flutter/material.dart';

// --- IMPORTS DAS FERRAMENTAS ---
import 'calculos/total_area_screen.dart';
import 'calculos/cova_screen.dart';
import 'calculos/sulco_screen.dart';
import 'pages/certification_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;

  // COLOQUE SEU NOME AQUI
  final String developerName = "Danilo Andrade";

  const HomeScreen({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Cores de fundo mais elegantes
    final backgroundColor = isDark
        ? const Color(0xFF121212)
        : const Color(0xFFF5F7FA);
    final expanderColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF2D3748);

    return Scaffold(
      backgroundColor: backgroundColor,
      // Usamos CustomScrollView para o efeito elegante do topo
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(), // Efeito elástico (iOS style)
        slivers: [
          // 1. App Bar Moderno e Expansível
          SliverAppBar(
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            backgroundColor: isDark
                ? const Color(0xFF1E1E1E)
                : Colors.green[900],
            elevation: 0,
            actions: [
              IconButton(
                onPressed: onToggleTheme,
                icon: const Icon(Icons.brightness_6, color: Colors.white),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: const Text(
                'Consultor Biochar',
                style: TextStyle(
                  fontFamily: 'Merriweather',
                  fontWeight: FontWeight.bold,
                  fontSize: 16, // Fica pequeno ao rolar
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [Colors.grey[900]!, Colors.black]
                        : [Colors.green[800]!, Colors.green[600]!],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "Bem-vindo,",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                      // Se quiser, coloque seu nome aqui também
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 2. Conteúdo da Lista
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- SEÇÃO 1: FERRAMENTAS (EXPANDER) ---
                  Container(
                    decoration: BoxDecoration(
                      color: expanderColor,
                      borderRadius: BorderRadius.circular(
                        20,
                      ), // Mais arredondado
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        initiallyExpanded: false,
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.calculate,
                            color: isDark ? Colors.white : Colors.blueGrey[800],
                          ),
                        ),
                        title: Text(
                          "Calculadoras",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Merriweather',
                            color: textColor,
                          ),
                        ),
                        subtitle: Text(
                          "Dosagem e aplicação",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        childrenPadding: const EdgeInsets.fromLTRB(
                          16,
                          0,
                          16,
                          20,
                        ),
                        children: [
                          const SizedBox(height: 10),
                          _miniToolButton(
                            context,
                            "Área Total",
                            Icons.landscape,
                            (ctx) =>
                                TotalAreaScreen(onToggleTheme: onToggleTheme),
                          ),
                          _miniToolButton(
                            context,
                            "Por Cova",
                            Icons.grass,
                            (ctx) => const CovaScreen(),
                          ),
                          _miniToolButton(
                            context,
                            "Por Sulco",
                            Icons.linear_scale,
                            (ctx) => const SulcoScreen(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  Text(
                    "Base de Conhecimento",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Merriweather',
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- SEÇÃO 2: BOTÕES COM GRADIENTE ---
                  _gradientCard(
                    context,
                    title: "Certificação & Padrões",
                    subtitle: "Guia passo a passo e requisitos IBI/EBC",
                    icon: Icons.verified_user,
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
                    icon: Icons.school,
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
                    icon: Icons.analytics_outlined,
                    gradientColors: [
                      const Color(0xFF5D4037),
                      const Color(0xFF8D6E63),
                    ],
                    target: (ctx) =>
                        EvaluationFactorsScreen(onToggleTheme: onToggleTheme),
                  ),

                  const SizedBox(height: 16),

                  // Novo Botão Adicionado
                  _gradientCard(
                    context,
                    title: "Dinâmica no Solo",
                    subtitle: "O ciclo de vida do Biochar",
                    icon: Icons.timelapse,
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
                    title: "IBI & EBC", // Nome curto e forte
                    subtitle: "Certificação Global e Europeia",
                    icon: Icons.verified_user, // Ícone de verificação
                    // Gradiente Teal/Verde para remeter a normas e sustentabilidade
                    gradientColors: [
                      const Color(0xFF00695C),
                      const Color(0xFF2E7D32),
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
                    icon: Icons.biotech, // Ícone de biotecnologia/laboratório
                    // Gradiente Vinho/Vermelho para indicar "Atenção/Química"
                    gradientColors: [
                      const Color(0xFFC62828),
                      const Color(0xFFB71C1C),
                    ],
                    target: (ctx) =>
                        BiocharRisksScreen(onToggleTheme: onToggleTheme),
                  ),

                  const SizedBox(height: 40),

                  // --- RODAPÉ DE ASSINATURA ---
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.code, size: 20, color: Colors.grey[400]),
                        const SizedBox(height: 8),
                        Text(
                          "Desenvolvido por $developerName",
                          style: TextStyle(
                            fontFamily:
                                'Merriweather', // Fonte serifada para assinatura fica chique
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "v1.0.0 • Personal Edition",
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Novo Widget para botões menores dentro do Expander (mais limpo)
  Widget _miniToolButton(
    BuildContext context,
    String label,
    IconData icon,
    Widget Function(BuildContext) target,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: target)),
      leading: Icon(
        icon,
        color: isDark ? Colors.greenAccent : Colors.green[800],
      ),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.grey,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      tileColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[50],
    );
  }

  // Novo Widget de Cartão com Gradiente (Efeito Premium)
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
            padding: const EdgeInsets.all(22),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Merriweather',
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward, color: Colors.white.withOpacity(0.6)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
