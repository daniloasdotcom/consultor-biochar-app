import 'package:flutter/material.dart';

class BiocharRisksScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const BiocharRisksScreen({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final backgroundColor = isDark ? const Color(0xFF121212) : const Color(0xFFFFF8F6); // Fundo levemente avermelhado no light mode para remeter a "atenção"
    final textColor = isDark ? Colors.white : const Color(0xFF2D3748);
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Riscos & Análises',
          style: TextStyle(
            fontFamily: 'Merriweather',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        actions: [
          IconButton(onPressed: onToggleTheme, icon: const Icon(Icons.brightness_6)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Text(
              "Checklist de Laboratório",
              style: TextStyle(
                fontFamily: 'Merriweather',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "O que buscar nos laudos de certificação para garantir a segurança do material.",
              style: TextStyle(fontSize: 14, color: subTextColor, height: 1.5),
            ),
            const SizedBox(height: 24),

            // --- RISCO 1: HPAs (Crítico) ---
            _RiskCard(
              context,
              riskLevel: "CRÍTICO",
              title: "1. HPAs",
              subtitle: "Hidrocarbonetos Policíclicos Aromáticos",
              icon: Icons.warning, // Ícone de perigo
              color: Colors.red[700]!, // Vermelho alerta
              contentMap: {
                "O que são": "Compostos orgânicos cancerígenos e mutagênicos (ex: Benzo[a]pireno).",
                "Origem": "Fumaça condensada (alcatrão) sobre o biochar devido a falhas no controle da pirólise.",
                "O Teste": "Certificações limitam rigorosamente. Excesso de alcatrão mata a microbiologia do solo.",
              },
            ),

            const SizedBox(height: 16),

            // --- RISCO 2: Metais Pesados ---
            _RiskCard(
              context,
              riskLevel: "ALTO",
              title: "2. Metais Pesados",
              subtitle: "Pb, Cd, Hg, As, Cr, Ni, Zn, Cu",
              icon: Icons.science,
              color: Colors.deepOrange,
              contentMap: {
                "O que são": "Elementos tóxicos que não se degradam.",
                "Origem": "Biomassa contaminada (madeira pintada/tratada ou lodo de esgoto). A pirólise concentra esses metais.",
                "O Teste": "Impede a entrada de metais na cadeia alimentar (solo → planta → humano).",
              },
            ),

            const SizedBox(height: 16),

            // --- RISCO 3: PCBs e Dioxinas ---
            _RiskCard(
              context,
              riskLevel: "ALTO",
              title: "3. PCBs e Dioxinas",
              subtitle: "Poluentes Orgânicos Persistentes",
              icon: Icons.warning_amber,
              color: Colors.purple,
              contentMap: {
                "O que são": "Poluentes altamente tóxicos e persistentes.",
                "Origem": "Biomassa contendo plásticos, cloro ou tratamentos químicos.",
                "O Teste": "O EBC é extremamente rígido para evitar 'esconder' lixo industrial no biochar.",
              },
            ),

            const SizedBox(height: 16),

            // --- RISCO 4: Estabilidade (H/C) ---
            _RiskCard(
              context,
              riskLevel: "EFICÁCIA",
              title: "4. Estabilidade (Razão H/C)",
              subtitle: "Qualidade da Pirólise",
              icon: Icons.timer,
              color: Colors.blue[700]!,
              contentMap: {
                "O Risco": "Se a pirólise for incompleta, é apenas 'madeira torrada'. Decompõe rápido e rouba nitrogênio.",
                "O Teste": "Mede a razão Hidrogênio/Carbono. Se for alta, o material é instável e não sequestra carbono.",
              },
            ),

            const SizedBox(height: 16),

            // --- RISCO 5: pH e Salinidade ---
            _RiskCard(
              context,
              riskLevel: "MANEJO",
              title: "5. pH e Salinidade",
              subtitle: "Condutividade Elétrica",
              icon: Icons.eco_outlined,
              color: Colors.teal[700]!,
              contentMap: {
                "O Risco": "Biochars de esterco/comida podem ter sais altíssimos, queimando raízes.",
                "O Teste": "Checagem de pH e Condutividade Elétrica para evitar choque osmótico nas plantas.",
              },
            ),

            const SizedBox(height: 30),

            // --- Comparação de Rigor ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : const Color(0xFFEDF2F7),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.compare_arrows, color: textColor),
                      const SizedBox(width: 10),
                      Text(
                        "Diferença de Rigor",
                        style: TextStyle(
                          fontFamily: 'Merriweather',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildComparisonRow(
                    context, 
                    "IBI", 
                    "Foca nos limites seguros para aplicação geral no solo.",
                    Colors.blue[800]!
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 12),
                  _buildComparisonRow(
                    context, 
                    "EBC", 
                    "Sistema de Classes. A classe 'EBC-Feed' (animal) é muito mais rigorosa que a de solo, pois o risco de contaminação do leite/carne é imediato.",
                    Colors.green[800]!
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonRow(BuildContext context, String label, String text, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14, 
              color: isDark ? Colors.grey[300] : Colors.grey[800],
              height: 1.4
            ),
          ),
        ),
      ],
    );
  }
}

class _RiskCard extends StatelessWidget {
  final BuildContext context;
  final String riskLevel;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Map<String, String> contentMap;

  const _RiskCard(
    this.context, {
    required this.riskLevel,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.contentMap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(left: BorderSide(color: color, width: 6)), // Faixa lateral de alerta
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Merriweather',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: color, width: 1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  riskLevel,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              )
            ],
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          children: contentMap.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key.toUpperCase(),
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.value,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: isDark ? Colors.grey[300] : Colors.grey[800],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}