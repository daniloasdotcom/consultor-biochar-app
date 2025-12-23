import 'package:biochar_consulting/liming/alkalinity_sources.dart';
import 'package:biochar_consulting/liming/reference_card.dart';
import 'package:flutter/material.dart';
import 'biochar_data.dart'; 
import 'models.dart'; 
import 'methodology_cards.dart';

class SolubilityPage extends StatelessWidget {
  final VoidCallback? onToggleTheme;

  const SolubilityPage({
    super.key,
    this.onToggleTheme,
  });

  // Base de dados dos produtos
  final List<LimingAgent> agents = const [
    LimingAgent(
      name: "Calcário Calcítico",
      chemicalName: "Carbonato de Cálcio",
      formula: "CaCO₃",
      solubility: "0.013 g/L",
      level: "Baixíssima",
      description: "Reação lenta no solo. Deve ser aplicado com antecedência (3 meses). Pouca mobilidade no perfil.",
      color: Colors.brown,
    ),
    LimingAgent(
      name: "Calcário Dolomítico",
      chemicalName: "Carbonato de Ca e Mg",
      formula: "CaMg(CO₃)₂",
      solubility: "~0.01 - 0.1 g/L",
      level: "Baixa",
      description: "Reação lenta. Fonte importante de Magnésio. Baixa mobilidade vertical.",
      color: Colors.brown,
    ),
    LimingAgent(
      name: "Cal Hidratada (Agrícola)",
      chemicalName: "Hidróxido de Cálcio",
      formula: "Ca(OH)₂",
      solubility: "1.6 g/L",
      level: "Média",
      description: "Reação rápida. Ideal para correções de emergência, mas possui menor efeito residual que o calcário.",
      color: Colors.teal,
    ),
    LimingAgent(
      name: "Cal Virgem",
      chemicalName: "Óxido de Cálcio",
      formula: "CaO",
      solubility: "Reage violentamente",
      level: "Alta Reatividade",
      description: "Transforma-se em hidróxido ao contato com água. Ação imediata e cáustica.",
      color: Colors.orange,
    ),
    LimingAgent(
      name: "Gesso Agrícola*",
      chemicalName: "Sulfato de Cálcio",
      formula: "CaSO₄·2H₂O",
      solubility: "2.4 g/L",
      level: "Alta",
      description: "*Condicionador (não corrige pH). Devido à alta solubilidade, carreia nutrientes para o subsolo.",
      color: Colors.blue,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Lógica de Tema Global da Página
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF121212) : const Color(0xFFFFF8F6);
    final appBarColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFF4CAF50);
    final foregroundColor = isDark ? Colors.white : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Solubilidade e Química",
          style: TextStyle(
            fontFamily: 'Merriweather',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: appBarColor,
        foregroundColor: foregroundColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          if (onToggleTheme != null)
            IconButton(
              icon: const Icon(Icons.brightness_6),
              onPressed: onToggleTheme,
              tooltip: 'Alternar Tema',
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Título da Seção
          Text(
            "Análise Química",
            style: TextStyle(
              fontFamily: 'Merriweather',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Comparativo entre corretivos convencionais e biocarvão.",
            style: TextStyle(
              fontSize: 14, 
              color: isDark ? Colors.grey[400] : Colors.grey[700], 
              height: 1.5
            ),
          ),
          const SizedBox(height: 24),

          _AgentsGroupExpandable(agents: agents),
          const SizedBox(height: 16),
          const _ComparativeAnalysisCard(),

          const SizedBox(height: 16),
          // Importado (Assume-se que MethodologyCard já está refatorado conforme pedido anterior)
          const MethodologyCard(), 

          const SizedBox(height: 16),
          // Importado (Assume-se que LimingMethodCard já está refatorado conforme pedido anterior)
          const LimingMethodCard(),
          
          const SizedBox(height: 16),
          const _BiocharTableExpandable(),
          
          const SizedBox(height: 16),
          // Importado (Assume-se que BiocharAlkalinitySourcesCard já está refatorado conforme pedido anterior)
          const BiocharAlkalinitySourcesCard(),
          
          const SizedBox(height: 16),
          const _ConversionExplanationCard(),

          const SizedBox(height: 16),
          // Reutilização do card (proposital conforme original?)
          const MethodologyCard(),

          const SizedBox(height: 16),
          const ReferenceExplanationCard(),
        ],
      ),
    );
  }
}

