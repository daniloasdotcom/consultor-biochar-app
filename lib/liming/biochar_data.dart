// lib/biochar_data.dart

// Lista unificada de dados de biochar.
// Fonte 1 (Fidel et al.): Dados originais em g/kg.
// Fonte 2 (Guia Analítico - Tabela 3.4): Dados originais em % convertidos para g/kg (x10).

const List<Map<String, String>> biocharData = [
  // --- DADOS ORIGINAIS (Fidel et al.) ---
  {'name': 'CSM300', 'source': 'Exp. Farelo de algodão', 'cce': '28.91'},
  {'name': 'CSM350', 'source': 'Exp. Farelo de algodão', 'cce': '37.18'},
  {'name': 'CSM400', 'source': 'Exp. Farelo de algodão', 'cce': '42.55'},
  {'name': 'CSM450', 'source': 'Exp. Farelo de algodão', 'cce': '48.19'},
  {'name': 'CSM500', 'source': 'Exp. Farelo de algodão', 'cce': '38.55'},
  {'name': 'CSM550', 'source': 'Exp. Farelo de algodão', 'cce': '29.60'},
  {'name': 'CSM600', 'source': 'Exp. Farelo de algodão', 'cce': '29.60'},
  {'name': 'PL300', 'source': 'Exp. Cama de frango', 'cce': '20.65'},
  {'name': 'PL350', 'source': 'Exp. Cama de frango', 'cce': '45.44'},
  {'name': 'PL400', 'source': 'Exp. Cama de frango', 'cce': '59.21'},
  {'name': 'PL450', 'source': 'Exp. Cama de frango', 'cce': '67.47'},
  {'name': 'PL500', 'source': 'Exp. Cama de frango', 'cce': '77.18'},
  {'name': 'PL550', 'source': 'Exp. Cama de frango', 'cce': '81.10'},
  {'name': 'PL600', 'source': 'Exp. Cama de frango', 'cce': '86.74'},
  {'name': 'OR', 'source': 'Comercial Madeira', 'cce': '31.67'},
  {'name': 'MOH', 'source': 'Comercial Madeira Lei', 'cce': '128.05'},
  {'name': 'MOS', 'source': 'Comercial Madeira Macia', 'cce': '5.51'},
  {'name': 'PA', 'source': 'Comercial Madeira', 'cce': '75.73'},
  {'name': 'Coco', 'source': 'Casca de coco', 'cce': '2.75'},

  // --- NOVOS DADOS (Tabela 3.4 - Guia Analítico) ---
  // Valores convertidos de % para g/kg (multiplicado por 10)
  {'name': 'Wheat Straw 550', 'source': 'Palha de Trigo', 'cce': '57.0'}, // 5.7%
  {'name': 'Wheat Straw 700', 'source': 'Palha de Trigo', 'cce': '65.0'}, // 6.5%
  {'name': 'Switchgrass 400', 'source': 'Switchgrass', 'cce': '19.0'},    // 1.9%
  {'name': 'Switchgrass 550', 'source': 'Switchgrass', 'cce': '30.0'},    // 3.0%
  {'name': 'Pine Chips 400', 'source': 'Cavacos de Pinho', 'cce': '39.0'}, // 3.9%
  {'name': 'Pine Chips 550', 'source': 'Cavacos de Pinho', 'cce': '50.0'}, // 5.0%
  {'name': 'Eucalyptus 450', 'source': 'Eucalipto', 'cce': '26.0'},       // 2.6%
  {'name': 'Eucalyptus 550', 'source': 'Eucalipto', 'cce': '63.0'},       // 6.3%
  {'name': 'Poultry Litter 550', 'source': 'Cama de Frango', 'cce': '118.0'}, // 11.8%
  {'name': 'Digestate 700', 'source': 'Digestato', 'cce': '108.0'},       // 10.8%
  {'name': 'Muni. Greenwaste', 'source': 'Resíduo Urbano', 'cce': '18.0'}, // 1.8%
  {'name': 'Rice Husk 550', 'source': 'Casca de Arroz', 'cce': '15.0'},   // 1.5%
  {'name': 'Rice Husk 700', 'source': 'Casca de Arroz', 'cce': '19.0'},   // 1.9%
  {'name': 'Miscanthus 550', 'source': 'Miscanthus', 'cce': '38.0'},      // 3.8%
  {'name': 'Miscanthus 700', 'source': 'Miscanthus', 'cce': '56.0'},      // 5.6%
  {'name': 'Mixed Softwood 550', 'source': 'Madeira Macia Mista', 'cce': '15.0'}, // 1.5%
  {'name': 'Mixed Softwood 700', 'source': 'Madeira Macia Mista', 'cce': '23.0'}, // 2.3%
  {'name': 'Tomato Waste 550', 'source': 'Resíduo de Tomate', 'cce': '205.0'}, // 20.5% (Alto!)
  {'name': 'Durian Shell 400', 'source': 'Casca de Durian', 'cce': '93.0'},   // 9.3%
];