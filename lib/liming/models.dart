import 'package:flutter/material.dart';

class LimingAgent {
  final String name;
  final String chemicalName;
  final String formula;
  final String solubility;
  final String level;
  final String description;
  final Color color;

  const LimingAgent({
    required this.name,
    required this.chemicalName,
    required this.formula,
    required this.solubility,
    required this.level,
    required this.description,
    required this.color,
  });
}