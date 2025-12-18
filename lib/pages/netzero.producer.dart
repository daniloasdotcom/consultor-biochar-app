import 'package:flutter/material.dart';

class NetZeroProducerRelationScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const NetZeroProducerRelationScreen({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.grey[100];
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white70 : Colors.black87;
    final titleColor = isDark ? Colors.white : AppColors.primaryDark;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Produtor & NetZero'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
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
            _IntroCard(cardColor, textColor),
            const SizedBox(height: 24),

            SectionHeader(
              title: 'Modelo Operacional Atual',
              icon: Icons.factory_outlined,
              textColor: titleColor,
              iconColor: Colors.blueGrey,
            ),
            const SizedBox(height: 12),
            _ModelCard(cardColor, textColor, isDark),

            const SizedBox(height: 32),
            SectionHeader(
              title: 'Onde está o valor do Carbono?',
              icon: Icons.monetization_on_outlined,
              textColor: titleColor,
              iconColor: Colors.green,
            ),
            const SizedBox(height: 12),
            _CarbonValueCard(cardColor, textColor, isDark),

            const SizedBox(height: 32),
            SectionHeader(
              title: 'Pontos Técnicos Incontestáveis',
              icon: Icons.science_outlined,
              textColor: titleColor,
              iconColor: Colors.deepPurple,
            ),
            const SizedBox(height: 12),
            _TechnicalFacts(cardColor, textColor, isDark),

            const SizedBox(height: 32),
            SectionHeader(
              title: 'Modelo Alternativo Justo',
              icon: Icons.balance_outlined,
              textColor: titleColor,
              iconColor: Colors.amber,
            ),
            const SizedBox(height: 12),
            _FairModelCard(cardColor, textColor, isDark),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class AppColors {
  static const primary = Color(0xFF2E7D32);
  static const primaryDark = Color(0xFF1B5E20);
}

class _IntroCard extends StatelessWidget {
  final Color cardColor;
  final Color textColor;

  const _IntroCard(this.cardColor, this.textColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Biochar, Crédito de Carbono e o Produtor Rural',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 8),
          Text(
            'Esta análise resume os fluxos técnicos e econômicos do modelo praticado por grandes plantas de biochar certificadas (ex.: NetZero) e o papel real do produtor rural.',
            style: TextStyle(color: textColor, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _ModelCard extends StatelessWidget {
  final Color cardColor;
  final Color textColor;
  final bool isDark;

  const _ModelCard(this.cardColor, this.textColor, this.isDark);

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      cardColor: cardColor,
      borderColor: Colors.blueGrey,
      children: const [
        'Produtor entrega biomassa gratuitamente',
        'Produtor paga o frete',
        'Empresa realiza pirólise',
        'Produtor recompra o biochar (~R\$ 2,00/kg)',
        'Empresa retém 100% dos créditos de carbono',
      ],
      textColor: textColor,
    );
  }
}

class _CarbonValueCard extends StatelessWidget {
  final Color cardColor;
  final Color textColor;
  final bool isDark;

  const _CarbonValueCard(this.cardColor, this.textColor, this.isDark);

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      cardColor: cardColor,
      borderColor: Colors.green,
      children: const [
        'Créditos são gerados uma única vez por lote',
        'Somente após aplicação do biochar no solo',
        'Valor do crédito: US\$ 150–300 / tCO₂',
        'Produtor não participa da receita do carbono',
      ],
      textColor: textColor,
    );
  }
}

class _TechnicalFacts extends StatelessWidget {
  final Color cardColor;
  final Color textColor;
  final bool isDark;

  const _TechnicalFacts(this.cardColor, this.textColor, this.isDark);

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      cardColor: cardColor,
      borderColor: Colors.deepPurple,
      children: const [
        'Puro.Earth apenas certifica e registra',
        'Não existe dupla certificação do mesmo carbono',
        'Créditos são auditados por VVB independentes',
        'Estoque de carbono no solo não gera crédito recorrente',
      ],
      textColor: textColor,
    );
  }
}

class _FairModelCard extends StatelessWidget {
  final Color cardColor;
  final Color textColor;
  final bool isDark;

  const _FairModelCard(this.cardColor, this.textColor, this.isDark);

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      cardColor: cardColor,
      borderColor: Colors.amber,
      children: const [
        'Pagamento pela biomassa',
        'Biochar devolvido gratuitamente ou subsidiado',
        'Divisão de créditos de carbono (5–20%)',
        'Frete compartilhado',
        'Transparência total de créditos gerados',
      ],
      textColor: textColor,
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Color cardColor;
  final Color borderColor;
  final List<String> children;
  final Color textColor;

  const _InfoCard({
    required this.cardColor,
    required this.borderColor,
    required this.children,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children
            .map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle_outline, size: 18, color: borderColor),
                      const SizedBox(width: 8),
                      Expanded(child: Text(e, style: TextStyle(color: textColor, height: 1.3))),
                    ],
                  ),
                ))
            .toList(),
      ),
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
