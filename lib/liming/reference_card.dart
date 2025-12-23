import 'package:flutter/material.dart';

class ReferenceExplanationCard extends StatelessWidget {
  const ReferenceExplanationCard({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Lógica de Tema
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final primaryColor = Colors.deepOrange; // Cor temática deste card

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
          // Ícone Leading
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.terrain, color: primaryColor, size: 28),
          ),
          // Título
          title: Text(
            "A Regra da Tonelada",
            style: TextStyle(
              fontFamily: 'Merriweather',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          // Subtítulo
          subtitle: RichText(
            text: TextSpan(
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
              children: const [
                TextSpan(text: "Por que 1 cmol"),
                TextSpan(text: "c", style: TextStyle(fontSize: 10)),
                TextSpan(text: "/dm³ ≈ 1 ton/ha?"),
              ],
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: isDark ? Colors.grey[800] : Colors.grey[200]),
                  const SizedBox(height: 10),

                  // --- SEÇÃO 1: FÍSICA ---
                  Text(
                    "1. O Raciocínio Físico (Volume e Massa)",
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      color: isDark ? Colors.orangeAccent : Colors.deepOrange,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildVisualStep(
                    context,
                    icon: Icons.layers,
                    title: "Volume de 1 Hectare (0-20 cm)",
                    content: "10.000 m² × 0,2 m = 2.000 m³",
                    subContent: "= 2.000.000 dm³ (litros de solo)",
                  ),
                  _buildVisualStep(
                    context,
                    icon: Icons.scale,
                    title: "Massa de Solo (Densidade 1.0)",
                    content: "2.000 m³ × 1 ton/m³ = 2.000 Toneladas",
                  ),

                  const SizedBox(height: 20),

                  // --- SEÇÃO 2: QUÍMICA ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.teal.withOpacity(0.1) : Colors.teal.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? Colors.teal.withOpacity(0.3) : Colors.teal.withOpacity(0.3)
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.science_outlined, size: 20, color: isDark ? Colors.tealAccent : Colors.teal),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "2. A Estequiometria (Cargas)", 
                                style: TextStyle(
                                  fontSize: 14, 
                                  fontWeight: FontWeight.bold, 
                                  color: isDark ? Colors.tealAccent : Colors.teal
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // A Equação Química
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey[800] : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1), 
                                  blurRadius: 4, 
                                  offset: const Offset(0,2)
                                )
                              ]
                            ),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 16, 
                                  color: isDark ? Colors.white : Colors.black87, 
                                  fontWeight: FontWeight.bold
                                ),
                                children: const [
                                  TextSpan(text: "CaCO"),
                                  TextSpan(text: "₃", style: TextStyle(fontSize: 12)), 
                                  TextSpan(text: " + 2H"),
                                  TextSpan(text: "⁺", style: TextStyle(fontSize: 12)), 
                                  TextSpan(text: " → Ca"),
                                  TextSpan(text: "²⁺", style: TextStyle(fontSize: 12)),
                                  TextSpan(text: " + H"),
                                  TextSpan(text: "₂", style: TextStyle(fontSize: 12)),
                                  TextSpan(text: "O + CO"),
                                  TextSpan(text: "₂", style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "O 'c' em cmolc significa CARGA. O Ca²⁺ vale por 2 cargas. Por isso dividimos a massa molar por 2.",
                          style: TextStyle(
                            fontSize: 12, 
                            fontStyle: FontStyle.italic, 
                            color: isDark ? Colors.teal[200] : Colors.teal[800]
                          ),
                        ),
                        Divider(color: isDark ? Colors.teal.withOpacity(0.3) : Colors.teal.withOpacity(0.3), height: 24),

                        _buildStoichiometryRow(context, "Massa Molar (CaCO₃)", "100 g/mol"),
                        const SizedBox(height: 8),
                        _buildStoichiometryRow(context, "Valência (Cargas)", "2 (Ca²⁺)"),
                        const SizedBox(height: 8),
                        
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.teal.withOpacity(0.2) : Colors.teal.withOpacity(0.1), 
                            borderRadius: BorderRadius.circular(6)
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Text(
                                  "Massa de 1 mol de carga (50%):", 
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, 
                                    fontSize: 12, 
                                    color: isDark ? Colors.teal[100] : Colors.teal[900]
                                  )
                                )
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "100g ÷ 2 = 50g", 
                                  textAlign: TextAlign.right, 
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, 
                                    fontSize: 13, 
                                    color: isDark ? Colors.tealAccent : Colors.teal[800]
                                  )
                                )
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // --- SEÇÃO 3: CÁLCULO FINAL ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.blue.withOpacity(0.1) : Colors.blue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? Colors.blue.withOpacity(0.3) : Colors.blue.withOpacity(0.3)
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "3. O Cálculo Final", 
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            color: isDark ? Colors.blueAccent : Colors.blue
                          )
                        ),
                        const SizedBox(height: 12),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: 12, color: isDark ? Colors.grey[300] : Colors.black87),
                            children: [
                              const TextSpan(text: "Se a análise mostra "),
                              TextSpan(text: "1 cmol", style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                              TextSpan(text: "c", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: isDark ? Colors.white : Colors.black)),
                              const TextSpan(text: "/dm³ de acidez:"),
                            ]
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        _buildMathRowSimple(context, "Volume total:", "2.000.000 dm³"),
                        _buildMathRowSimple(context, "Cargas totais (×1):", "2.000.000 cmolc"),
                        Divider(color: isDark ? Colors.blue.withOpacity(0.3) : Colors.blue.withOpacity(0.2)),
                        _buildMathRowSimple(context, "Massa necessária:", "2.000.000 × 0,5g*"),
                        
                        Padding(
                           padding: const EdgeInsets.only(top: 2, bottom: 8),
                           child: Text(
                             "* (0,5g é a massa de 1 centimol de carga de CaCO₃)", 
                             style: TextStyle(
                               fontSize: 10, 
                               color: isDark ? Colors.grey[400] : Colors.grey[600], 
                               fontStyle: FontStyle.italic
                             )
                           ),
                         ),
                          
                         Container(
                           width: double.infinity,
                           padding: const EdgeInsets.all(10),
                           decoration: BoxDecoration(
                             color: isDark ? Colors.blue[800] : Colors.blue, 
                             borderRadius: BorderRadius.circular(8)
                           ),
                           child: const Text(
                             "= 1.000.000 g = 1.000 kg (1 Ton)", 
                             textAlign: TextAlign.center,
                             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)
                            ),
                         ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Aviso Final
                  Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: isDark ? Colors.grey[400] : Colors.grey),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          "Considerando calcário PRNT 100%.", 
                          style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontSize: 12)
                        )
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- MÉTODOS AUXILIARES ---

  Widget _buildVisualStep(BuildContext context, {required IconData icon, required String title, required String content, String? subContent}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: isDark ? Colors.grey[400] : Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, 
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 13,
                    color: isDark ? Colors.grey[200] : Colors.black87
                  )
                ),
                Text(
                  content, 
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey[400] : Colors.black87
                  )
                ),
                if (subContent != null)
                   Text(
                     subContent, 
                     style: TextStyle(
                       fontSize: 12, 
                       color: isDark ? Colors.grey[500] : Colors.grey[600]
                     )
                   ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoichiometryRow(BuildContext context, String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label, 
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey[300] : Colors.black87
              )
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 6,
            child: Text(
              value, 
              textAlign: TextAlign.right, 
              style: TextStyle(
                fontSize: 12, 
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87
              )
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMathRowSimple(BuildContext context, String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4, 
            child: Text(
              label, 
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey[300] : Colors.black87
              )
            )
          ),
          Expanded(
            flex: 3, 
            child: Text(
              value, 
              textAlign: TextAlign.right, 
              style: TextStyle(
                fontSize: 12, 
                fontFamily: 'monospace', 
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87
              )
            )
          ),
        ],
      ),
    );
  }
}