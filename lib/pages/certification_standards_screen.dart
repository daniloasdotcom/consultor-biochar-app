import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart'; // (Opcional) Adicione se quiser abrir os links reais

class CertificationStandardsScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const CertificationStandardsScreen({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Paleta de Cores
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA);
    final sectionHeaderColor = isDark ? Colors.white : const Color(0xFF2D3748);
    
    // Cores específicas para identidade das marcas
    final ibiColor = isDark ? const Color(0xFF1565C0) : const Color(0xFF0D47A1); // Azul Profundo
    final ebcColor = isDark ? const Color(0xFF2E7D32) : const Color(0xFF1B5E20); // Verde Floresta

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          'Padrões Mundiais',
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
            // --- INTRODUÇÃO: A IMPORTÂNCIA ---
            _buildImportanceSection(context, isDark),
            const SizedBox(height: 24),

            // --- TÍTULO SEPARADOR ---
            Text(
              "As Autoridades",
              style: TextStyle(
                fontFamily: 'Merriweather',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: sectionHeaderColor,
              ),
            ),
            const SizedBox(height: 16),

            // 

            // --- CARD IBI ---
            _buildOrgCard(
              context,
              title: "IBI",
              subtitle: "International Biochar Initiative",
              tagline: "A Voz Global & Comunidade",
              description: "Associação global sem fins lucrativos focada em educação, promoção e normas técnicas. Une indústria e academia.",
              detailsMap: {
                "Quem Criou": "Fundada em 2006 (Dr. Johannes Lehmann/Cornell). Gerenciado por conselho internacional.",
                "Foco": "Segurança do solo, Networking e Educação (Biochar Academy).",
                "Serviços": "• Certificação IBI Certified™\n• Webinars Técnicos\n• Defesa de Políticas Públicas",
              },
              accessSteps: [
                "Acesse biochar-international.org",
                "Baixe os manuais na aba 'Certification'",
                "Envie amostras para laboratório credenciado",
                "Torne-se membro para descontos"
              ],
              color: ibiColor,
              icon: Icons.public,
            ),

            const SizedBox(height: 20),

            // --- CARD EBC ---
            _buildOrgCard(
              context,
              title: "EBC",
              subtitle: "European Biochar Certificate",
              tagline: "O Padrão Industrial Rigoroso",
              description: "Certificação técnica que funciona como um selo de qualidade (ISO) para todo o ciclo de produção.",
              detailsMap: {
                "Quem Criou": "Ithaka Institute (Suíça). Auditoria pela Carbon Standards International (CSI).",
                "Foco": "Alta tecnologia, Créditos de Carbono e Mercado Europeu.",
                "Serviços": "• Certificação por Classes (Feed, Agro, Urban)\n• Registro de C-Sink (Créditos)\n• Auditoria de Fábrica",
              },
              accessSteps: [
                "Acesse carbon-standards.com",
                "Registre a fábrica antes de vender",
                "Auditoria presencial ou remota da planta",
                "Testes regulares a cada lote produzido"
              ],
              color: ebcColor,
              icon: Icons.verified,
            ),

            const SizedBox(height: 30),
            
            // --- DICA FINAL ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.orange.withOpacity(0.1) : Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline, color: Colors.orange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: isDark ? Colors.grey[300] : Colors.grey[800],
                          height: 1.4,
                        ),
                        children: const [
                          TextSpan(
                            text: "Dica de Exportação: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: "Vai exportar para a Europa ou vender créditos premium (Puro.earth)? Foque no ",
                          ),
                          TextSpan(
                            text: "EBC",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: ". Para pesquisa e mercado das Américas, o IBI é a referência.",
                          ),
                        ],
                      ),
                    ),
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

  // Widget da Seção de Importância (Topo)
  Widget _buildImportanceSection(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
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
        children: [
          Row(
            children: [
              Icon(Icons.shield, color: isDark ? Colors.grey[400] : Colors.grey[700]),
              const SizedBox(width: 10),
              Text(
                "Por que eles existem?",
                style: TextStyle(
                  fontFamily: 'Merriweather',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Eles transformam 'resíduo queimado' em 'tecnologia'. Sem o IBI e EBC, o mercado seria inundado por material tóxico. Eles são o passaporte para vender créditos de carbono de alto valor e garantem a segurança alimentar.",
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              height: 1.5,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // Widget do Cartão da Organização (Design Elegante)
  Widget _buildOrgCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String tagline,
    required String description,
    required Map<String, String> detailsMap,
    required List<String> accessSteps,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: color, width: 4)), // Identidade visual lateral
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontFamily: 'Merriweather',
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: color,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subtitle,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                tagline,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          children: [
            const Divider(),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),
            
            // Detalhes (Grid ou Lista)
            ...detailsMap.entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: const TextStyle(fontSize: 14, height: 1.4),
                    ),
                  ),
                ],
              ),
            )),

            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.white.withOpacity(0.05) 
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.login, size: 16, color: color),
                      const SizedBox(width: 8),
                      Text(
                        "Como Acessar",
                        style: TextStyle(fontWeight: FontWeight.bold, color: color),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Lista de passos
                  ...accessSteps.asMap().entries.map((entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${entry.key + 1}. ", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Expanded(child: Text(entry.value, style: const TextStyle(fontSize: 13))),
                      ],
                    ),
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}