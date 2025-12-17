import 'package:flutter/material.dart';

class BiocharTransformationsScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const BiocharTransformationsScreen({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    // Lógica de tema (Dark/Light) consistente com a Home
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF121212) : Colors.grey[100] ?? Colors.white;
    final cardColor = isDark ? Colors.grey[850] ?? Colors.white : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.grey[400] ?? Colors.grey : Colors.grey[600] ?? Colors.grey;
    final connectorColor = isDark ? Colors.grey[700] ?? Colors.grey : Colors.grey[300] ?? Colors.grey;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Dinâmica no Solo',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Merriweather',
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Cabeçalho Explicativo
            _buildHeaderCard(cardColor, textColor, subTextColor),
            const SizedBox(height: 20),

            // Linha do Tempo
            // Estágio 1: Dissolução [cite: 47]
            _buildStageCard(
              context,
              stageNumber: 1,
              title: "Dissolução Rápida",
              duration: "1 a 3 semanas",
              icon: Icons.water_drop,
              color: const Color(0xFF1E88E5), // Azul vibrante
              description: "A água entra nos poros, dissolvendo compostos solúveis.",
              details: [
                "Aumento do Carbono Orgânico Dissolvido (DOC).",
                "Liberação rápida de sais e nutrientes (flash release).",
                "Alteração inicial do pH e condutividade elétrica."
              ],
              cardColor: cardColor,
              textColor: textColor,
              subTextColor: subTextColor,
            ),
            
            _buildConnector(connectorColor),

            // Estágio 2: Superfície Reativa [cite: 47]
            _buildStageCard(
              context,
              stageNumber: 2,
              title: "Superfícies Reativas",
              duration: "1 a 6 meses",
              icon: Icons.group_work, 
              color: const Color(0xFFFB8C00), // Laranja
              description: "Formação de camadas organo-minerais e interação com raízes.",
              details: [
                "Raízes penetram os poros do biocarvão.",
                "Criação de habitat para fungos e bactérias.",
                "Aumento da porosidade e retenção de N e P.",
                "Redução da lixiviação de nutrientes."
              ],
              cardColor: cardColor,
              textColor: textColor,
              subTextColor: subTextColor,
            ),

            _buildConnector(connectorColor),

            // Estágio 3: Envelhecimento [cite: 48]
            _buildStageCard(
              context,
              stageNumber: 3,
              title: "Envelhecimento (Aging)",
              duration: "Mais de 6 meses",
              icon: Icons.security, 
              color: const Color(0xFF43A047), // Verde
              description: "Integração aos agregados do solo e estabilização.",
              details: [
                "Proteção física do carbono em microagregados.",
                "Aumento da CTC via oxidação de superfícies.",
                "Sequestro de carbono por centenas de anos.",
                "Estabilização de novos resíduos vegetais."
              ],
              cardColor: cardColor,
              textColor: textColor,
              subTextColor: subTextColor,
            ),

            const SizedBox(height: 20),
            Text(
              "Baseado em Joseph et al. (2021) - GCB Bioenergy",
              style: TextStyle(color: subTextColor, fontStyle: FontStyle.italic, fontSize: 12),
            ),
             const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(Color bg, Color text, Color subText) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "O Biocarvão é Vivo",
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold, 
              color: text,
              fontFamily: 'Merriweather',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Suas propriedades mudam conforme interage com água, raízes e micróbios. Entenda os 3 estágios dessa transformação.",
            style: TextStyle(fontSize: 14, height: 1.5, color: subText),
          ),
        ],
      ),
    );
  }

  Widget _buildStageCard(
    BuildContext context, {
    required int stageNumber,
    required String title,
    required String duration,
    required IconData icon,
    required Color color,
    required String description,
    required List<String> details,
    required Color cardColor,
    required Color textColor,
    required Color subTextColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: stageNumber == 2, // Destaque visual inicial
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 16,
              color: textColor,
              fontFamily: 'Merriweather',
            ),
          ),
          subtitle: Text(
            duration,
            style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                description,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: textColor),
              ),
            ),
            const SizedBox(height: 12),
            ...details.map((detail) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, size: 16, color: color.withOpacity(0.7)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      detail, 
                      style: TextStyle(fontSize: 13, color: subTextColor, height: 1.3),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildConnector(Color color) {
    return SizedBox(
      height: 30,
      child: Center(
        child: Container(
          width: 2,
          color: color,
        ),
      ),
    );
  }
}