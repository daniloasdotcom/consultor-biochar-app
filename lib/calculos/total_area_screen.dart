import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BiocharCalc {
  final double depthM;
  final double soilDensityKgM3;
  final double bioDensityKgM3;
  
  final double carbonContentPercent;
  final double biocharPricePerKg;
  final double stabilityFactorPercent;

  BiocharCalc({
    required this.depthM,
    required this.soilDensityKgM3,
    required this.bioDensityKgM3,
    required this.carbonContentPercent,
    required this.biocharPricePerKg,
    required this.stabilityFactorPercent,
  });

  double soilVolume() => 10000 * depthM;
  double soilMass() => soilVolume() * soilDensityKgM3;

  double inputToKgHa(double value, String unit) {
    final vol = soilVolume();
    final mass = soilMass();

    return switch (unit) {
      't/ha' => value * 1000,
      'kg/ha' => value,
      'massa/massa (%)' => (value / 100) * mass,
      'volume/volume (%)' => (value / 100) * vol * bioDensityKgM3,
      'massa/volume' => value * vol,
      _ => 0.0,
    };
  }

  Map<String, double> compute(double inputValue, String unit) {
    final kgHa = inputToKgHa(inputValue, unit);
    final volSolo = soilVolume();
    final massSolo = soilMass();

    final fracMm = massSolo > 0 ? kgHa / massSolo : 0.0;
    final volBio = bioDensityKgM3 > 0 ? kgHa / bioDensityKgM3 : 0.0;
    final fracVv = volSolo > 0 ? volBio / volSolo : 0.0;

    // --- CUSTO DO MATERIAL ---
    final materialCost = kgHa * biocharPricePerKg;

    // --- CÁLCULOS DE CARBONO ---
    final carbonMassTon = (kgHa / 1000) * (carbonContentPercent / 100);
    final stableCarbonTon = carbonMassTon * (stabilityFactorPercent / 100);
    final co2EqTon = stableCarbonTon * (44 / 12);

    return {
      'kg/ha': kgHa,
      't/ha': kgHa / 1000,
      'm/m %': fracMm * 100,
      'm/m g/kg': fracMm * 1000,
      'v/v %': fracVv * 100,
      'kg/m³': volSolo > 0 ? kgHa / volSolo : 0.0,
      'carbonTon': carbonMassTon,
      'stableCarbonTon': stableCarbonTon,
      'co2EqTon': co2EqTon,
      'materialCost': materialCost,
      'volSolo': volSolo,
      'massSolo': massSolo,
      'volBio': volBio,
      'densSolo': soilDensityKgM3,
      'densBio': bioDensityKgM3,
    };
  }
}

// ----------------------------------------------------------------------
// Funções auxiliares
// ----------------------------------------------------------------------

double convertDensityToKgM3(double val, String unit) {
  return switch (unit) {
    'Mg/m³' => val * 1000,
    'g/cm³' => val * 1000,
    'kg/dm³' => val * 1000,
    'g/dm³' => val * 1,
    _ => val,
  };
}

// CORREÇÃO FORMATADOR: Versão mais compatível
String fmt(double val, [int decimals = 2]) {
  final f = NumberFormat.decimalPattern('pt_BR');
  f.minimumFractionDigits = decimals;
  f.maximumFractionDigits = decimals;
  return f.format(val);
}

String fmtMoney(double v) {
  final f = NumberFormat.currency(locale: 'en_US', symbol: '\$');
  return f.format(v);
}

// ----------------------------------------------------------------------
// Interface
// ----------------------------------------------------------------------
class TotalAreaScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const TotalAreaScreen({super.key, required this.onToggleTheme});

  @override
  State<TotalAreaScreen> createState() => _TotalAreaScreenState();
}

class _TotalAreaScreenState extends State<TotalAreaScreen> {
  final List<String> _units = [
    't/ha',
    'kg/ha',
    'm/m (%)',     // Abreviei para caber melhor
    'v/v (%)',     // Abreviei para caber melhor
    'massa/vol'    // Abreviei para caber melhor
  ];

  final List<String> _densUnits = [
    'Mg/m³',
    'g/cm³',
    'kg/dm³',
    'kg/m³',
    'g/dm³'
  ];

  String _inputUnit = 't/ha';
  double _inputValue = 10.0;
  
  double _depthCm = 20.0;
  double _soilDensity = 1.3;
  String _soilDensityUnit = 'kg/dm³';
  
