import 'package:flutter/material.dart';

// --- CONSTANTES DE COR (Mantendo o padrão) ---
class AppColors {
  static const primary = Color(0xFF2E7D32);
  static const primaryDark = Color(0xFF1B5E20);
  static const warning = Color(0xFFF57C00); // Laranja para alertas
  static const danger = Color(0xFFD32F2F); // Vermelho para riscos
  static const neutral = Color(0xFF455A64); // Cinza azulado para técnica
}

class EvaluationFactorsScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const EvaluationFactorsScreen({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    // Lógica de tema
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.grey[50];
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white70 : Colors.black87;
    final titleColor = isDark ? Colors.white : AppColors.primaryDark;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          "Fatores de Avaliação",
          style: TextStyle(
            fontFamily: 'Merriweather',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: onToggleTheme,
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "O que observar ao analisar resultados de experimentos com biocarvão?",
              style: TextStyle(
                fontSize: 16, 
                color: textColor,
                fontFamily: 'Merriweather',
                height: 1.4
              ),
            ),
            const SizedBox(height: 24),

            // --- 1. DOSE ---
            SectionHeader(
              title: "1. A Dose",
              icon: Icons.scale_outlined,
              textColor: titleColor,
              iconColor: AppColors.warning,
            ),
            const SizedBox(height: 12),
            _buildDoseCard(cardColor, textColor, isDark),

            const SizedBox(height: 32),

            // --- 2. GRANULOMETRIA ---
            SectionHeader(
              title: "2. Granulometria (Tamanho)",
              icon: Icons.grain,
              textColor: titleColor,
              iconColor: AppColors.neutral,
            ),
            const SizedBox(height: 12),
            _buildGranulometryCard(cardColor, textColor, isDark),

            const SizedBox(height: 32),

             // --- 3. TEMPERATURA ---
            SectionHeader(
              title: "3. Temperatura de Pirólise",
              icon: Icons.thermostat,
              textColor: titleColor,
              iconColor: Colors.redAccent,
            ),
            const SizedBox(height: 12),
            _buildTemperatureCard(cardColor, textColor, isDark),

            const SizedBox(height: 32),

            // --- 4. TIPO DE SOLO ---
            SectionHeader(
              title: "4. O Cenário (Tipo de Solo)",
              icon: Icons.landscape_outlined,
              textColor: titleColor,
              iconColor: Colors.brown,
            ),
            const SizedBox(height: 12),
            _buildSoilTypeCard(cardColor, textColor, isDark),

            const SizedBox(height: 32),

            // --- 5. FORMA DE APLICAÇÃO ---
            SectionHeader(
              title: "5. Forma de Aplicação",
              icon: Icons.layers_outlined,
              textColor: titleColor,
              iconColor: AppColors.primary,
            ),
            const SizedBox(height: 12),
            
            _buildApplicationCard(cardColor, textColor, isDark),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS ESPECÍFICOS ---

  // 1. CARD DE DOSE
  Widget _buildDoseCard(Color bg, Color text, bool isDark) {
    return Card(
      color: bg,
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: isDark ? Colors.grey[800]! : Colors.grey[300]!)
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.trending_up, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Relação Dose-Resposta", 
                    style: TextStyle(fontWeight: FontWeight.bold, color: text, fontSize: 16)
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Quanto maior a dose, maior tende a ser a magnitude dos efeitos observados.",
              style: TextStyle(color: text, height: 1.3),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.danger.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.danger.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppColors.danger),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Cuidado: Doses excessivas podem resultar em efeitos negativos (salinização, bloqueio de nutrientes).",
                      style: TextStyle(
                        fontSize: 13, 
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.red[200] : Colors.red[900]
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // 2. CARD DE GRANULOMETRIA (Comparativo)
  Widget _buildGranulometryCard(Color bg, Color text, bool isDark) {
    return Column(
      children: [
        _buildCompareRow(
          bg, text, isDark,
          title: "Partículas Finas (Pó)",
          icon: Icons.blur_on,
          pros: "Alta área específica. Interage muito com íons e água.",
          cons: "Pode destruir poros internos (capilares) durante a moagem.",
        ),
        const SizedBox(height: 10),
        _buildCompareRow(
          bg, text, isDark,
          title: "Partículas Grosseiras",
          icon: Icons.circle_outlined,
          pros: "Preserva a estrutura porosa original e a aeração.",
          cons: "Menor distribuição espacial no solo (menos contato).",
        ),
      ],
    );
  }

  Widget _buildCompareRow(Color bg, Color text, bool isDark, {required String title, required IconData icon, required String pros, required String cons}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[300]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.neutral, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: text)),
                const SizedBox(height: 4),
                Text("👍 $pros", style: TextStyle(fontSize: 13, color: text.withOpacity(0.9), height: 1.3)),
                const SizedBox(height: 4),
                Text("👎 $cons", style: TextStyle(fontSize: 13, color: text.withOpacity(0.7), height: 1.3)),
              ],
            ),
          )
        ],
      ),
    );
  }

  // 3. CARD DE TEMPERATURA
  Widget _buildTemperatureCard(Color bg, Color text, bool isDark) {
    return Card(
      color: bg,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: isDark ? Colors.grey[800]! : Colors.grey[300]!)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "A temperatura de produção (pirólise) define a 'personalidade' do biocarvão:",
              style: TextStyle(fontWeight: FontWeight.w500, color: text),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTempItem("Baixa Temp", "< 400°C", "Mais nutrientes\nMais voláteis", Colors.orange),
                Container(width: 1, height: 40, color: Colors.grey),
                _buildTempItem("Alta Temp", "> 550°C", "Mais porosidade\nMais estabilidade", Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTempItem(String title, String temp, String desc, Color color) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color)),
        Text(temp, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(desc, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  // 4. CARD TIPO DE SOLO
  Widget _buildSoilTypeCard(Color bg, Color text, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.brown.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.terrain, color: Colors.amber),
            title: Text("Solos Ácidos / Pobres", style: TextStyle(fontWeight: FontWeight.bold, color: text)),
            subtitle: Text(
              "Maior Impacto. O biocarvão atua como corretivo de pH e reservatório de nutrientes, apresentando grandes ganhos de produtividade.",
              style: TextStyle(color: text.withOpacity(0.8), fontSize: 13),
            ),
          ),
          Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
          ListTile(
            leading: const Icon(Icons.grass, color: Colors.green),
            title: Text("Solos Férteis / Equilibrados", style: TextStyle(fontWeight: FontWeight.bold, color: text)),
            subtitle: Text(
              "Menor Impacto. Em condições ótimas, a aplicação pode não resultar em ganhos visíveis de nutrição ou produtividade no curto prazo.",
              style: TextStyle(color: text.withOpacity(0.8), fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // 5. CARD DE APLICAÇÃO
  Widget _buildApplicationCard(Color bg, Color text, bool isDark) {
    return Card(
      color: bg,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: isDark ? Colors.grey[800]! : Colors.grey[300]!)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Superficial
            _buildAppMethod(
              icon: Icons.vertical_align_top,
              title: "Aplicação Superficial",
              desc: "Risco de 'Quimiotropismo': Raízes se concentram na superfície buscando nutrientes, ficando vulneráveis. \n⚠️ Risco de perdas por erosão (chuva/vento).",
              color: AppColors.warning,
              isDark: isDark,
              text: text
            ),
            const Divider(height: 24),
            // Incorporada
            _buildAppMethod(
              icon: Icons.vertical_align_center,
              title: "Incorporação ao Solo",
              desc: "Ideal. Distribui o biocarvão na zona das raízes (rizosfera), homogeneizando os benefícios no volume de solo explorado.",
              color: AppColors.primary,
              isDark: isDark,
              text: text
            ),
             const Divider(height: 24),
            // Concentrada
            _buildAppMethod(
              icon: Icons.gps_fixed,
              title: "Doses Concentradas",
              desc: "Se mal misturado, cria 'Hotspots': pontos extremos de pH, retenção de água e nutrientes que podem desequilibrar o crescimento local.",
              color: Colors.purple,
              isDark: isDark,
              text: text
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppMethod({required IconData icon, required String title, required String desc, required Color color, required bool isDark, required Color text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black87)),
              const SizedBox(height: 4),
              Text(desc, style: TextStyle(fontSize: 13, color: text, height: 1.3)),
            ],
          ),
        )
      ],
    );
  }
}

// Reutilização simples do Header
class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color textColor;
  final Color iconColor;

  const SectionHeader({super.key, required this.title, required this.icon, required this.textColor, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(width: 10),
        Expanded(child: Text(title, style: TextStyle(fontSize: 18, fontFamily: 'Merriweather', fontWeight: FontWeight.bold, color: textColor))),
      ],
    );
  }
}