// ==========================================
// WIDGETS LOCAIS REFATORADOS
// ==========================================

// --- Grupo de Agentes ---
class _AgentsGroupExpandable extends StatelessWidget {
  final List<LimingAgent> agents;
  const _AgentsGroupExpandable({required this.agents});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final primaryColor = Colors.green[700]!;

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
          initiallyExpanded: false,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: primaryColor.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(Icons.water_drop, color: primaryColor, size: 28),
          ),
          title: Text(
            "Agentes de Calagem", 
            style: TextStyle(
              fontFamily: 'Merriweather',
              fontWeight: FontWeight.bold, 
              fontSize: 16, 
              color: isDark ? Colors.white : Colors.black87
            )
          ),
          subtitle: Text(
            "Lista de solubilidade", 
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey[400] : Colors.grey[600]
            )
          ),
          children: [
            Divider(color: isDark ? Colors.grey[800] : Colors.grey[200]),
            ...agents.map((agent) => _AgentDetailItem(agent: agent)),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _AgentDetailItem extends StatelessWidget {
  final LimingAgent agent;
  const _AgentDetailItem({required this.agent});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: agent.color, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  agent.name, 
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 15,
                    color: isDark ? Colors.white : Colors.black87
                  )
                )
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[700] : Colors.white, 
                  border: Border.all(color: isDark ? Colors.grey[600]! : Colors.grey.shade300), 
                  borderRadius: BorderRadius.circular(4)
                ),
                child: Text(
                  agent.formula, 
                  style: TextStyle(
                    fontFamily: 'Courier New', 
                    fontSize: 12, 
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.grey[300] : Colors.black87
                  )
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            agent.chemicalName, 
            style: TextStyle(
              fontStyle: FontStyle.italic, 
              color: isDark ? Colors.grey[400] : Colors.grey[600], 
              fontSize: 12
            )
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.opacity, size: 16, color: agent.color),
              const SizedBox(width: 8),
              Expanded(
                child: Text.rich(TextSpan(
                  text: "Solubilidade: ", 
                  style: TextStyle(fontSize: 13, color: isDark ? Colors.grey[300] : Colors.black87),
                  children: [
                    TextSpan(text: agent.solubility, style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: " (${agent.level})", style: TextStyle(color: agent.color, fontWeight: FontWeight.w600)),
                  ],
                )),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            agent.description, 
            style: TextStyle(fontSize: 13, color: isDark ? Colors.grey[400] : Colors.grey[700])
          ),
        ],
      ),
    );
  }
}

// --- Card Comparativo ---
class _ComparativeAnalysisCard extends StatelessWidget {
  const _ComparativeAnalysisCard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final primaryColor = const Color(0xFF2E7D32); // Green 800

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
      child: Column(
        children: [
          // Header customizado para o novo estilo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.science, color: primaryColor, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Insight: Calcário vs. Biocarvão",
                    style: TextStyle(
                      fontFamily: 'Merriweather',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          _ComparisonSection(
            title: "Convencional (Calcário/Cal)",
            icon: Icons.layers,
            iconColor: Colors.brown,
            backgroundColor: isDark ? Colors.orange.withOpacity(0.1) : Colors.orange.withOpacity(0.05),
            pros: const ["Neutralização efetiva da acidez.", "Tecnologia consolidada."],
            cons: const ["Risco de Supercalagem (Mg, K).", "Fixação de Fósforo (P).", "Supressão microbiana."],
            solutions: const ["Usar análise de solo química.", "Monitorar Saturação por Bases (V%)."],
          ),
          Divider(height: 1, color: isDark ? Colors.grey[800] : Colors.grey[300]),
          _ComparisonSection(
            title: "Alternativa (Biocarvão)",
            icon: Icons.local_fire_department,
            iconColor: isDark ? Colors.grey[400]! : Colors.grey.shade800,
            backgroundColor: isDark ? Colors.grey.withOpacity(0.1) : Colors.grey.withOpacity(0.05),
            pros: const ["Melhora física do solo.", "Retenção de nutrientes e Carbono."],
            cons: const ["Eficácia muito variável.", "Pode não elevar pH rápido o suficiente."],
          ),
        ],
      ),
    );
  }
}

