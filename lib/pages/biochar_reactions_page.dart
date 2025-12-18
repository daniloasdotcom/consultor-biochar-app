import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class BiocharReactionsPage extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const BiocharReactionsPage({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF3F4F6);
    final textColor = isDark ? Colors.white : const Color(0xFF1A202C);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Química no Solo", style: TextStyle(fontFamily: 'Merriweather', fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: textColor,
        actions: [
          IconButton(onPressed: onToggleTheme, icon: const Icon(Icons.brightness_6)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        children: [
          _buildHeader(textColor),
          const SizedBox(height: 24),
          
          _buildSectionTitle("1. Aumento da CTC e Superfície", textColor),

          // CTC 1: Carboxílicos
          _buildReactionCard(
            context,
            title: "Grupos Carboxílicos (Cargas)",
            description: "Principal fonte de cargas negativas. A desprotonação ocorre efetivamente na faixa de pH 4,0 a 6,2, preparando o 'terreno' para segurar nutrientes.",
            latexEquations: [
              r"R\text{-}COOH \rightleftharpoons R\text{-}COO^- + H^+",
            ],
            icon: Icons.battery_charging_full,
            color: Colors.green,
          ),

          // CTC 2: Fenólicos
          _buildReactionCard(
            context,
            title: "Grupos Fenólicos (Cargas)",
            description: "Grupos hidroxila (-OH) aromáticos atuam como ácidos fracos. Sua dissociação contribui para a CTC geralmente em pHs mais elevados.",
            latexEquations: [
              r"R\text{-}OH \rightleftharpoons R\text{-}O^- + H^+",
            ],
            icon: Icons.science,
            color: Colors.teal,
          ),

          // CTC 3: RETENÇÃO DE NUTRIENTES (NOVO)
          _buildReactionCard(
            context,
            title: "Retenção de Nutrientes (Adsorção)",
            description: "As cargas negativas formadas atraem cátions (K, Ca, Mg, NH4) por força eletrostática. \n\nEfeito favorecido em pH > 5.5, onde há menos H⁺ competindo pelos sítios de adsorção.",
            latexEquations: [
              // Retenção de Potássio
              r"R\text{-}COO^- + K^+ \rightleftharpoons R\text{-}COO^- \cdots K^+",
              // Retenção de Cálcio (Divalente)
              r"2(R\text{-}COO^-) + Ca^{2+} \rightleftharpoons (R\text{-}COO)_2 \cdots Ca^{2+}",
              // Nota sobre competição com H+
              r"\text{\footnotesize Em pH baixo (muito } H^+)\text{, o nutriente é expulso:}",
              r"R\text{-}COO^-K^+ + H^+ \rightarrow R\text{-}COOH + K^+_{(lixiviado)}",
            ],
            icon: Icons.favorite, // Ícone de atração
            color: Colors.indigoAccent,
          ),

          // CTC 4: Oxidação
          _buildReactionCard(
            context,
            title: "Oxidação (Envelhecimento)",
            description: "Com o tempo no solo, a oxidação da superfície cria novos grupos funcionais, aumentando a CTC a longo prazo.",
            latexEquations: [
              r"C\text{-}H + O_2 \xrightarrow{\text{tempo}} C\text{-}COOH",
            ],
            icon: Icons.access_time_filled,
            color: Colors.purple,
          ),

          const SizedBox(height: 16),
          _buildSectionTitle("2. Correção de pH (Alcalinidade)", textColor),

          // pH 1: Carbonatos
          _buildReactionCard(
            context,
            title: "Carbonatos (Efeito Calagem)",
            description: "O carbonato reage consumindo acidez e liberando CO₂. O bicarbonato residual também atua na neutralização.",
            latexEquations: [
              r"CaCO_3 + 2H^+ \rightarrow Ca^{2+} + H_2O + CO_2",
              r"HCO_3^- + H^+ \rightarrow H_2O + CO_2",
            ],
            icon: Icons.architecture,
            color: Colors.blue,
          ),

          // pH 2: Óxidos e Hidróxidos
          _buildReactionCard(
            context,
            title: "Óxidos e Hidróxidos",
            description: "Álcalis de ação rápida presentes em biocarvões de alta temperatura. Elevam o pH imediatamente.",
            latexEquations: [
              r"CaO + 2H^+ \rightarrow Ca^{2+} + H_2O",
              r"Mg(OH)_2 + 2H^+ \rightarrow Mg^{2+} + 2H_2O",
            ],
            icon: Icons.flash_on,
            color: Colors.orange,
          ),

          // pH 3: Silicatos
          _buildReactionCard(
            context,
            title: "Silicatos (Fitólitos)",
            description: "O silício solúvel consome prótons para formar ácido silícico insolúvel, comum em biocarvão de gramíneas.",
            latexEquations: [
              r"H_3SiO_4^- + H^+ \rightleftharpoons H_4SiO_4",
            ],
            icon: Icons.grass,
            color: Colors.lightGreen,
          ),

          const SizedBox(height: 16),
          _buildSectionTitle("3. Dinâmica de Nutrientes e C", textColor),

           // Dissolução
          _buildReactionCard(
            context,
            title: "Dissolução de Sais (Cinzas)",
            description: "A solubilidade varia drasticamente. Sais de potássio (cinzas) dissolvem rápido, enquanto fosfatos de cálcio dependem da acidez do solo para liberar P.",
            latexEquations: [
              // Potássio
              r"K_2CO_3(s) + H_2O \rightarrow 2K^+ + CO_3^{2-}",
              r"\text{\footnotesize Solubilidade: } \approx 112 \text{ g/100mL (Muito Alta)}",
              
              // Fósforo
              r"Ca_3(PO_4)_2 + 4H^+ \rightarrow 3Ca^{2+} + 2H_2PO_4^-",
              r"\text{\footnotesize Solubilidade: } \approx 0.002 \text{ g/100mL (Baixa - Requer H}^+)",
            ],
            icon: Icons.local_florist,
            color: Colors.lime,
          ),

          // Efeito Priming
          _buildReactionCard(
            context,
            title: "Efeito Priming (C Lábil)",
            description: "Moléculas alifáticas (C lábil) estimulam a atividade microbiana, acelerando a decomposição e ciclos de nutrientes.",
            latexEquations: [
              r"C_{alif} + O_2 \xrightarrow{micróbios} CO_2 + Biomassa + Energia",
            ],
            icon: Icons.bug_report,
            color: Colors.brown,
          ),

          const SizedBox(height: 16),
          _buildSectionTitle("4. Resistência à Reacidificação (Redox)", textColor),

          // Redox: Ferro, Manganês e Enxofre
          _buildReactionCard(
            context,
            title: "Fontes de Acidez (Reoxidação)",
            description: "Em ciclos de secagem de solos alagados, a reoxidação de metais reduzidos e enxofre libera grandes quantidades de prótons (H⁺).",
            latexEquations: [
              r"4Fe^{2+} + O_2 + 4H^+ \rightarrow 4Fe^{3+} + 2H_2O", // Ferro
              r"2Mn^{2+} + O_2 + 2H_2O \rightarrow 2MnO_2 + 4H^+", // Manganês
              r"HS^- + 2O_2 \rightarrow SO_4^{2-} + H^+", // Enxofre
            ],
            icon: Icons.warning_amber,
            color: Colors.redAccent,
          ),

          // Mecanismo de Amortecimento
          _buildReactionCard(
            context,
            title: "Amortecimento pelo Biochar",
            description: "O biocarvão neutraliza a acidez gerada pelas reações redox através da protonação de seus grupos funcionais (tampão).",
            latexEquations: [
              r"Biochar\text{-}COO^- + H^+_{(da\ oxida\c{c}\tilde{a}o)} \rightarrow Biochar\text{-}COOH",
              r"Biochar\text{-}O^- + H^+ \rightarrow Biochar\text{-}OH",
            ],
            icon: Icons.shield,
            color: Colors.indigo,
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: textColor.withOpacity(0.6),
        ),
      ),
    );
  }

  Widget _buildHeader(Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Reações Químicas",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
        ),
        const SizedBox(height: 8),
        Text(
          "Estequiometria detalhada das interações entre biocarvão e solo.",
          style: TextStyle(fontSize: 14, color: textColor.withOpacity(0.7)),
        ),
      ],
    );
  }

  Widget _buildReactionCard(BuildContext context, {
    required String title,
    required String description,
    required List<String> latexEquations,
    required IconData icon,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cabeçalho
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 20),
                
                // Box de Equações
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                       Text(
                        "ESTEQUIOMETRIA",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: isDark ? Colors.grey[500] : Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 8),

                      ...latexEquations.map((eq) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Math.tex(
                            eq,
                            textStyle: TextStyle(
                              fontSize: 16,
                              color: isDark ? Colors.green[300] : Colors.blue[900],
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}