  double _bioDensity = 0.5;
  String _bioDensityUnit = 'kg/dm³';
  
  double _carbonPercent = 75.0;
  double _biocharPrice = 0.40;
  double _stabilityPercent = 80.0;

  double _priceMin = 80.0;
  double _priceMax = 150.0;

  late TextEditingController _valCtrl;
  late TextEditingController _depthCtrl;
  late TextEditingController _soilCtrl;
  late TextEditingController _bioCtrl;
  late TextEditingController _carbonCtrl;
  late TextEditingController _bioPriceCtrl;
  late TextEditingController _stabilityCtrl;
  late TextEditingController _priceMinCtrl;
  late TextEditingController _priceMaxCtrl;

  @override
  void initState() {
    super.initState();
    _valCtrl = TextEditingController(text: '10,0');
    _depthCtrl = TextEditingController(text: '20,0');
    _soilCtrl = TextEditingController(text: '1,3');
    _bioCtrl = TextEditingController(text: '0,5');
    _carbonCtrl = TextEditingController(text: '75,0');
    _bioPriceCtrl = TextEditingController(text: '0,40');
    _stabilityCtrl = TextEditingController(text: '80,0');
    _priceMinCtrl = TextEditingController(text: '80,0');
    _priceMaxCtrl = TextEditingController(text: '150,0');
  }

  Map<String, double> _calculate() {
    // Normalização da unidade para o cálculo (caso tenha abreviado na lista)
    String unitForCalc = _inputUnit;
    if (_inputUnit == 'm/m (%)') unitForCalc = 'massa/massa (%)';
    if (_inputUnit == 'v/v (%)') unitForCalc = 'volume/volume (%)';
    if (_inputUnit == 'massa/vol') unitForCalc = 'massa/volume';

    final calc = BiocharCalc(
      depthM: _depthCm / 100,
      soilDensityKgM3: convertDensityToKgM3(_soilDensity, _soilDensityUnit),
      bioDensityKgM3: convertDensityToKgM3(_bioDensity, _bioDensityUnit),
      carbonContentPercent: _carbonPercent,
      biocharPricePerKg: _biocharPrice,
      stabilityFactorPercent: _stabilityPercent,
    );
    return calc.compute(_inputValue, unitForCalc);
  }

  double _parseInput(String v) {
    String sanitized = v.replaceAll(',', '.');
    return double.tryParse(sanitized) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final res = _calculate();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Biochar Pro', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: widget.onToggleTheme,
              icon: const Icon(Icons.brightness_6)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Entrada de Dados'),
            _card(child: _buildInputCard()),
            
            const SizedBox(height: 20),
            _sectionTitle('Configurações'),
            _card(child: _buildParamsCard()),
            
            const SizedBox(height: 24),
            _sectionTitle('Resultados Consolidados'),
            _buildResultsGrid(res),

            const SizedBox(height: 24),
            _card(child: _buildMath(res)),
            
            const SizedBox(height: 16),
            _card(child: _buildCarbonEconomics(res)),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }

