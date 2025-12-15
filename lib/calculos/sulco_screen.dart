import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SulcoScreen extends StatefulWidget {
  const SulcoScreen({super.key});

  @override
  State<SulcoScreen> createState() => _SulcoScreenState();
}

class _SulcoScreenState extends State<SulcoScreen> {
  // --- Estados de Entrada ---
  String _inputUnit = 'g/m linear';
  double _inputValue = 300.0;

  // Geometria do Sulco
  double _sulcoWidthCm = 40.0;
  double _sulcoDepthCm = 40.0;
  
  // Espaçamento
  double _rowSpacingM = 0.8;

  // Parâmetros Biochar & Seleção
  int _selectedBiocharIndex = 0; // Índice do biochar selecionado
  double _bioDensity = 0.5;
  double _bioPrice = 0.40; 
  double _carbonPercent = 75.0;
  double _stabilityPercent = 80.0; 

  // Parâmetros Umidade e Pagamento
  String _paymentType = 'Seca'; 
  double _moisturePercent = 0.0; 

  // Parâmetros Mercado C e Câmbio
  double _priceMin = 100.0; 
  double _priceMax = 250.0; 
  double _exchangeRate = 5.20; 

  // Controllers
  late TextEditingController _valCtrl;
  late TextEditingController _widCtrl;
  late TextEditingController _depthCtrl;
  late TextEditingController _rowSpCtrl;
  late TextEditingController _bioDensCtrl;
  late TextEditingController _bioPriceCtrl;
  late TextEditingController _moistureCtrl;

  // Controllers Financeiros
  late TextEditingController _priceMinCtrl;
  late TextEditingController _priceMaxCtrl;
  late TextEditingController _exchangeCtrl; 

  // --- DADOS DOS BIOCARVÕES ---
  // type: 0 = g/kg (Macro), 1 = mg/kg (Micro)
  final List<Map<String, dynamic>> _biocharProfiles = [
    {
      'name': 'Biochar Padrão (Ref. A)',
      'nutrients': [
        {'name': 'Fósforo (P)',  'type': 0, 'total': 4.23, 'avail': 0.69},
        {'name': 'Potássio (K)', 'type': 0, 'total': 40.9, 'avail': 40.4},
        {'name': 'Cálcio (Ca)',  'type': 0, 'total': 12.3, 'avail': 8.65},
        {'name': 'Magnésio (Mg)','type': 0, 'total': 3.40, 'avail': 0.88},
        {'name': 'Enxofre (S)',  'type': 0, 'total': 1.57, 'avail': 0.23},
        // Micros em mg/kg
        {'name': 'Ferro (Fe)',   'type': 1, 'total': 2820.0, 'avail': 1754.0},
        {'name': 'Cobre (Cu)',   'type': 1, 'total': 35.4, 'avail': 5.26},
        {'name': 'Manganês (Mn)','type': 1, 'total': 198.0, 'avail': 77.0},
        {'name': 'Zinco (Zn)',   'type': 1, 'total': 25.7, 'avail': 11.0},
      ]
    },
    {
      'name': 'Biochar Alternativo (Ref. B)',
      'nutrients': [
        // Dados da imagem nova (Macros g/kg)
        {'name': 'Fósforo (P)',  'type': 0, 'total': 4.85, 'avail': 2.50},
        {'name': 'Potássio (K)', 'type': 0, 'total': 80.60, 'avail': 74.36},
        {'name': 'Cálcio (Ca)',  'type': 0, 'total': 9.37, 'avail': 5.26},
        {'name': 'Magnésio (Mg)','type': 0, 'total': 3.01, 'avail': 1.61},
        {'name': 'Enxofre (S)',  'type': 0, 'total': 2.31, 'avail': 1.00},
        // Micros convertidos de g/kg (imagem) para mg/kg (sistema) -> x1000
        {'name': 'Ferro (Fe)',   'type': 1, 'total': 1610.0, 'avail': 460.0}, 
        {'name': 'Cobre (Cu)',   'type': 1, 'total': 30.0, 'avail': 10.0},    
        {'name': 'Manganês (Mn)','type': 1, 'total': 1860.0, 'avail': 150.0}, 
        {'name': 'Zinco (Zn)',   'type': 1, 'total': 30.0, 'avail': 10.0},    
      ]
    },
  ];
  
