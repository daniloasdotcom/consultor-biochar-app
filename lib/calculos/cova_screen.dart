import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CovaScreen extends StatefulWidget {
  const CovaScreen({super.key});

  @override
  State<CovaScreen> createState() => _CovaScreenState();
}

class _CovaScreenState extends State<CovaScreen> {
  // --- Estados de Entrada ---
  String _inputUnit = 'g/cova';
  double _inputValue = 500.0;

  // Geometria da Cova (Cúbica/Retangular)
  double _holeLengthCm = 40.0; // Comprimento
  double _holeWidthCm = 40.0;  // Largura
  double _holeDepthCm = 40.0;  // Profundidade
  
  // Espaçamento (Stand)
  double _spacingLineM = 3.0;
  double _spacingPlantM = 2.0;

  // Parâmetros Biochar
  double _bioDensity = 0.5; // kg/dm³
  double _bioPrice = 0.40; // $/kg
  double _carbonPercent = 75.0;
  double _stabilityPercent = 80.0;

  // Parâmetros Mercado C
  double _priceMin = 80.0;
  double _priceMax = 150.0;

  // Controllers
  late TextEditingController _valCtrl;
  
  // Controllers de Geometria
  late TextEditingController _lenCtrl;
  late TextEditingController _widCtrl;
  late TextEditingController _depthCtrl;
  
  late TextEditingController _spLineCtrl;
  late TextEditingController _spPlantCtrl;
  late TextEditingController _bioDensCtrl;
  late TextEditingController _bioPriceCtrl;
  
  @override
  void initState() {
    super.initState();
    _valCtrl = TextEditingController(text: '500');
    
    // Iniciais 40x40x40
    _lenCtrl = TextEditingController(text: '40');
    _widCtrl = TextEditingController(text: '40');
    _depthCtrl = TextEditingController(text: '40');

    _spLineCtrl = TextEditingController(text: '3.0');
    _spPlantCtrl = TextEditingController(text: '2.0');
    _bioDensCtrl = TextEditingController(text: '0.5');
    _bioPriceCtrl = TextEditingController(text: '0.40');
  }

  // --- LÓGICA MATEMÁTICA ---
  Map<String, double> _calculate() {
    // 1. Geometria da Cova (Paralelepípedo: C x L x P)
    // Converter cm para dm para facilitar (1 dm³ = 1 Litro)
    double lenDm = _holeLengthCm / 10.0;
    double widDm = _holeWidthCm / 10.0;
    double depthDm = _holeDepthCm / 10.0;

    double volCovaLiters = lenDm * widDm * depthDm; 

    // 2. Stand (Plantas por hectare)
    double areaPorPlanta = _spacingLineM * _spacingPlantM;
    double standHa = (areaPorPlanta > 0) ? 10000 / areaPorPlanta : 0;

    // 3. Normalizar dose para Kg/Cova e L/Cova
    double bioMassKgCova = 0;
    double bioVolLCova = 0;

    if (_inputUnit == 'g/cova') {
      bioMassKgCova = _inputValue / 1000;
      bioVolLCova = (_bioDensity > 0) ? bioMassKgCova / _bioDensity : 0;
    } else if (_inputUnit == 'kg/cova') {
      bioMassKgCova = _inputValue;
      bioVolLCova = (_bioDensity > 0) ? bioMassKgCova / _bioDensity : 0;
    } else if (_inputUnit == 'L/cova') {
      bioVolLCova = _inputValue;
      bioMassKgCova = bioVolLCova * _bioDensity;
    } else if (_inputUnit == '% v/v') {
      // % do volume da cova
      bioVolLCova = volCovaLiters * (_inputValue / 100);
      bioMassKgCova = bioVolLCova * _bioDensity;
    }

    // 4. Derivadas por Cova
    double concVV = (volCovaLiters > 0) ? (bioVolLCova / volCovaLiters) * 100 : 0;
    
    // Estimativa de massa de solo (densidade ~1.2 kg/dm³ apenas para referência de %m/m)
    double soilMassKgCova = volCovaLiters * 1.2; 
    double concMM = (soilMassKgCova > 0) ? (bioMassKgCova / soilMassKgCova) * 100 : 0;

    // 5. Consolidação por Hectare
    double totalBiocharTonHa = (bioMassKgCova * standHa) / 1000;
    
    // 6. Financeiro e Carbono
    double materialCostHa = totalBiocharTonHa * 1000 * _bioPrice;
    
    // Fatores de Carbono
    double cTotalTon = totalBiocharTonHa * (_carbonPercent / 100);
    double cStableTon = cTotalTon * (_stabilityPercent / 100);
    double co2EqTon = cStableTon * (44 / 12);

    return {
      'volCovaL': volCovaLiters,
      'standHa': standHa,
      'kg/cova': bioMassKgCova,
      'L/cova': bioVolLCova,
      'v/v %': concVV,
      'm/m %': concMM, // Estimado
      't/ha': totalBiocharTonHa,
      'costHa': materialCostHa,
      'co2EqTon': co2EqTon,
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
  String _money(double v) => NumberFormat.currency(locale: 'en_US', symbol: '\$').format(v);

  @override
  Widget build(BuildContext context) {
    final res = _calculate();

    return Scaffold(
      appBar: AppBar(title: const Text("Cálculo de Cova")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             _section("1. Dimensões da Cova (cm)"),
             _card(child: _buildGeometryCard(res)),

             const SizedBox(height: 16),
             _section("2. Dose e Insumo"),
             _card(child: Column(
               children: [
                 _buildDoseInput(),
                 const SizedBox(height: 12),
                 const Divider(),
                 const SizedBox(height: 12),
                 _buildBioParams(),
               ],
             )),

             const SizedBox(height: 24),
             _section("RESULTADOS POR COVA"),
             _buildCovaResults(res),

             const SizedBox(height: 24),
             _section("PROJEÇÃO POR HECTARE"),
             _buildHaResults(res),
             
             const SizedBox(height: 24),
             _card(child: _buildEconomics(res)),

             const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS DE CONSTRUÇÃO ---

  Widget _buildGeometryCard(Map<String, double> res) {
    return Column(
      children: [
        // Linha 1: Comprimento e Largura
        Row(
          children: [
            Expanded(child: _input("Comp. (cm)", _lenCtrl, (v) => _holeLengthCm = v)),
            const SizedBox(width: 12),
            Expanded(child: _input("Larg. (cm)", _widCtrl, (v) => _holeWidthCm = v)),
          ],
        ),
        const SizedBox(height: 12),
        // Linha 2: Profundidade e Volume Calculado
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: _input("Prof. (cm)", _depthCtrl, (v) => _holeDepthCm = v)),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 50, // Altura para alinhar com o input
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
                    Text("Volume:", style: TextStyle(color: Colors.blue.shade800, fontSize: 10)),
                    Text("${_fmt(res['volCovaL']!)} Litros", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade900, fontSize: 16)),
                  ],
                ),
              ),
            ),
          ],
        ),
        
