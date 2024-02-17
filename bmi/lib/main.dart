import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Main function to run the BMI Calculator app.
void main() {
  runApp(BMICalculatorApp());
}

/// The main application widget for the BMI Calculator.
class BMICalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BMI Calculator',
      initialRoute: '/calculate',
      getPages: [
        GetPage(name: '/calculate', page: () => CalculateScreen()),
        GetPage(name: '/info', page: () => InfoScreen()),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}

/// The screen for calculating and displaying the BMI.
class CalculateScreen extends StatelessWidget {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final RxDouble bmiResult = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calculate BMI')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: heightController,
              decoration: InputDecoration(labelText: 'Height (cm)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: weightController,
              decoration: InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String heightText = heightController.text.trim();
                String weightText = weightController.text.trim();
///Error message for null inputs
                if (heightText.isEmpty || weightText.isEmpty) {
                  Get.snackbar('Error', 'Please enter both height and weight.');
                  return;
                }

                double height = double.tryParse(heightText) ?? 0;
                double weight = double.tryParse(weightText) ?? 0;

                double minHeight = 100;
                double maxHeight = 250;
                double minWeight = 20;
                double maxWeight = 200;

///Error message for invalid inputs
                if (height < minHeight ||
                    height > maxHeight ||
                    weight < minWeight ||
                    weight > maxWeight) {
                  Get.snackbar('Error', 'Please enter valid height and weight.');
                  return;
                }

                double bmi = weight / ((height / 100) * (height / 100));

                bmiResult.value = bmi.clamp(10.0, 40.0);
              },
              child: Text('Calculate'),
            ),
            SizedBox(height: 20),
            Obx(() => Text(
              'BMI Result: ${bmiResult.value.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            )),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Get.toNamed('/info', arguments: bmiResult.value);
              },
              child: Text(
                'Category Info',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The screen for displaying category information.
class InfoScreen extends StatelessWidget {
  final List<String> categories = [
    'Underweight',
    'Normal weight',
    'Overweight',
    'Obesity',
  ];

  final List<String> categoryDescriptions = [
    'You have a BMI lower than 18.5. You may be underweight.',
    'You have a BMI between 18.5 and 24.9. You have a normal weight.',
    'You have a BMI between 25 and 29.9. You may be overweight.',
    'You have a BMI of 30 or higher. You may have obesity.',
  ];

  @override
  Widget build(BuildContext context) {
    double bmi = Get.arguments ?? 0;

    int categoryIndex = bmi < 18.5 ? 0 : bmi < 25 ? 1 : bmi < 30 ? 2 : 3;

    return Scaffold(
      appBar: AppBar(title: Text('BMI Info')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your BMI is: ${bmi.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Category: ${categories[categoryIndex]}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              categoryDescriptions[categoryIndex],
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