  @override
  void initState() {
    super.initState();
    _valCtrl = TextEditingController(text: '300');
    _widCtrl = TextEditingController(text: '40');
    _depthCtrl = TextEditingController(text: '40');
    _rowSpCtrl = TextEditingController(text: '0.8'); 
    _bioDensCtrl = TextEditingController(text: '0.5');
    _bioPriceCtrl = TextEditingController(text: '0.40');
    _moistureCtrl = TextEditingController(text: '0');
    
    _priceMinCtrl = TextEditingController(text: '100.0');
    _priceMaxCtrl = TextEditingController(text: '250.0');
    _exchangeCtrl = TextEditingController(text: '5.20');
  }

  // --- LÓGICA MATEMÁTICA ---
  Map<String, double> _calculate() {
    // 1. Geometria
    double widthDm = _sulcoWidthCm / 10.0;
    double depthDm = _sulcoDepthCm / 10.0;
    double volPerMeterLiters = widthDm * depthDm * 10.0; 

    // 2. Metros Lineares/ha
    double linearMetersHa = (_rowSpacingM > 0) ? 10000 / _rowSpacingM : 0;

    // 3. Normalizar dose técnica (BASE SECA)
    double massKgPerMeter = 0;
    double volLPerMeter = 0;

    if (_inputUnit == 'g/m linear') {
      massKgPerMeter = _inputValue / 1000;
      volLPerMeter = (_bioDensity > 0) ? massKgPerMeter / _bioDensity : 0;
    } else if (_inputUnit == 't/ha') {
      double totalKgHa = _inputValue * 1000;
      massKgPerMeter = (linearMetersHa > 0) ? totalKgHa / linearMetersHa : 0;
      volLPerMeter = (_bioDensity > 0) ? massKgPerMeter / _bioDensity : 0;
    } else if (_inputUnit == '% v/v') {
      volLPerMeter = volPerMeterLiters * (_inputValue / 100);
      massKgPerMeter = volLPerMeter * _bioDensity;
    } else if (_inputUnit == 'g/dm³') {
      double concKgL = _inputValue / 1000;
      massKgPerMeter = concKgL * volPerMeterLiters;
      volLPerMeter = (_bioDensity > 0) ? massKgPerMeter / _bioDensity : 0;
    }

    // 4. Consolidação
    double concVV = (volPerMeterLiters > 0) ? (volLPerMeter / volPerMeterLiters) * 100 : 0;
    double totalBiocharDryTonHa = (massKgPerMeter * linearMetersHa) / 1000;
    
    // Correção por Umidade (Compra)
    double purchaseTonHa = totalBiocharDryTonHa; 
    if (_paymentType == 'Úmida') {
       double dryFactor = (100 - _moisturePercent) / 100;
       if (dryFactor > 0.01) { 
         purchaseTonHa = totalBiocharDryTonHa / dryFactor;
       }
    }

    // 5. Equivalência
    double concKgL = (volPerMeterLiters > 0) ? massKgPerMeter / volPerMeterLiters : 0;
    double equivKgHa = concKgL * 2000000; // 2 milhoes de L de solo
    double equivTHa = equivKgHa / 1000;
    double equivGDm3 = concKgL * 1000;

    // 6. Financeiro e Carbono
    double materialCostHaUSD = purchaseTonHa * 1000 * _bioPrice;
    
    // Carbono (Base Seca)
    double cTotalTon = totalBiocharDryTonHa * (_carbonPercent / 100);
    double cStableTon = cTotalTon * (_stabilityPercent / 100); 
    double co2EqTon = cStableTon * (44 / 12); 

    return {
      'volMeterL': volPerMeterLiters,
      'linearMetersHa': linearMetersHa,
      'kg/m': massKgPerMeter,
      'L/m': volLPerMeter,
      'v/v %': concVV,
      't/ha': purchaseTonHa,
      'dry_t/ha': totalBiocharDryTonHa,
      'costHaUSD': materialCostHaUSD,
      'co2EqTon': co2EqTon,
      'equivTHa': equivTHa,
      'equivGDm3': equivGDm3,
    };
  }

