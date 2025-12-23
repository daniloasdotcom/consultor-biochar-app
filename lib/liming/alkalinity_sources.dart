import 'package:flutter/material.dart';

class BiocharAlkalinitySourcesCard extends StatelessWidget {
  const BiocharAlkalinitySourcesCard({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Lógica de Tema (Igual ao BiocharRisksScreen)
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final primaryTeal = Colors.teal[700]!;

    // 2. Container com Estilo Unificado (Sombra + Borda Esquerda)
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryTeal.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(left: BorderSide(color: primaryTeal, width: 6)),
      ),
      child: Theme(
        // Remove a linha divisória padrão do ExpansionTile se for usado, 
        // ou apenas para consistência visual interna
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header do Card
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryTeal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.pie_chart, color: primaryTeal, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Fontes da Alcalinidade",
                          style: TextStyle(
                            fontFamily: 'Merriweather', // Fonte Padrão do Projeto
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Baseado em Fidel et al. (2017)",
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              Text(
                "O biocarvão não corrige o solo apenas como o calcário. Sua alcalinidade vem de 4 fontes distintas:",
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey[300] : Colors.grey[800],
                  height: 1.4,
                ),
              ),
              
              const SizedBox(height: 20),

              // 1. Carbonatos
              _buildAlkalinityItem(
                context,
                title: "1. Carbonatos (Inorgânico)",
                subtitle: "CO₃²⁻ e HCO₃⁻",
                description: "Reação rápida e imediata. Geralmente a maior parte da alcalinidade em biochars de madeira.",
                icon: Icons.terrain,
                color: isDark ? Colors.amber[400]! : Colors.brown,
                isDark: isDark,
              ),

              Divider(color: isDark ? Colors.grey[800] : Colors.grey[200], height: 24),

              // 2. Outros Inorgânicos
              _buildAlkalinityItem(
                context,
                title: "2. Outros Inorgânicos",
                subtitle: "Fosfatos, Silicatos, Sulfatos",
                description: "Compostos solúveis comuns em biochars de esterco e resíduos de colheita.",
                icon: Icons.science,
                color: Colors.blueGrey,
                isDark: isDark,
              ),

              Divider(color: isDark ? Colors.grey[800] : Colors.grey[200], height: 24),

              // 3. Orgânico Estrutural (DESTAQUE)
              _buildAlkalinityItem(
                context,
                title: "3. Orgânico Estrutural (Baixo pKa)",
                subtitle: "Grupos Funcionais de Superfície",
                description: "O 'tesouro' do longo prazo. Contribui para a CTC e tamponamento do pH do solo.",
                icon: Icons.spa,
                color: Colors.green, // Mantém verde para consistência semântica
                isDark: isDark,
                isHighlight: true,
              ),

              Divider(color: isDark ? Colors.grey[800] : Colors.grey[200], height: 24),

              // 4. Outros Orgânicos
              _buildAlkalinityItem(
                context,
                title: "4. Outros Orgânicos",
                subtitle: "Ácidos Solúveis e Fenóis",
                description: "Ácidos orgânicos solúveis (ex: acetato). Varia muito conforme a pirólise.",
                icon: Icons.bubble_chart,
                color: Colors.lightGreen,
                isDark: isDark,
              ),

              const SizedBox(height: 20),
              
              // Box de Conclusão / Insight
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.teal.withOpacity(0.1) : Colors.teal[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? Colors.teal.withOpacity(0.3) : Colors.teal[100]!,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb, 
                      color: isDark ? Colors.tealAccent[400] : Colors.teal[800], 
                      size: 20
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 13, 
                            color: isDark ? Colors.teal[100] : Colors.teal[900],
                            height: 1.4,
                          ),
                          children: const [
                            TextSpan(text: "Insight Prático: ", style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: "Componentes inorgânicos corrigem a acidez agora (curto prazo), enquanto os orgânicos estruturais garantem a saúde do solo no futuro."),
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
      ),
    );
  }

  Widget _buildAlkalinityItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required Color color,
    required bool isDark,
    bool isHighlight = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Merriweather', // Uso consistente da fonte
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isHighlight 
                      ? color 
                      : (isDark ? Colors.grey[200] : Colors.black87),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: isDark ? Colors.grey[500] : Colors.grey[600],
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13, 
                  color: isDark ? Colors.grey[400] : Colors.grey[800], 
                  height: 1.3
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}