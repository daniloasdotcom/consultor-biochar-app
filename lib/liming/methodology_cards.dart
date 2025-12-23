import 'package:flutter/material.dart';

// ============================================================================
// CARD 1: METODOLOGIA FIDEL ET AL. 2017 (ALCALINIDADE TOTAL)
// ============================================================================
class MethodologyCard extends StatelessWidget {
  const MethodologyCard({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Lógica de Tema
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final primaryColor = Colors.teal[700]!; // Teal para consistência científica

    // 2. Container Estilizado
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
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          // Ícone e Título
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.science_outlined, color: primaryColor, size: 28),
          ),
          title: Text(
            "Método de Alcalinidade Total",
            style: TextStyle(
              fontFamily: 'Merriweather',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          subtitle: Text(
            "Protocolo Fidel et al. (2017)",
            style: TextStyle(
              fontFamily: 'Merriweather',
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Procedimento Padronizado",
                    style: TextStyle(
                      fontFamily: 'Merriweather',
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildStep(
                    context,
                    1,
                    "Preparo",
                    "Moer o biochar para < 0.50 mm (minimiza efeito cinético).",
                  ),
                  _buildStep(
                    context,
                    2,
                    "Reação",
                    "Agitar 1 g de biochar com 50 mL de HCl 0.05 M por 72h.",
                  ),
                  _buildStep(
                    context,
                    3,
                    "Extração",
                    "Filtrar a suspensão (< 0.45 µm).",
                  ),
                  _buildStep(
                    context,
                    4,
                    "Titulação",
                    "Titular o extrato até pH 8.2 com NaOH 0.05 M.",
                  ),

                  const SizedBox(height: 20),

                  // --- JUSTIFICATIVAS ---
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.teal.withOpacity(0.1)
                          : Colors.teal.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? Colors.teal.withOpacity(0.3)
                            : Colors.teal.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lightbulb,
                              size: 18,
                              color: primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Justificativas (Fidel et al. 2017)",
                                style: TextStyle(
                                  fontFamily: 'Merriweather',
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildJustificationItem(
                          context,
                          "Por que HCl 0.05 M?",
                          "Concentrações maiores (ex: 1 M) dissolveram fases minerais não alcalinas em pH muito baixo (≤ 1), o que interferiu na titulação.",
                        ),
                        _buildJustificationItem(
                          context,
                          "Por que 72 horas?",
                          "Garante o equilíbrio químico completo. 72h é o padrão conservador para reações lentas de superfície.",
                        ),
                        _buildJustificationItem(
                          context,
                          "Por que < 0.50 mm?",
                          "Partículas menores garantem que a reação não seja limitada pela difusão física dentro dos poros.",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // --- FÓRMULA ---
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black26 : Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? Colors.grey[800]!
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "CÁLCULO DA ALCALINIDADE",
                          style: TextStyle(
                            fontSize: 11,
                            fontFamily: 'Merriweather',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: isDark
                                ? Colors.tealAccent[100]
                                : primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Alcalinidade\n(meq/g)",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Merriweather',
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "=",
                              style: TextStyle(
                                fontSize: 20,
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.black54,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              children: [
                                Text(
                                  "(Vb - Va) × M",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Merriweather',
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                                Container(
                                  height: 2,
                                  width: 110,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                                Text(
                                  "W",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Merriweather',
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Onde:\n"
                            "• Vb: Volume de NaOH gasto no branco (mL)\n"
                            "• Va: Volume de NaOH gasto na amostra (mL)\n"
                            "• M: Molaridade do NaOH (0.05 mol/L)\n"
                            "• W: Massa do biochar (g)",
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildStep(
    BuildContext context,
    int number,
    String title,
    String description,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$number.",
            style: TextStyle(
              fontFamily: 'Merriweather',
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.tealAccent[100] : Colors.teal[800],
              fontSize: 15,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: 'Merriweather',
                  fontSize: 14,
                  color: isDark ? Colors.grey[300] : Colors.grey[800],
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: "$title: ",
                    style: const TextStyle(
                      fontFamily: 'Merriweather',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJustificationItem(
    BuildContext context,
    String title,
    String text,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.grey[300] : Colors.black87,
            height: 1.4,
          ),
          children: [
            TextSpan(
              text: "• $title ",
              style: TextStyle(
                fontFamily: 'Merriweather',
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.teal[200] : Colors.teal[800],
              ),
            ),
            TextSpan(text: text),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// CARD 2: METODOLOGIA LIMING POTENTIAL (CaCO3 Eq)
// ============================================================================
class LimingMethodCard extends StatelessWidget {
  const LimingMethodCard({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Lógica de Tema
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final primaryColor = Colors.blueGrey[600]!; // BlueGrey para diferenciar

    // 2. Container Estilizado
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
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          // Ícone e Título
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.calculate_outlined,
              color: primaryColor,
              size: 28,
            ),
          ),
          title: Text(
            "Potencial de Calagem",
            style: TextStyle(
              fontFamily: 'Merriweather',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          subtitle: Text(
            "Equivalente CaCO₃ (Modif. Rayment)",
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Procedimento de Laboratório",
                    style: TextStyle(
                      fontFamily: 'Merriweather',
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildStep(
                    context,
                    1,
                    "Preparo",
                    "Pesar 0.5 g de biochar seco ao ar (moído < 2 mm).",
                  ),
                  _buildStep(
                    context,
                    2,
                    "Adição de Ácido",
                    "Adicionar 10.0 mL de solução padronizada de HCl 1 M.",
                  ),
                  _buildStep(
                    context,
                    3,
                    "Agitação",
                    "Agitar por 2 h a 25°C e deixar em repouso durante a noite (16 h).",
                  ),
                  _buildStep(
                    context,
                    4,
                    "Titulação",
                    "Titular a suspensão (sem filtrar) com NaOH 0.5 M padronizado até pH 7.0.",
                  ),
                  _buildStep(
                    context,
                    5,
                    "Branco",
                    "Realizar titulação em branco (sem biochar) com apenas 10.0 mL de HCl 1 M.",
                  ),
                  _buildStep(
                    context,
                    6,
                    "Validação",
                    "Incluir referência de CaCO₃ puro (seco a 105°C) para validar lote.",
                  ),
                  _buildStep(
                    context,
                    7,
                    "Cálculo",
                    "Usar a diferença de volume consumido para calcular o % de CaCO₃.",
                  ),

                  const SizedBox(height: 20),

                  // --- FÓRMULA ---
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black26 : Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? Colors.grey[800]!
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "FÓRMULA DO % CaCO₃",
                          style: TextStyle(
                            fontSize: 11,
                            fontFamily: 'Merriweather',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: isDark ? Colors.blueGrey[200] : primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "% CaCO₃\nEq",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Merriweather',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "=",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.black54,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                children: [
                                  Text(
                                    "M × (b - a) × 10⁻³ × 100.09 × 100",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Merriweather',
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                  Container(
                                    height: 2,
                                    width: 280,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                  Text(
                                    "2 × W",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Merriweather',
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Parâmetros:\n"
                            "• M: Molaridade NaOH (mol/L)\n"
                            "• b: Vol. NaOH branco (mL)\n"
                            "• a: Vol. NaOH amostra (mL)\n"
                            "• 100.09: Massa molar CaCO₃\n"
                            "• 2: Valência (2 mol H⁺ / 1 mol CaCO₃)\n"
                            "• W: Massa biochar (g)",
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildStep(
    BuildContext context,
    int number,
    String title,
    String description,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$number.",
            style: TextStyle(
              fontFamily: 'Merriweather',
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.blueGrey[200] : Colors.blueGrey[800],
              fontSize: 15,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey[300] : Colors.grey[800],
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: "$title: ",
                    style: const TextStyle(
                      fontFamily: 'Merriweather',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
