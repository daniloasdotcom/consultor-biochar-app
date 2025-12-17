import 'package:flutter/material.dart';

class BiocharRisksScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const BiocharRisksScreen({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? const Color(0xFF121212)
        : const Color(0xFFFFF8F6);
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
          IconButton(
            onPressed: onToggleTheme,
            icon: const Icon(Icons.brightness_6),
          ),
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
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Guia técnico de limites para certificação (EBC vs IBI).",
              style: TextStyle(fontSize: 14, color: subTextColor, height: 1.5),
            ),
            const SizedBox(height: 24),

            // --- RISCO 1: HPAs ---
            _RiskCard(
              context,
              riskLevel: "CRÍTICO",
              title: "1. HPAs",
              subtitle: "Hidrocarbonetos Policíclicos Aromáticos",
              icon: Icons.local_fire_department,
              color: Colors.red[700]!,
              contentMap: {
                "O que são":
                    "Compostos orgânicos cancerígenos (ex: Benzo[a]pireno).",
                "Origem": "Fumaça condensada (alcatrão) por falha térmica.",
                "O Teste":
                    "Certificações limitam rigorosamente (EBC < 4 mg/kg para Premium).",
              },
            ),

            const SizedBox(height: 16),

            // --- RISCO 2: Metais Pesados (NOVO: Expansível e Completo) ---
            const _HeavyMetalsDetailCard(),

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
                "O que são": "Poluentes industriais altamente tóxicos.",
                "Origem": "Biomassa com plásticos, cloro ou madeira tratada.",
                "O Teste": "Impede 'esconder' lixo industrial no biochar.",
              },
            ),

            const SizedBox(height: 16),

            // --- RISCO 4: Estabilidade H/C (NOVO: Widget Detalhado) ---
            const _HCRatioDetailCard(),

            const SizedBox(height: 30),

            // --- Nova Seção: Consultor & Comparativo ---
            _buildConsultantNote(context),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildConsultantNote(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFFFFBE6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.amber[900]! : Colors.amber[300]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: isDark ? Colors.amber : Colors.amber[800],
              ),
              const SizedBox(width: 10),
              Text(
                "Resumo do Consultor",
                style: TextStyle(
                  fontFamily: 'Merriweather',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark ? Colors.amber[100] : Colors.amber[900],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildBulletPoint(
            context,
            "EBC (Europa):",
            "Padrão ouro para mercado de Carbono. Reprova automaticamente se passar o limite.",
          ),
          _buildBulletPoint(
            context,
            "IBI (Mundo):",
            "Foca em harmonização. Usa valores de referência (MAT) que permitem análise de risco local.",
          ),
          _buildBulletPoint(
            context,
            "Estabilidade:",
            "Busque sempre H/Corg ≤ 0.6 para garantir permanência no solo por séculos.",
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(
    BuildContext context,
    String boldText,
    String normalText,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[800],
            fontSize: 13,
            height: 1.4,
          ),
          children: [
            TextSpan(
              text: "• $boldText ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: normalText),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// WIDGET 1: METAIS PESADOS (EXPANSÍVEL + COMPLETO)
// ============================================================================
class _HeavyMetalsDetailCard extends StatefulWidget {
  const _HeavyMetalsDetailCard();

  @override
  State<_HeavyMetalsDetailCard> createState() => _HeavyMetalsDetailCardState();
}

class _HeavyMetalsDetailCardState extends State<_HeavyMetalsDetailCard> {
  // 0 = EBC, 1 = IBI
  int _selectedStandard = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final primaryColor = Colors.deepOrange;

    // --- DADOS COMPLETOS EBC ---
    final ebcData = [
      {
        'sym': 'As',
        'name': 'Arsênio',
        'val': '≤ 13',
        'obs': 'Toxicidade elevada',
      },
      {
        'sym': 'Cd',
        'name': 'Cádmio',
        'val': '≤ 1.5',
        'obs': 'Muito restritivo',
      },
      {'sym': 'Pb', 'name': 'Chumbo', 'val': '≤ 150', 'obs': 'Solo e cadeia'},
      {
        'sym': 'Hg',
        'name': 'Mercúrio',
        'val': '≤ 1.0',
        'obs': 'Volátil / tóxico',
      },
      {'sym': 'Cr', 'name': 'Cromo', 'val': '≤ 90', 'obs': 'Cr(VI) proibido'},
      {'sym': 'Ni', 'name': 'Níquel', 'val': '≤ 50', 'obs': 'Fitotóxico'},
      {'sym': 'Cu', 'name': 'Cobre', 'val': '≤ 100', 'obs': 'Micronutriente'},
      {'sym': 'Zn', 'name': 'Zinco', 'val': '≤ 400', 'obs': 'Micronutriente'},
      {
        'sym': 'Mo',
        'name': 'Molibdênio',
        'val': '≤ 10',
        'obs': 'Risco ruminantes',
      },
      {'sym': 'Se', 'name': 'Selênio', 'val': '≤ 2', 'obs': 'Janela estreita'},
      {'sym': 'Co', 'name': 'Cobalto', 'val': '≤ 10', 'obs': 'Pouco tolerado'},
      {
        'sym': 'Ba',
        'name': 'Bário',
        'val': '≤ 300',
        'obs': 'Mobilidade moderada',
      },
      {'sym': 'V', 'name': 'Vanádio', 'val': '≤ 100', 'obs': 'Elemento traço'},
      {
        'sym': 'Ag',
        'name': 'Prata',
        'val': 'Declarar',
        'obs': 'Sem limite fixo',
      },
      {
        'sym': 'Sb',
        'name': 'Antimônio',
        'val': 'Declarar',
        'obs': 'Avaliação de risco',
      },
    ];

    // --- DADOS COMPLETOS IBI ---
    final ibiData = [
      {
        'sym': 'As',
        'name': 'Arsênio',
        'val': '13 – 100',
        'obs': 'Classificatório',
      },
      {
        'sym': 'Cd',
        'name': 'Cádmio',
        'val': '1.4 – 39',
        'obs': 'Classificatório',
      },
      {
        'sym': 'Pb',
        'name': 'Chumbo',
        'val': '121 – 300',
        'obs': 'Classificatório',
      },
      {
        'sym': 'Hg',
        'name': 'Mercúrio',
        'val': '1 – 17',
        'obs': 'Classificatório',
      },
      {
        'sym': 'Cr',
        'name': 'Cromo',
        'val': '93 – 1200',
        'obs': 'Classificatório',
      },
      {
        'sym': 'Ni',
        'name': 'Níquel',
        'val': '47 – 420',
        'obs': 'Classificatório',
      },
      {'sym': 'Cu', 'name': 'Cobre', 'val': '143 – 6k', 'obs': 'Ampla faixa'},
      {'sym': 'Zn', 'name': 'Zinco', 'val': '185 – 7.5k', 'obs': 'Ampla faixa'},
      {
        'sym': 'Mo',
        'name': 'Molibdênio',
        'val': '5 – 75',
        'obs': 'Classificatório',
      },
      {
        'sym': 'Se',
        'name': 'Selênio',
        'val': '2 – 200',
        'obs': 'Classificatório',
      },
      {
        'sym': 'Co',
        'name': 'Cobalto',
        'val': '34 – 100',
        'obs': 'Classificatório',
      },
      {
        'sym': 'Ba',
        'name': 'Bário',
        'val': '500 – 2k',
        'obs': 'Classificatório',
      },
      {
        'sym': 'V',
        'name': 'Vanádio',
        'val': '100 – 500',
        'obs': 'Classificatório',
      },
      {
        'sym': 'Ag',
        'name': 'Prata',
        'val': '1 – 100',
        'obs': 'Classificatório',
      },
      {
        'sym': 'Sb',
        'name': 'Antimônio',
        'val': '5 – 150',
        'obs': 'Classificatório',
      },
    ];

    final currentData = _selectedStandard == 0 ? ebcData : ibiData;
    final standardDesc = _selectedStandard == 0
        ? "Limites máximos EBC-Agro (mg/kg DM)."
        : "Faixas de referência IBI (mg/kg DM).";

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(left: BorderSide(color: primaryColor, width: 6)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.science, color: primaryColor, size: 28),
          ),
          title: Text(
            "2. Metais Pesados",
            style: TextStyle(
              fontFamily: 'Merriweather',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          subtitle: Text(
            "Tabela Completa EBC & IBI",
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          children: [
            // --- CONTEÚDO EXPANDIDO ---

            // Toggle Buttons
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(child: _buildTabButton("Norma EBC", 0, isDark)),
                  Expanded(child: _buildTabButton("Norma IBI", 1, isDark)),
                ],
              ),
            ),

            // Explicação
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                children: [
                  Icon(
                    _selectedStandard == 0 ? Icons.gavel : Icons.public,
                    size: 14,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      standardDesc,
                      style: TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tabela
            ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: currentData.length,
              separatorBuilder: (_, __) => Divider(
                color: isDark ? Colors.grey[800] : Colors.grey[100],
                height: 16,
              ),
              itemBuilder: (context, index) {
                final item = currentData[index];
                return Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[100],
                        border: Border.all(
                          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        item['sym']!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name']!,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: isDark
                                  ? Colors.grey[200]
                                  : Colors.grey[800],
                            ),
                          ),
                          Text(
                            item['obs']!,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? Colors.grey[500]
                                  : Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _selectedStandard == 0
                            ? Colors.green.withOpacity(0.1)
                            : Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item['val']!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: _selectedStandard == 0
                              ? Colors.green[700]
                              : Colors.blue[700],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, int index, bool isDark) {
    final isSelected = _selectedStandard == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedStandard = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.grey[700] : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2)]
              : [],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
            color: isSelected
                ? (isDark ? Colors.white : Colors.black87)
                : (isDark ? Colors.grey[400] : Colors.grey[600]),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// WIDGET 2: RAZÃO H/C (DESIGN ESPECÍFICO)
// ============================================================================
class _HCRatioDetailCard extends StatelessWidget {
  const _HCRatioDetailCard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final primaryColor = Colors.blue[700]!;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(left: BorderSide(color: primaryColor, width: 6)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.timer, color: primaryColor, size: 28),
          ),
          title: Text(
            "4. Estabilidade (H/C)",
            style: TextStyle(
              fontFamily: 'Merriweather',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          subtitle: Text(
            "O indicador de qualidade da pirólise",
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          children: [
            Text(
              "A razão H/C (Hidrogênio/Carbono) indica o grau de carbonização. Quanto menor o número, mais estável e aromático é o biocarvão.",
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey[300] : Colors.grey[800],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),

            // Seção EBC
            Row(
              children: [
                Icon(Icons.shield, size: 16, color: Colors.green[700]),
                const SizedBox(width: 8),
                Text(
                  "CRITÉRIOS EBC (OBRIGATÓRIO)",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildTableRow(context, "H/C ≤ 0.4", "Extremamente Estável", true),
            _buildTableRow(
              context,
              "0.4 – 0.6",
              "Alta Estabilidade (Premium)",
              true,
            ),
            _buildTableRow(
              context,
              "0.6 – 0.7",
              "Estável (Limite Aceitável)",
              true,
            ),
            _buildTableRow(context, "> 0.7", "🚫 Não Certificado", false),

            const SizedBox(height: 20),

            // Seção IBI
            Row(
              children: [
                Icon(Icons.public, size: 16, color: Colors.blue[800]),
                const SizedBox(width: 8),
                Text(
                  "CLASSES IBI (CLASSIFICATÓRIO)",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.blue[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildTableRow(
              context,
              "Classe 1",
              "≤ 0.7 (Alta Estabilidade)",
              true,
            ),
            _buildTableRow(context, "Classe 2", "0.7 – 1.5 (Moderada)", false),
            _buildTableRow(
              context,
              "Classe 3",
              "> 1.5 (Baixa Estabilidade)",
              false,
            ),

            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.green.withOpacity(0.1)
                    : Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "Recomendação: Busque sempre H/C ≤ 0.6 para máxima eficiência.",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableRow(
    BuildContext context,
    String col1,
    String col2,
    bool isGood,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 80,
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              col1,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isDark ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              col2,
              style: TextStyle(
                fontSize: 13,
                color: isGood
                    ? (isDark ? Colors.grey[300] : Colors.grey[800])
                    : (isDark
                          ? Colors.grey[500]
                          : Colors
                                .grey[500]), // "Apaga" um pouco o que não é ideal
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// WIDGET GENÉRICO (Mantido para HPAs e PCBs)
// ============================================================================
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
        border: Border(left: BorderSide(color: color, width: 6)),
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
              ),
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
