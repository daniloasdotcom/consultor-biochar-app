import 'package:flutter/material.dart';


class AppColors {
  static const primary = Color(0xFF2E7D32);
  static const primaryDark = Color(0xFF1B5E20);
  static const warning = Color(0xFFF57C00);
  static const water = Color(0xFF0288D1);
}

class BestPracticesScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const BestPracticesScreen({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    // Lógica de tema (Idêntica à sua tela anterior)
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final bgColor = isDark ? const Color(0xFF121212) : Colors.grey[50];
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white70 : Colors.black87;
    final titleColor = isDark ? Colors.white : AppColors.primaryDark;
    
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Boas Práticas de Uso"),
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
              "Maximize os resultados agronômicos e garanta a segurança na aplicação.",
              style: TextStyle(fontSize: 16, color: textColor),
            ),
            const SizedBox(height: 24),

            // --- SEÇÃO 1: O ERRO MAIS COMUM (Ativação) ---
            SectionHeader(
              title: "A Regra de Ouro",
              icon: Icons.star_outline, // Estrela para destacar importância
              textColor: titleColor,
              iconColor: Colors.amber,
            ),
            const SizedBox(height: 8),
            
            const SpongeEffectCard(), // Novo Widget Explicativo
            
            const SizedBox(height: 32),

            // --- SEÇÃO 2: TÉCNICAS DE MISTURA ---
            SectionHeader(
              title: "Como Preparar (Inoculação)",
              icon: Icons.science,
              textColor: titleColor,
              iconColor: AppColors.water,
            ),
            const SizedBox(height: 12),
            
            PreparationMethodsList(cardColor: cardColor, textColor: textColor, isDark: isDark),

            const SizedBox(height: 32),

            // --- SEÇÃO 3: SEGURANÇA E MANUSEIO ---
            SectionHeader(
              title: "Segurança e Saúde",
              icon: Icons.health_and_safety_outlined,
              textColor: titleColor,
              iconColor: AppColors.warning,
            ),
            const SizedBox(height: 8),
            SafetyCard(cardColor: cardColor, textColor: textColor, isDark: isDark),

            const SizedBox(height: 32),
            
             // --- SEÇÃO 4: APLICAÇÃO ---
            SectionHeader(
              title: "Aplicação no Campo",
              icon: Icons.agriculture_outlined,
              textColor: titleColor,
              iconColor: AppColors.primary,
            ),
            const SizedBox(height: 12),
            
            ApplicationTips(textColor: textColor, isDark: isDark),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// --- NOVOS WIDGETS ESPECÍFICOS PARA ESTA TELA ---

// 1. CARD "EFEITO ESPONJA" (Conceitual)
class SpongeEffectCard extends StatelessWidget {
  const SpongeEffectCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos um gradiente sutil para destacar essa informação crucial
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade900, Colors.blue.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.water_drop, color: Colors.white),
              SizedBox(width: 8),
              Text(
                "O 'Efeito Esponja'",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Solo de partículas mais grosseiras (com maior teor de areias) se beneficiam mais do biocarvão, pois ele aumenta a capacidade de retenção de água e nutrientes, funcionando como uma esponja no solo.",
            style: TextStyle(color: Colors.white, height: 1.4),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.greenAccent, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Ambos efeito, retenção de água e nutrientes, são aprimorados com o tamanho ideal de partículas do biocarvão e a funcionalização do biocarvão. Consulte um especialista para melhorar a escolha.",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
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

// 2. LISTA DE MÉTODOS DE PREPARO
class PreparationMethodsList extends StatelessWidget {
  final Color cardColor;
  final Color textColor;
  final bool isDark;

  const PreparationMethodsList({super.key, required this.cardColor, required this.textColor, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final methods = [
      {
        "title": "Co-Compostagem (O Melhor)",
        "desc": "Misture o biocarvão (10-20%) na pilha de compostagem desde o início. Ele acelera o processo, reduz o cheiro e sai carregado de vida.",
        "badge": "Recomendado"
      },
      {
        "title": "Mistura com Esterco/Cama",
        "desc": "Adicione na cama de frango ou curral. O carvão absorve a amônia (nitrogênio) que evaporaria, criando um adubo super potente.",
        "badge": "Eficiente"
      },
      {
        "title": "Sopa de Nutrientes",
        "desc": "Mergulhe o biocarvão em biofertilizante líquido ou chá de composto por 24h a 48h antes da aplicação.",
        "badge": "Rápido"
      },
    ];

    return Column(
      children: methods.map((method) {
        return Card(
          color: cardColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
          ),
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      method['title']!,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black87),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        method['badge']!,
                        style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  method['desc']!,
                  style: TextStyle(fontSize: 13, color: textColor, height: 1.3),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// 3. CARD DE SEGURANÇA (Visual de Alerta)
class SafetyCard extends StatelessWidget {
  final Color cardColor;
  final Color textColor;
  final bool isDark;

  const SafetyCard({super.key, required this.cardColor, required this.textColor, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: AppColors.warning, width: 4)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSafetyItem(Icons.masks, "Cuidado com o Pó (Poeira Fina)", "O pó preto pode irritar os pulmões. Use máscara PFF2 ao manusear carvão seco.", textColor),
          const Divider(height: 24),
          _buildSafetyItem(Icons.water_damage_outlined, "Umedeça Antes", "Para transportar ou aplicar, mantenha o biocarvão com 20-30% de umidade para evitar nuvens de pó e risco de ignição.", textColor),
        ],
      ),
    );
  }

  Widget _buildSafetyItem(IconData icon, String title, String desc, Color textColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.warning, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
              const SizedBox(height: 4),
              Text(desc, style: TextStyle(fontSize: 13, color: textColor)),
            ],
          ),
        )
      ],
    );
  }
}

// 4. DICAS RÁPIDAS DE APLICAÇÃO
class ApplicationTips extends StatelessWidget {
  final Color textColor;
  final bool isDark;

  const ApplicationTips({super.key, required this.textColor, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTip(Icons.layers, "Incorporação Profunda", "Não deixe na superfície (chuva arrasta e o vento leva). Incorpore nos primeiros 10-20cm do solo.", isDark, textColor),
        _buildTip(Icons.grass, "Plantio Direto", "Aplique no sulco de plantio (na linha), misturado com o adubo, para economizar material e focar na raiz.", isDark, textColor),
        _buildTip(Icons.timelapse, "Frequência", "Biocarvão fica no solo por séculos. É uma aplicação única ou acumulativa (ex: aplicar todo ano um pouco).", isDark, textColor),
      ],
    );
  }

  Widget _buildTip(IconData icon, String title, String desc, bool isDark, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black87)),
                Text(desc, style: TextStyle(fontSize: 13, color: textColor)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// Reutilização simples do Header para o código compilar se copiado sozinho
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