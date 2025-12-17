import 'package:flutter/material.dart';

class CertificationScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const CertificationScreen({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Cores dinâmicas
    final bgColor = isDark ? const Color(0xFF121212) : Colors.grey[50];
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white70 : Colors.black87;
    final titleColor = isDark ? Colors.white : AppColors.primaryDark;
    final iconColor = isDark ? Colors.lightGreenAccent[400] : AppColors.primaryDark;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Guia de Certificação"),
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
              "Entenda os custos operacionais, taxas e as regras técnicas para aprovar seu projeto.",
              style: TextStyle(fontSize: 16, color: textColor),
            ),
            const SizedBox(height: 24),

            // --- SEÇÃO 1: ALERTA TÉCNICO (Erosão) ---
            SectionHeader(
              title: "Aplicação e Perdas",
              icon: Icons.landscape_outlined,
              textColor: titleColor,
              iconColor: Colors.amber.shade700,
            ),
            const SizedBox(height: 8),
            ErosionWarningCard(isDark: isDark, cardColor: cardColor, textColor: textColor),
            const SizedBox(height: 32),

            // --- SEÇÃO 2: A DÚVIDA DO SOLO (NOVO) ---
            SectionHeader(
              title: "Como se mede o Carbono?",
              icon: Icons.science_outlined,
              textColor: titleColor,
              iconColor: Colors.blue.shade400,
            ),
            const SizedBox(height: 8),
            SoilAnalysisCard(isDark: isDark, cardColor: cardColor, textColor: textColor),
            const SizedBox(height: 32),

            // --- SEÇÃO 3: CUSTOS COMPLETOS (Solicitação atendida) ---
            SectionHeader(
              title: "Raio-X dos Custos",
              icon: Icons.monetization_on_outlined,
              textColor: titleColor,
              iconColor: iconColor!,
            ),
            const SizedBox(height: 8),
            CostSection(cardColor: cardColor, textColor: textColor, isDark: isDark),
            const SizedBox(height: 32),

            // --- SEÇÃO 4: CICLO ---
            SectionHeader(
              title: "O Ciclo do Projeto",
              icon: Icons.map_outlined,
              textColor: titleColor,
              iconColor: iconColor,
            ),
            const SizedBox(height: 16),
            StepList(textColor: textColor, isDark: isDark),
            
            const SizedBox(height: 32),
            
            // --- SEÇÃO 5: PADRÕES ---
            SectionHeader(
              title: "Exigências das Certificadoras",
              icon: Icons.verified_user_outlined,
              textColor: titleColor,
              iconColor: iconColor,
            ),
            const SizedBox(height: 16),
            CertificationsList(cardColor: cardColor, textColor: textColor, isDark: isDark),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// --- CONSTANTES DE COR ---
class AppColors {
  static const primary = Color(0xFF2E7D32);
  static const primaryDark = Color(0xFF1B5E20);
  static const moneyColor = Color(0xFF827717);
  static const moneyColorDark = Color(0xFFDCE775);
  static const expenseColor = Color(0xFFC62828); // Vermelho para custos
  static const expenseColorDark = Color(0xFFEF9A9A);
}

// --- WIDGETS ---

// 1. CARD SOBRE O SOLO (NOVO - Respondendo à sua dúvida técnica)
class SoilAnalysisCard extends StatelessWidget {
  final bool isDark;
  final Color cardColor;
  final Color textColor;

  const SoilAnalysisCard({super.key, required this.isDark, required this.cardColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: Colors.blue.shade400, width: 4)),
        boxShadow: isDark ? [] : [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Análise de Solo vs. Análise do Carvão",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black87),
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: TextStyle(color: textColor, height: 1.4, fontFamily: 'Roboto'), // Garante a fonte padrão
              children: [
                const TextSpan(text: "Onde se mede o Carbono? ", style: TextStyle(fontWeight: FontWeight.bold)),
                const TextSpan(text: "O crédito é calculado medindo o carbono NO BIOCARVÃO (em laboratório) ANTES da aplicação.\n\n"),
                const TextSpan(text: "Para que serve a Análise de Solo? ", style: TextStyle(fontWeight: FontWeight.bold)),
                const TextSpan(text: "As certificadoras exigem análise de solo apenas para "),
                TextSpan(
                  text: "segurança ambiental ",
                  style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.blue.shade200 : Colors.blue.shade800),
                ),
                const TextSpan(text: "(verificar se não há metais pesados ou contaminação prévia), e não para contar 'estoque de carbono' na terra."),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 2. CARD DE EROSÃO (Texto ajustado tecnicamente)
class ErosionWarningCard extends StatelessWidget {
  final bool isDark;
  final Color cardColor;
  final Color textColor;

  const ErosionWarningCard({super.key, required this.isDark, required this.cardColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: Colors.amber.shade700, width: 4)),
        boxShadow: isDark ? [] : [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Por que incorporar o biocarvão?",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(
            "O biocarvão é leve. Se aplicado na superfície, chuvas fortes podem lavá-lo para rios (erosão hídrica).",
            style: TextStyle(color: textColor, height: 1.3),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? Colors.amber.shade900.withOpacity(0.2) : Colors.amber.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.amber.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Impacto no Crédito: Se houver risco de o biocarvão 'ir embora', o auditor descontará esse risco do total de créditos gerados (Risco de Reversão).",
                    style: TextStyle(
                      fontSize: 13, 
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.amber.shade100 : Colors.brown.shade800
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// 3. CARD DE CUSTOS COMPLETO (Operacional + Taxas)
class CostSection extends StatelessWidget {
  final Color cardColor;
  final Color textColor;
  final bool isDark;

  const CostSection({super.key, required this.cardColor, required this.textColor, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PARTE A: Custos Operacionais (NOVO)
            _buildHeader("A. Custos Operacionais (Do Produtor)", Icons.agriculture, isDark),
            const SizedBox(height: 12),
            _buildCostItem("1. Aquisição/Produção", "Preço da biomassa ou compra do biocarvão pronto.", "Alto", isDark, isExpense: true),
            _buildCostItem("2. Aplicação no Solo", "Maquinário, combustível e mão-de-obra para incorporar.", "Médio", isDark, isExpense: true),
            _buildCostItem("3. Monitoramento Interno", "Coleta de dados, fotos e gestão da documentação.", "Baixo", isDark, isExpense: true),
            
            const Divider(height: 32),

            // PARTE B: Custos de Certificação
            _buildHeader("B. Custos de Certificação (Burocracia)", Icons.verified, isDark),
            const SizedBox(height: 12),
            _buildCostItem("1. Taxa de Registro", "Puro (Anual) ou Verra (Por projeto). Para abrir a conta.", "€ 5k - 10k", isDark),
            _buildCostItem("2. Auditoria (VVB)", "Paga ao auditor para vir à fazenda.", "US\$ 15k - 30k", isDark),
            _buildCostItem("3. Taxa de Emissão", "Paga por cada crédito gerado (Levy).", "~0.20€ / ton", isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 20, color: isDark ? Colors.grey[400] : Colors.grey[700]),
        const SizedBox(width: 8),
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black87)),
      ],
    );
  }

  Widget _buildCostItem(String title, String desc, String value, bool isDark, {bool isExpense = false}) {
    // Lógica de cor: Se for custo operacional, usa vermelho/rosa. Se for taxa, usa dourado.
    final valueColor = isExpense 
        ? (isDark ? AppColors.expenseColorDark : AppColors.expenseColor)
        : (isDark ? AppColors.moneyColorDark : AppColors.moneyColor);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: isDark ? Colors.white : Colors.black87)),
                Text(desc, style: TextStyle(fontSize: 12, color: isDark ? Colors.grey[400] : Colors.grey[600])),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: valueColor.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(4)
            ),
            child: Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: valueColor, fontSize: 11)),
          ),
        ],
      ),
    );
  }
}