// --- Tabela de Biochar ---
class _BiocharTableExpandable extends StatelessWidget {
  const _BiocharTableExpandable();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final primaryColor = Colors.grey[700]!;

    final sortedData = List<Map<String, String>>.from(biocharData)
      ..sort((a, b) => double.parse(b['cce']!).compareTo(double.parse(a['cce']!)));

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(left: BorderSide(color: primaryColor, width: 6)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: isDark ? Colors.grey[800] : Colors.grey[200], shape: BoxShape.circle),
            child: Icon(Icons.table_chart, color: isDark ? Colors.white : Colors.black87, size: 20),
          ),
          title: Text(
            "Variabilidade do Biocarvão", 
            style: TextStyle(
              fontFamily: 'Merriweather',
              fontSize: 16, 
              fontWeight: FontWeight.bold, 
              color: isDark ? Colors.white : Colors.black87
            )
          ),
          subtitle: Text(
            "Tabela Completa", 
            style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontSize: 12)
          ),
          children: [
            Divider(color: isDark ? Colors.grey[800] : Colors.grey[200]),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(16),
              child: Theme(
                // Força o estilo da tabela para escuro/claro
                data: Theme.of(context).copyWith(
                  dataTableTheme: DataTableThemeData(
                    headingRowColor: MaterialStateProperty.all(isDark ? Colors.grey[800] : Colors.grey[100]),
                    dataTextStyle: TextStyle(color: isDark ? Colors.grey[300] : Colors.black87),
                  )
                ),
                child: DataTable(
                  columnSpacing: 20,
                  columns: const [
                    DataColumn(label: Text('Biocarvão', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Fonte', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('CCE\n(g/kg)', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('meq/g\n(Calc)', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo))),
                  ],
                  rows: sortedData.map((item) {
                    final cceVal = double.tryParse(item['cce']!) ?? 0;
                    final meqVal = cceVal / 50; 
                    final isHigh = cceVal > 80;
                    final highlightColor = isDark ? Colors.green.withOpacity(0.2) : Colors.green.withOpacity(0.1);

                    return DataRow(cells: [
                      DataCell(Text(item['name']!, style: const TextStyle(fontWeight: FontWeight.bold))),
                      DataCell(Text(item['source']!)),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: isHigh ? BoxDecoration(color: highlightColor, borderRadius: BorderRadius.circular(4)) : null,
                          child: Text(
                            item['cce']!, 
                            style: TextStyle(
                              fontWeight: isHigh ? FontWeight.bold : FontWeight.normal, 
                              color: isHigh ? Colors.green[700] : (isDark ? Colors.grey[300] : Colors.black87)
                            )
                          ),
                        )
                      ),
                      DataCell(Text(meqVal.toStringAsFixed(2), style: TextStyle(color: isDark ? Colors.indigo[300] : Colors.indigo, fontWeight: FontWeight.w600))),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- CARD DE CONVERSÃO COMPLETO (REFATORADO) ---
class _ConversionExplanationCard extends StatelessWidget {
  const _ConversionExplanationCard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final primaryColor = const Color(0xFF5E35B1); // Deep Purple

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
      child: Column(
        children: [
          // Header Estilizado
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.functions, color: primaryColor, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Cálculo: meq/g para Equivalente CaCO₃",
                    style: TextStyle(
                      fontFamily: 'Merriweather',
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
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Como converter a acidez neutralizada (meq/g) em CCE (%)?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 15,
                    color: isDark ? Colors.grey[200] : Colors.black87
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "A unidade meq/g mede a densidade de carga. Para converter em massa equivalente de CaCO₃, usamos a massa molar do calcário (100 g/mol) e sua valência (2).",
                  style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[800], fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 16),

                // Passo 1: A constante
                _buildStep(
                  context,
                  "Passo 1: A Constante",
                  "1 meq CaCO₃ = 50 mg",
                  "Massa Molar (100) ÷ Valência (2) = 50.",
                  Colors.purple,
                ),

                // Passo 2: O Cálculo
                _buildStep(
                  context,
                  "Passo 2: Conversão de Unidade",
                  "Multiplicar por 50",
                  "Se você tem X meq/g, você tem X × 50 mg de CaCO₃ por grama de material.",
                  Colors.indigo,
                ),

                 // Passo 3: Porcentagem
                _buildStep(
                  context,
                  "Passo 3: Transformar em %",
                  "Dividir por 10",
                  "10 mg em 1g (1000mg) equivale a 1%. Portanto, dividimos os mg encontrados por 10.",
                  Colors.blue,
                ),

                const SizedBox(height: 16),

                // Fórmula Final
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black26 : Colors.grey[100],
                    border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text("FÓRMULA PRÁTICA", 
                        style: TextStyle(fontSize: 12, color: isDark ? Colors.grey[400] : Colors.grey[600], fontWeight: FontWeight.bold, letterSpacing: 1)),
                      const SizedBox(height: 8),
                      Text(
                        "CCE (%) = meq/g × 5",
                         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.deepPurple[200] : const Color(0xFF5E35B1)),
                      ),
                       const Text(
                        "ou",
                         style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        "CCE (g/kg) = meq/g × 50",
                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.deepPurple[200] : const Color(0xFF5E35B1)),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Exemplo Numérico
                 Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.orange.withOpacity(0.1) : const Color(0xFFFFF3E0), 
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: isDark ? Colors.orange.withOpacity(0.3) : Colors.orange.shade200)
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: isDark ? Colors.orange[300] : Colors.orange),
                      const SizedBox(width: 12),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: isDark ? Colors.grey[300] : Colors.grey[900], fontSize: 13),
                            children: const [
                              TextSpan(text: "Exemplo: ", style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: "Se um biocarvão tem capacidade de "),
                              TextSpan(text: "2 meq/g", style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: ", seu CCE será "),
                              TextSpan(text: "10%", style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: " (metade de um calcário fraco)."),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                 )

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(BuildContext context, String title, String mainValue, String subtext, MaterialColor colorBase) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? colorBase.withOpacity(0.1) : colorBase.shade50;
    final text = isDark ? colorBase.shade200 : colorBase.shade900;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: text, fontSize: 12)),
                const SizedBox(height: 4),
                Text(mainValue, style: TextStyle(fontWeight: FontWeight.w900, color: text, fontSize: 16)),
                const SizedBox(height: 4),
                Text(subtext, style: TextStyle(color: text.withOpacity(0.8), fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// --- Helper (Seções) ---
class _ComparisonSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final List<String> pros;
  final List<String> cons;
  final List<String>? solutions;

  const _ComparisonSection({
    required this.title, required this.icon, required this.iconColor, required this.backgroundColor, required this.pros, required this.cons, this.solutions,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(16),
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor), 
              const SizedBox(width: 8), 
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87))
            ]
          ),
          const SizedBox(height: 8),
          ...pros.map((t) => _buildItem(context, t, Colors.green, Icons.check)),
          ...cons.map((t) => _buildItem(context, t, Colors.red, Icons.close)),
          if (solutions != null) ...solutions!.map((t) => _buildItem(context, t, Colors.blue, Icons.build_circle_outlined)),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, String text, MaterialColor color, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: isDark ? color[300] : color),
          const SizedBox(width: 6),
          Expanded(child: Text(text, style: TextStyle(fontSize: 13, color: isDark ? Colors.grey[300] : Colors.black87))),
        ],
      ),
    );
  }
}