  // CORREÇÃO DO OVERFLOW 1: Ajuste de Flex e Dropdown
  Widget _buildInputCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Dose alvo', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3, // Equilibrado
              child: TextField(
                controller: _valCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (v) => setState(() => _inputValue = _parseInput(v)),
                decoration: const InputDecoration(
                  labelText: 'Valor', 
                  isDense: true
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2, // Menor prioridade para unidade
              child: DropdownButtonFormField<String>(
                value: _inputUnit,
                isExpanded: true, // Essencial
                decoration: const InputDecoration(
                  labelText: 'Unidade',
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                ),
                items: _units
                    .map((u) => DropdownMenuItem(
                          value: u,
                          child: Text(
                            u,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _inputUnit = v!),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildParamsCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- SOLO ---
        Row(
          children: [
            Icon(Icons.grass, size: 18, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            const Text('Parâmetros do Solo', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _depthCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (v) => setState(() => _depthCm = _parseInput(v)),
                decoration: const InputDecoration(labelText: 'Prof. (cm)'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _densityField(
                label: 'Densidade',
                controller: _soilCtrl,
                valSetter: (v) => _soilDensity = v,
                unit: _soilDensityUnit,
                onUnit: (u) => setState(() => _soilDensityUnit = u),
              ),
            ),
          ],
        ),

        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Divider(),
        ),

        // --- BIOCARVÃO ---
        Row(
          children: [
            Icon(Icons.local_fire_department, size: 18, color: Colors.orange.shade800),
            const SizedBox(width: 8),
            const Text('Parâmetros do Biocarvão', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _densityField(
                label: 'Densidade',
                controller: _bioCtrl,
                valSetter: (v) => _bioDensity = v,
                unit: _bioDensityUnit,
                onUnit: (u) => setState(() => _bioDensityUnit = u),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
               child: TextField(
                 controller: _bioPriceCtrl,
                 keyboardType: const TextInputType.numberWithOptions(decimal: true),
                 onChanged: (v) => setState(() => _biocharPrice = _parseInput(v)),
                 decoration: const InputDecoration(
                   labelText: 'Preço/kg', 
                   prefixText: '\$'
                 ),
               ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        Row(
          children: [
            Expanded(
               child: TextField(
                 controller: _carbonCtrl,
                 keyboardType: const TextInputType.numberWithOptions(decimal: true),
                 onChanged: (v) => setState(() => _carbonPercent = _parseInput(v)),
                 decoration: const InputDecoration(labelText: '% Carbono', suffixText: '%'),
               ),
            ),
            const SizedBox(width: 12),
            Expanded(
               child: TextField(
                 controller: _stabilityCtrl,
                 keyboardType: const TextInputType.numberWithOptions(decimal: true),
                 onChanged: (v) => setState(() => _stabilityPercent = _parseInput(v)),
                 decoration: const InputDecoration(labelText: 'Estabilidade', suffixText: '%'),
               ),
            ),
          ],
        )
      ],
    );
  }

  Widget _densityField({
    required String label,
    required TextEditingController controller,
    required Function(double) valSetter,
    required String unit,
    required Function(String) onUnit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (v) => setState(() => valSetter(_parseInput(v))),
          decoration: InputDecoration(labelText: label),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 35,
          child: DropdownButtonFormField(
            value: unit,
            isExpanded: true,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              border: OutlineInputBorder(),
            ),
            items: _densUnits.map((u) => DropdownMenuItem(value: u, child: Text(u, style: const TextStyle(fontSize: 12)))).toList(),
            onChanged: (v) => onUnit(v!),
          ),
        )
      ],
    );
  }

  Widget _buildResultsGrid(Map<String, double> res) {
    // Labels curtos para evitar overflow em telas pequenas
    final items = [
      {'label': 't/ha', 'value': res['t/ha'] as double, 'highlight': _inputUnit == 't/ha'},
      {'label': 'kg/ha', 'value': res['kg/ha'] as double, 'highlight': _inputUnit == 'kg/ha'},
      {'label': 'Massa/Massa (%)', 'value': res['m/m %'] as double, 'highlight': _inputUnit.contains('m/m') || _inputUnit.contains('massa/massa')},
      {'label': 'Volume/Volume (%)', 'value': res['v/v %'] as double, 'highlight': _inputUnit.contains('v/v') || _inputUnit.contains('volume/volume')},
      {'label': 'Massa/Volume (kg/m³)', 'value': res['kg/m³'] as double, 'highlight': _inputUnit.contains('massa/vol')},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 100,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (ctx, i) {
        final it = items[i];
        final isHighlight = it['highlight'] as bool;
        
        return Container(
          decoration: BoxDecoration(
            color: isHighlight 
                ? Theme.of(context).colorScheme.primaryContainer 
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: isHighlight 
                ? Border.all(color: Theme.of(context).colorScheme.primary, width: 1.5)
                : Border.all(color: Colors.transparent),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ]
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                it['label'] as String,
                style: TextStyle(
                  color: isHighlight 
                    ? Theme.of(context).colorScheme.onPrimaryContainer 
                    : Theme.of(context).hintColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                fmt(it['value'] as double, 4),
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 18,
                  color: isHighlight 
                    ? Theme.of(context).colorScheme.primary 
                    : Theme.of(context).textTheme.bodyLarge?.color
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // CORREÇÃO DO OVERFLOW 2: Título com Expanded
  Widget _buildCarbonEconomics(Map<String, double> r) {
    final co2 = r['co2EqTon']!;
    final materialCost = r['materialCost']!;
    
    final minRev = co2 * _priceMin;
    final maxRev = co2 * _priceMax;
    final balanceAvg = ((minRev + maxRev) / 2) - materialCost;

    return ExpansionTile(
      shape: const Border(),
      collapsedIconColor: Colors.green.shade700,
      iconColor: Colors.green.shade700,
      title: Row(
        children: [
          Icon(Icons.monetization_on_outlined, color: Colors.green.shade700),
          const SizedBox(width: 8),
          Expanded( 
            child: Text(
              'Análise Financeira (Estimativa)', 
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      children: [
        const Text(
          "Cálculo: (Massa × %C × Estabilidade × 44/12).",
          style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.grey),
        ),
        const SizedBox(height: 12),
        
        _math('Custo Material', '${fmt(r['kg/ha']!, 0)} kg × ${fmtMoney(_biocharPrice)} = ${fmtMoney(materialCost)}'),
        const Divider(),
        _math('Carbono Total', '${fmt(r['t/ha']!)} t × ${fmt(_carbonPercent)}% = ${fmt(r['carbonTon']!)} tC'),
        _math('Fator Estabilidade', '${fmt(r['carbonTon']!)} tC × ${fmt(_stabilityPercent)}% = ${fmt(r['stableCarbonTon']!, 3)} tC(est)'),
        _math('Crédito Líquido', '${fmt(r['stableCarbonTon']!, 3)} × 3,67 = ${fmt(r['co2EqTon']!, 2)} tCO₂e'),
        
        const Divider(),
        
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _priceMinCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (v) => setState(() => _priceMin = _parseInput(v)),
                  decoration: const InputDecoration(labelText: 'Preço C. Mín', prefixText: '\$'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _priceMaxCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (v) => setState(() => _priceMax = _parseInput(v)),
                  decoration: const InputDecoration(labelText: 'Preço C. Máx', prefixText: '\$'),
                ),
              ),
            ],
          ),
        ),
        
        Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.shade200)
          ),
          child: Column(
            children: [
              const Text("RECEITA POTENCIAL DE CARBONO (USD/ha)", 
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green)),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(fmtMoney(minRev), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green.shade800)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text("—", style: TextStyle(color: Colors.grey)),
                  ),
                  Text(fmtMoney(maxRev), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green.shade800)),
                ],
              ),
              const Divider(color: Colors.green),
              
              // CORREÇÃO DO OVERFLOW 3: Balanço em Coluna para caber valores grandes
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: [
                    Text("Custo Biochar: ${fmtMoney(materialCost)}", 
                      style: const TextStyle(fontSize: 12, color: Colors.red)),
                    const SizedBox(height: 4),
                    Text("Balanço (Média): ${fmtMoney(balanceAvg)}", 
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildMath(Map<String, double> r) {
    return ExpansionTile(
      shape: const Border(),
      title: const Row(
        children: [
          Icon(Icons.calculate_outlined),
          SizedBox(width: 8),
          Text('Memória de Cálculo (Física)', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
      children: [
        _math('1. Volume de solo (ha)',
            '10.000 m² × ${fmt(_depthCm / 100)} m = ${fmt(r['volSolo']!)} m³'),
        const Divider(),
        _math('2. Massa de solo (ha)',
            '${fmt(r['volSolo']!)} m³ × ${fmt(r['densSolo']!)} kg/m³ = ${fmt(r['massSolo']!)} kg'),
        const Divider(),
        _math('3. Quantidade absoluta',
            'Baseado em $_inputUnit: ${fmt(r['kg/ha']!)} kg/ha'),
        const Divider(),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text('Conversões derivadas',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        _math('Massa/Massa (%)',
            '(${fmt(r['kg/ha']!)} / ${fmt(r['massSolo']!)}) × 100 = ${fmt(r['m/m %']!, 4)} %'),
        _math('Massa/Massa (g/kg)',
            '${fmt(r['m/m %']!, 4)} % × 10 = ${fmt(r['m/m g/kg']!, 4)} g/kg'),
        _math('Volume Biochar',
            '${fmt(r['kg/ha']!)} kg / ${fmt(r['densBio']!)} kg/m³ = ${fmt(r['volBio']!, 4)} m³'),
        _math('Volume/Volume',
            '(${fmt(r['volBio']!, 4)} / ${fmt(r['volSolo']!)}) × 100 = ${fmt(r['v/v %']!, 4)} %'),
        _math('Massa/Volume',
            '${fmt(r['kg/ha']!)} kg / ${fmt(r['volSolo']!)} m³ = ${fmt(r['kg/m³']!, 4)} kg/m³'),
      ],
    );
  }

  Widget _math(String label, String eq) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.bold))
          ),
          Expanded(
            child: Text(
              eq,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: Theme.of(context).colorScheme.secondary,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}