        const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider()),
        
        const Align(
          alignment: Alignment.centerLeft,
          child: Text("Espaçamento de Plantio (m)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _input("Entre Linhas", _spLineCtrl, (v) => _spacingLineM = v)),
            const SizedBox(width: 12),
            Expanded(child: _input("Entre Plantas", _spPlantCtrl, (v) => _spacingPlantM = v)),
          ],
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4)),
            child: Text("Stand: ${_fmt(res['standHa']!, 0)} plantas/ha", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
          ),
        )
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
            items: ['g/cova', 'kg/cova', 'L/cova', '% v/v'].map((u) => DropdownMenuItem(value: u, child: Text(u, style: const TextStyle(fontSize: 13)))).toList(),
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

  // CORREÇÃO DO OVERFLOW NO GRID: Usando mainAxisExtent
  Widget _buildCovaResults(Map<String, double> res) {
    final items = [
      {'l': 'Massa/Cova', 'v': "${_fmt(res['kg/cova']!, 3)} kg"},
      {'l': 'Volume/Cova', 'v': "${_fmt(res['L/cova']!, 2)} L"},
      {'l': 'Conc. v/v', 'v': "${_fmt(res['v/v %']!, 1)} %", 'h': true},
      {'l': 'Conc. m/m (Est.)', 'v': "~${_fmt(res['m/m %']!, 1)} %"},
    ];

    return GridView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: 90, // Altura FIXA para evitar overflow
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
              Text(item['v'] as String, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: highlight ? Colors.green.shade800 : Colors.black87)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHaResults(Map<String, double> res) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("CONSUMO TOTAL", style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text("${_fmt(res['t/ha']!)} t/ha", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryContainer)),
            ],
          ),
          Column(
             crossAxisAlignment: CrossAxisAlignment.end,
             children: [
               const Icon(Icons.grid_view, color: Colors.black26),
               Text("Stand: ${_fmt(res['standHa']!, 0)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
             ],
          )
        ],
      ),
    );
  }

  Widget _buildEconomics(Map<String, double> res) {
    double minRev = res['co2EqTon']! * _priceMin;
    double maxRev = res['co2EqTon']! * _priceMax;
    
    return ExpansionTile(
      title: const Row(
        children: [
           Icon(Icons.monetization_on_outlined, color: Colors.green),
           SizedBox(width: 8),
           Text("Financeiro & Carbono", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
        ],
      ),
      initiallyExpanded: false,
      shape: const Border(),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Custo Material / ha:"),
                  Text(_money(res['costHa']!), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Potencial Líquido CO₂e:"),
                  Text("${_fmt(res['co2EqTon']!)} t", style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    Text("Receita Carbono (Estimada)", style: TextStyle(fontSize: 11, color: Colors.green.shade900)),
                    const SizedBox(height: 4),
                    Text("${_money(minRev)} - ${_money(maxRev)}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green.shade800)),
                  ],
                ),
              )
            ],
          ),
        )
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