import 'package:flutter/material.dart';

void main() {
  runApp(const IMCCalculatorApp());
}

class IMCCalculatorApp extends StatelessWidget {
  const IMCCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator IMC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const IMCCalculatorPage(),
    );
  }
}

class IMCCalculatorPage extends StatefulWidget {
  const IMCCalculatorPage({super.key});

  @override
  State<IMCCalculatorPage> createState() => _IMCCalculatorPageState();
}

class _IMCCalculatorPageState extends State<IMCCalculatorPage> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  String result = '';

  void calculateBMI() {
    double? weight = double.tryParse(weightController.text);
    double? heightCm = double.tryParse(heightController.text);

    if (weight == null || heightCm == null || weight <= 0 || heightCm <= 0) {
      setState(() {
        result = 'Introduceți valori valide!';
      });
      return;
    }

    double heightM = heightCm / 100;

    double bmi = weight / (heightM * heightM);

    String category;

    if (bmi < 18.5) {
      category = 'Subponderal';
    } else if (bmi < 25) {
      category = 'Normal';
    } else if (bmi < 30) {
      category = 'Supraponderal';
    } else {
      category = 'Obezitate';
    }

    setState(() {
      result = 'IMC: ${bmi.toStringAsFixed(2)}\nCategoria: $category';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator IMC'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Text(
              'Calculator Indice de Masă Corporală',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Greutate (kg)',
                hintText: 'Ex: 70',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Înălțime (cm)',
                hintText: 'Ex: 180',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: calculateBMI,
              child: const Text(
                'Calculează IMC',
                style: TextStyle(fontSize: 18),
              ),
            ),

            const SizedBox(height: 30),

            Text(
              result,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }
}