// 4. PASSO A PASSO
class StepInfo {
  final String title;
  final String desc;
  final String responsible;

  const StepInfo(this.title, this.desc, this.responsible);
}

const List<StepInfo> steps = [
  StepInfo(
    '1. Viabilidade Financeira',
    'Consultor verifica se a produção paga os "Custos de Certificação". Geralmente, pequenos produtores precisam se agrupar.',
    'Resp: Consultor + Produtor',
  ),
  StepInfo(
    '2. Escrita do PDD',
    'Elaboração do plano técnico. Define-se a matéria-prima e o método de aplicação (incorporação para evitar perdas).',
    'Resp: Consultor',
  ),
  StepInfo(
    '3. Validação Inicial',
    'Auditor visita a fazenda. Verifica se o PDD é real e seguro. Confirma que a biomassa é sustentável.',
    'Resp: Auditor (VVB)',
  ),
  StepInfo(
    '4. Produção e Monitoramento',
    'Aplicação na lavoura. CRUCIAL: Guardar notas fiscais do biocarvão, fotos da aplicação e dados de GPS.',
    'Resp: Produtor',
  ),
  StepInfo(
    '5. Verificação Periódica',
    'O Auditor RETORNA (geralmente anual) para checar as provas do lote produzido. Sem essa nova visita, o crédito não é liberado.',
    'Resp: Auditor (VVB)',
  ),
  StepInfo(
    '6. Emissão',
    'Auditor envia laudo. Certificadora cria os créditos digitais, que são vendidos para empresas.',
    'Resp: Certificadora',
  ),
];

