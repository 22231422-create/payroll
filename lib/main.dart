import 'package:flutter/material.dart';

void main() {
  runApp(PayrollApp());
}

class PayrollApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PayrollScreen(),
    );
  }
}

class PayrollScreen extends StatefulWidget {
  @override
  _PayrollScreenState createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen> {
  final basicSalaryController = TextEditingController();
  final totalHoursController = TextEditingController();
  final overtimeHoursController = TextEditingController();
  final overtimeRateController = TextEditingController();
  final taxController = TextEditingController();

  double regularPay = 0;
  double overtimePay = 0;
  double grossPay = 0;
  double taxAmount = 0;
  double netPay = 0;

  void calculatePayroll() {
    double basicSalary = double.tryParse(basicSalaryController.text) ?? 0;
    double totalHours = double.tryParse(totalHoursController.text) ?? 0;
    double overtimeHours = double.tryParse(overtimeHoursController.text) ?? 0;
    double overtimeRate = double.tryParse(overtimeRateController.text) ?? 1;
    double taxPercent = double.tryParse(taxController.text) ?? 0;

    // Validation: Overtime cannot exceed total hours
    if (overtimeHours > totalHours) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Overtime hours cannot be greater than total hours."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Regular hours
    double regularHours = totalHours - overtimeHours;

    // Regular pay
    regularPay = basicSalary * regularHours;

    // Adjusted overtime rate
    double adjustedOvertimeRate = overtimeRate * basicSalary;

    // Overtime pay
    overtimePay = overtimeHours * adjustedOvertimeRate;

    // Gross pay
    grossPay = regularPay + overtimePay;

    // Tax amount
    taxAmount = grossPay * (taxPercent / 100);

    // Net pay
    netPay = grossPay - taxAmount;

    setState(() {});
  }

  Widget buildInput(String label, TextEditingController controller) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }

  Widget resultBox(String title, double value, {bool redNumber = false}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              "\$${value.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 18,
                color: redNumber ? Colors.red : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text("Payroll Calculator"),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // INPUT CARD
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Basic Salary + Total Hours
                    Row(
                      children: [
                        buildInput("Basic Salary", basicSalaryController),
                        buildInput("Total Hours", totalHoursController),
                      ],
                    ),

                    // Overtime Hours + Overtime Rate
                    Row(
                      children: [
                        buildInput("Overtime Rate", overtimeRateController),
                        buildInput("Overtime Hours", overtimeHoursController),
                      ],
                    ),

                    // Tax Percentage centered
                    Container(
                      width: 200,
                      margin: EdgeInsets.only(top: 8),
                      child: TextField(
                        controller: taxController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Tax Percentage (%)",
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 0.1),

            ElevatedButton(
              onPressed: calculatePayroll,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text("Calculate", style: TextStyle(fontSize: 18)),
            ),

            SizedBox(height: 0.1),

            // Regular Pay + Overtime Pay
            Row(
              children: [
                resultBox("Regular Pay", regularPay),
                resultBox("Overtime Pay", overtimePay),
              ],
            ),

            SizedBox(height: 0.1),

            // Gross Pay + Tax Amount (Tax number in red)
            Row(
              children: [
                resultBox("Gross Pay", grossPay),
                resultBox("Tax Amount", taxAmount, redNumber: true),
              ],
            ),

            SizedBox(height: 0.1),

            // NET PAY CENTERED
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  "Net Pay: \$${netPay.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