  // Helpers
  double _parse(String v) => double.tryParse(v.replaceAll(',', '.')) ?? 0.0;
  
  String _fmt(double v, [int d = 2]) {
     final f = NumberFormat.decimalPattern('pt_BR');
     f.minimumFractionDigits = d;
     f.maximumFractionDigits = d;
     return f.format(v);
  }
  
  String _moneyUSD(double v) => NumberFormat.currency(locale: 'en_US', symbol: '\$').format(v);
  String _moneyBRL(double v) => NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(v);

  @override
  Widget build(BuildContext context) {
    final res = _calculate();

    return Scaffold(
      appBar: AppBar(title: const Text("Cálculo em Sulco")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             _section("1. Configuração do Sulco"),
             _card(child: _buildGeometryCard(res)),

             const SizedBox(height: 16),
             _section("2. Dose e Material"),
             _card(child: Column(
               children: [
                 // REMOVIDO DAQUI: _buildBiocharSelector(), 
                 _buildDoseInput(),
                 const SizedBox(height: 12),
                 const Divider(),
                 const SizedBox(height: 12),
                 _buildBioParams(),
                 const SizedBox(height: 12),
                 const Divider(),
                 const SizedBox(height: 8),
                 _buildMoistureSection(),
               ],
             )),

             const SizedBox(height: 24),
             _section("RESULTADOS POR METRO"),
             _buildMeterResults(res),
             
             const SizedBox(height: 16),
             _buildEquivalenceCard(res),

             const SizedBox(height: 24),
             _section("PROJEÇÃO REAL POR HECTARE"),
             _buildHaResults(res),
             
             const SizedBox(height: 24),
             _card(child: _buildEconomics(res)),

             const SizedBox(height: 24),
             // Seção de Nutrientes (O seletor estará aqui dentro)
             _card(child: _buildNutrientsTable(res)), 

             const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS ---

  // Widget de Seleção
  Widget _buildBiocharSelector() {
    return DropdownButtonFormField<int>(
      value: _selectedBiocharIndex,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Tipo de Biocarvão',
        isDense: true,
        prefixIcon: Icon(Icons.eco, color: Colors.green),
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      ),
      items: List.generate(_biocharProfiles.length, (index) {
        return DropdownMenuItem(
          value: index,
          child: Text(_biocharProfiles[index]['name']),
        );
      }),
      onChanged: (v) {
        setState(() {
          _selectedBiocharIndex = v!;
        });
      },
    );
  }

  Widget _buildGeometryCard(Map<String, double> res) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _input("Largura (cm)", _widCtrl, (v) => _sulcoWidthCm = v)),
            const SizedBox(width: 12),
            Expanded(child: _input("Profund. (cm)", _depthCtrl, (v) => _sulcoDepthCm = v)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: _input("Entre Linhas (m)", _rowSpCtrl, (v) => _rowSpacingM = v)),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50, 
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade100)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Volume (1m):", style: TextStyle(color: Colors.blue.shade800, fontSize: 10)),
                    Text("${_fmt(res['volMeterL']!)} L", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade900, fontSize: 16)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDoseInput() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: TextField(
            controller: _valCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (v) => setState(() => _inputValue = _parse(v)),
            decoration: const InputDecoration(labelText: 'Dose Alvo', isDense: true),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 3,
          child: DropdownButtonFormField<String>(
            value: _inputUnit,
            isExpanded: true,
            isDense: true,
            decoration: const InputDecoration(labelText: 'Unidade', isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 10)),
            items: ['g/m linear', 't/ha', '% v/v', 'g/dm³']
                .map((u) => DropdownMenuItem(value: u, child: Text(u, style: const TextStyle(fontSize: 13))))
                .toList(),
            onChanged: (v) => setState(() => _inputUnit = v!),
          ),
        ),
      ],
    );
  }

  Widget _buildBioParams() {
    return Row(
      children: [
        Expanded(child: _input("Dens. (kg/L)", _bioDensCtrl, (v) => _bioDensity = v)),
        const SizedBox(width: 12),
        Expanded(child: _input("Preço (\$/kg)", _bioPriceCtrl, (v) => _bioPrice = v)),
      ],
    );
  }

  Widget _buildMoistureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Condição de Pagamento e Umidade:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: DropdownButtonFormField<String>(
                value: _paymentType,
                isDense: true,
                decoration: const InputDecoration(labelText: 'Base Pagamento', isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10)),
                items: ['Seca', 'Úmida']
                    .map((u) => DropdownMenuItem(value: u, child: Text("Ton. $u", style: const TextStyle(fontSize: 13))))
                    .toList(),
                onChanged: (v) => setState(() {
                  _paymentType = v!;
                  if(v == 'Seca') {
                    _moisturePercent = 0.0;
                    _moistureCtrl.text = "0";
                  }
                }),
              ),
            ),
            const SizedBox(width: 12),
            if (_paymentType == 'Úmida')
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _moistureCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (v) => setState(() => _moisturePercent = _parse(v)),
                  decoration: const InputDecoration(
                    labelText: 'Umidade (%)', 
                    isDense: true, 
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    suffixText: '%'
                  ),
                ),
              )
            else 
              const Spacer(flex: 2),
          ],
        ),
      ],
    );
  }

  Widget _buildMeterResults(Map<String, double> res) {
    final items = [
      {'l': 'Massa/m linear', 'v': "${_fmt(res['kg/m']! * 1000, 0)} g"},
      {'l': 'Volume/m linear', 'v': "${_fmt(res['L/m']!, 2)} L"},
      {'l': 'Conc. v/v (Sulco)', 'v': "${_fmt(res['v/v %']!, 1)} %", 'h': true},
      {'l': 'Custo/m linear', 'v': _moneyUSD(res['kg/m']! * _bioPrice)}, 
    ];

    return GridView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: 110,
      ),
      itemBuilder: (ctx, i) {
        final item = items[i];
        final bool highlight = item['h'] == true;
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: highlight ? Colors.green.shade50 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: highlight ? Colors.green.shade200 : Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(item['l'] as String, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(item['v'] as String, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: highlight ? Colors.green.shade800 : Colors.black87)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEquivalenceCard(Map<String, double> res) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.compare_arrows, size: 18, color: Colors.orange.shade900),
              const SizedBox(width: 8),
              Flexible( 
                child: Text(
                  "EQUIVALÊNCIA EM ÁREA TOTAL (0-20 cm)", 
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.orange.shade900)
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Equiv. t/ha", style: TextStyle(fontSize: 11, color: Colors.orange.shade800)),
                    Text("${_fmt(res['equivTHa']!)} t/ha", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange.shade900)),
                  ],
                ),
              ),
              Container(width: 1, height: 40, color: Colors.orange.shade200),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Equiv. g/dm³", style: TextStyle(fontSize: 11, color: Colors.orange.shade800)),
                    Text("${_fmt(res['equivGDm3']!)} g/dm³", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange.shade900)),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildHaResults(Map<String, double> res) {
    bool isWet = _paymentType == 'Úmida' && _moisturePercent > 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("CONSUMO REAL", style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold)),
                    if(isWet)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.blue.shade800, borderRadius: BorderRadius.circular(4)),
                        child: Text("ÚMIDO (${_fmt(_moisturePercent, 0)}%)", style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold)),
                      )
                  ],
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text("${_fmt(res['t/ha']!)} t/ha", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryContainer)),
                ),
                if(isWet)
                   Text("(Base Seca: ${_fmt(res['dry_t/ha']!)} t/ha)", style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7))),
              ],
            ),
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(Icons.linear_scale, color: Colors.black26),
                Text("${_fmt(res['linearMetersHa']!, 0)} m/ha", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
          )
        ],
      ),
    );
  }

  Widget _buildEconomics(Map<String, double> res) {
    double co2Ton = res['co2EqTon']!;
    
    // Receitas em USD
    double minRevUSD = co2Ton * _priceMin;
    double maxRevUSD = co2Ton * _priceMax;
    double costUSD = res['costHaUSD']!;

    // Conversão para BRL
    double minRevBRL = minRevUSD * _exchangeRate;
    double maxRevBRL = maxRevUSD * _exchangeRate;
    double costBRL = costUSD * _exchangeRate;

    double balanceMinBRL = minRevBRL - costBRL;
    double balanceMaxBRL = maxRevBRL - costBRL;
    
    return ExpansionTile(
      title: const Row(
        children: [
           Icon(Icons.monetization_on_outlined, color: Colors.green),
           SizedBox(width: 8),
           Expanded(child: Text("Financeiro & Carbono", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green), overflow: TextOverflow.ellipsis)),
        ],
      ),
      initiallyExpanded: false,
      shape: const Border(),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
               // Campo de Câmbio
              Row(
                children: [
                  Expanded(
                    child: _input("Câmbio (R\$/USD)", _exchangeCtrl, (v) => _exchangeRate = v),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Potencial Sequestro:", style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                        Text("${_fmt(co2Ton, 2)} tCO2e", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
                        Text("(${_fmt(_stabilityPercent, 0)}% estabilidade)", style: const TextStyle(fontSize: 9, color: Colors.grey)),
                      ],
                    ),
                  )
                ],
              ),
              const Divider(),

              // Inputs de Preço de Carbono
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: _input("Preço Mín C. (USD)", _priceMinCtrl, (v) => _priceMin = v),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _input("Preço Máx C. (USD)", _priceMaxCtrl, (v) => _priceMax = v),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              
              // Custo do Material (Convertido)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Custo Material / ha:"),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(_moneyBRL(costBRL), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                      Text("(${_moneyUSD(costUSD)})", style: const TextStyle(fontSize: 9, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    Text("Receita Carbono Estimada (R\$)", style: TextStyle(fontSize: 11, color: Colors.green.shade900)),
                    const SizedBox(height: 6),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text("${_moneyBRL(minRevBRL)} - ${_moneyBRL(maxRevBRL)}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green.shade800)),
                    ),
                    
                    const Divider(color: Colors.green),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Balanço Final (R\$):", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
                        const SizedBox(width: 8),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "${_moneyBRL(balanceMinBRL)} a ${_moneyBRL(balanceMaxBRL)}", 
                              style: TextStyle(
                                fontWeight: FontWeight.bold, 
                                color: balanceMaxBRL < 0 ? Colors.red : Colors.black87
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text("Valores convertidos pelo câmbio informado.", style: TextStyle(fontSize: 10, color: Colors.green.shade900), overflow: TextOverflow.clip),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  // --- TABELA DINÂMICA DE NUTRIENTES ---
  Widget _buildNutrientsTable(Map<String, double> res) {
    double dryTonHa = res['dry_t/ha'] ?? 0.0;
    
    // Pega os nutrientes do perfil selecionado
    final List<dynamic> nutrients = _biocharProfiles[_selectedBiocharIndex]['nutrients'];

    // Encontra P e K no perfil atual para calcular os óxidos
    var pData = nutrients.firstWhere((n) => n['name'].contains('Fósforo'), orElse: () => {'total': 0.0, 'avail': 0.0});
    var kData = nutrients.firstWhere((n) => n['name'].contains('Potássio'), orElse: () => {'total': 0.0, 'avail': 0.0});
    
    final oxides = [
      {
        'name': 'Fósforo (P₂O₅)', 
        'factor': 2.29, 
        'baseTotal': (pData['total'] as double), 
        'baseAvail': (pData['avail'] as double)
      },
      {
        'name': 'Potássio (K₂O)', 
        'factor': 1.20, 
        'baseTotal': (kData['total'] as double), 
        'baseAvail': (kData['avail'] as double)
      },
    ];

    return ExpansionTile(
      title: const Row(
        children: [
          Icon(Icons.science, color: Colors.purple),
          SizedBox(width: 8),
          Expanded(child: Text("Aporte de Nutrientes (Estimado)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple))),
        ],
      ),
      initiallyExpanded: false,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- SELETOR ADICIONADO AQUI ---
              _buildBiocharSelector(),
              const SizedBox(height: 12),

              Text(
                "Baseado na dose seca de ${_fmt(dryTonHa)} t/ha",
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontStyle: FontStyle.italic),
              ),
              
              const SizedBox(height: 12),
              const Text("1. Elementares", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.purple)),
              const SizedBox(height: 4),
              
              Table(
                border: TableBorder(
                  horizontalInside: BorderSide(color: Colors.grey.shade200, width: 1),
                  bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                columnWidths: const {
                  0: FlexColumnWidth(3), // Nutriente
                  1: FlexColumnWidth(2), // Unidade
                  2: FlexColumnWidth(2.5), // Total
                  3: FlexColumnWidth(2.5), // Disp
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: Colors.purple.shade50),
                    children: const [
                      Padding(padding: EdgeInsets.all(8), child: Text("Nutriente", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.black87))),
                      Padding(padding: EdgeInsets.all(8), child: Text("Unid.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.black87))),
                      Padding(padding: EdgeInsets.all(8), child: Text("Total/ha", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.black87), textAlign: TextAlign.right)),
                      Padding(padding: EdgeInsets.all(8), child: Text("Disp./ha", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.black87), textAlign: TextAlign.right)),
                    ],
                  ),
                  ...nutrients.map((n) {
                    bool isMacro = n['type'] == 0;
                    double totalVal = (n['total'] as double) * dryTonHa;
                    double availVal = (n['avail'] as double) * dryTonHa;
                    String unit = isMacro ? 'kg/ha' : 'g/ha';

                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          child: Text(n['name'] as String, style: const TextStyle(fontSize: 12)),
                        ),
                        Text(unit, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        Text(_fmt(totalVal, isMacro ? 2 : 1), textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        Text(_fmt(availVal, isMacro ? 2 : 1), textAlign: TextAlign.right, style: TextStyle(fontSize: 12, color: Colors.green.shade700)),
                      ],
                    );
                  }).toList(),
                ],
              ),

              const SizedBox(height: 24),
              const Text("2. Equivalência em Óxidos", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.purple)),
              const SizedBox(height: 4),

              Table(
                border: TableBorder(
                  horizontalInside: BorderSide(color: Colors.grey.shade200, width: 1),
                  bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                columnWidths: const {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(2), 
                  2: FlexColumnWidth(2.5), 
                  3: FlexColumnWidth(2.5),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                   TableRow(
                    decoration: BoxDecoration(color: Colors.orange.shade50),
                    children: const [
                      Padding(padding: EdgeInsets.all(8), child: Text("Óxido", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.black87))),
                      Padding(padding: EdgeInsets.all(8), child: Text("Unid.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.black87))),
                      Padding(padding: EdgeInsets.all(8), child: Text("Total/ha", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.black87), textAlign: TextAlign.right)),
                      Padding(padding: EdgeInsets.all(8), child: Text("Disp./ha", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.black87), textAlign: TextAlign.right)),
                    ],
                  ),
                  ...oxides.map((o) {
                    double factor = o['factor'] as double;
                    double totalVal = (o['baseTotal'] as double) * factor * dryTonHa;
                    double availVal = (o['baseAvail'] as double) * factor * dryTonHa;

                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          child: Text(o['name'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
                        ),
                        const Text("kg/ha", style: TextStyle(fontSize: 11, color: Colors.grey)),
                        Text(_fmt(totalVal, 2), textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        Text(_fmt(availVal, 2), textAlign: TextAlign.right, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green.shade800)),
                      ],
                    );
                  }).toList(),
                ],
              ),
              
              const SizedBox(height: 8),
              const Text(
                "*Conversão: P x 2.29 = P₂O₅ e K x 1.20 = K₂O",
                style: TextStyle(fontSize: 10, color: Colors.grey),
              )
            ],
          ),
        ),
      ],
    );
  }

  // UI Helpers
  Widget _section(String title) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 8),
    child: Text(title.toUpperCase(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary, letterSpacing: 0.5)),
  );
  
  Widget _card({required Widget child}) => Card(elevation: 0, color: Theme.of(context).colorScheme.surfaceContainerLow, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), child: Padding(padding: const EdgeInsets.all(16), child: child));

  Widget _input(String label, TextEditingController ctrl, Function(double) onChanged) {
    return TextField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (v) => setState(() => onChanged(_parse(v))),
      decoration: InputDecoration(labelText: label, isDense: true, contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14)),
    );
  }
}