class StepList extends StatelessWidget {
  final Color textColor;
  final bool isDark;

  const StepList({super.key, required this.textColor, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary,
                    radius: 14,
                    child: Text("${index + 1}", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  if (!isLast)
                    Expanded(child: Container(width: 2, color: isDark ? Colors.grey[700] : Colors.grey.shade300, margin: const EdgeInsets.symmetric(vertical: 4))),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(step.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black87)),
                      const SizedBox(height: 4),
                      Text(step.desc, style: TextStyle(color: textColor, height: 1.3, fontSize: 13)),
                      const SizedBox(height: 6),
                      Text(
                        step.responsible,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? Colors.blue.shade200 : Colors.blue.shade800),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 5. LISTA DE CERTIFICAÇÕES
class CertificationData {
  final String name;
  final List<String> criticalRequirements;

  const CertificationData({required this.name, required this.criticalRequirements});
}

const List<CertificationData> certifications = [
  CertificationData(
    name: 'Puro.earth (Puro Standard)',
    criticalRequirements: [
      'Análise de Laboratório: Carbono fixo, H/C ratio e densidade.',
      'Segurança: Teste de ecotoxicidade no solo obrigatório.',
      'Auditoria: Exige visita presencial inicial.',
    ],
  ),
  CertificationData(
    name: 'Verra (VM0044)',
    criticalRequirements: [
      'Biomassa: Proibido biomassa dedicada (plantar só pra queimar).',
      'Metais Pesados: Limites rigorosos (cádmio, chumbo, etc).',
      'Aplicação: Monitorada via GPS para evitar sobreposição.',
    ],
  ),
];

class CertificationsList extends StatelessWidget {
  final Color cardColor;
  final Color textColor;
  final bool isDark;

  const CertificationsList({super.key, required this.cardColor, required this.textColor, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: certifications.map((cert) {
        return Card(
          elevation: 0,
          color: cardColor,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300)),
          child: ExpansionTile(
            collapsedIconColor: textColor,
            iconColor: AppColors.primary,
            shape: const Border(),
            leading: const Icon(Icons.verified, color: AppColors.primary),
            title: Text(cert.name, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Pontos de Atenção:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    ...cert.criticalRequirements.map((req) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.arrow_right, size: 16, color: textColor),
                          Expanded(child: Text(req, style: TextStyle(fontSize: 13, color: textColor))),
                        ],
                      ),
                    )),
                  ],
                ),
              )
            ],
          ),
        );
      }).toList(),
    );
  }
}

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
        Icon(icon, color: iconColor, size: 28),
        const SizedBox(width: 10),
        Expanded(child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor))),
      ],
    );
  }
}