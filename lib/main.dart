import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Income {
  final String description;
  final double amount;

  Income({required this.description, required this.amount});
}

class Expense {
  final String description;
  final double amount;

  Expense({required this.description, required this.amount});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Manager',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Income> incomes = [];
  final List<Expense> expenses = [];

  final TextEditingController _incomeDescriptionController = TextEditingController();
  final TextEditingController _incomeAmountController = TextEditingController();

  final TextEditingController _expenseDescriptionController = TextEditingController();
  final TextEditingController _expenseAmountController = TextEditingController();

  void _addIncome() {
    final description = _incomeDescriptionController.text;
    final amount = double.tryParse(_incomeAmountController.text) ?? 0.0;
    if (description.isNotEmpty && amount > 0) {
      setState(() {
        incomes.add(Income(description: description, amount: amount));
      });
      _incomeDescriptionController.clear();
      _incomeAmountController.clear();
    }
  }

  void _addExpense() {
    final description = _expenseDescriptionController.text;
    final amount = double.tryParse(_expenseAmountController.text) ?? 0.0;
    if (description.isNotEmpty && amount > 0) {
      setState(() {
        expenses.add(Expense(description: description, amount: amount));
      });
      _expenseDescriptionController.clear();
      _expenseAmountController.clear();
    }
  }

  double _total() {
    double total = 0.0;
    if (incomes != null) {
      total += incomes.fold(0.0, (sum, income) => sum.toDouble() + income.amount);
    }
    if (expenses != null) {
      total -= expenses.fold(0.0, (sum, expense) => sum.toDouble() + expense.amount);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Money Manager'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
          Text(
          'Incomes',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        TextField(
          controller: _incomeDescriptionController,
          decoration: InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 8.0),
        TextField(
          controller: _incomeAmountController,
          decoration: InputDecoration(
            labelText: 'Amount',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: _addIncome,
          child: Text('Add Income'),
        ),
        SizedBox(height: 16.0),
        Text(
          'Expenses',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        TextField(
          controller: _expenseDescriptionController,
          decoration: InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 8.0),
        TextField(
          controller: _expenseAmountController,
          decoration: InputDecoration(
              labelText: 'Amount',
              border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
      ),
      SizedBox(height: 8.0),
      ElevatedButton(
        onPressed: _addExpense,
        child: Text('Add Expense'),
      ),
      SizedBox(height: 16.0),
      Text(
        'Summary',
        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 8.0),
      Expanded(
        child: ListView(
          children: <Widget>[
            ...incomes.map((income) =>
                ListTile(
                  leading: Text(
                    income.amount.toStringAsFixed(2),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  title: Text(income.description),
                )).toList(),
            ...expenses.map((expense) =>
                ListTile(
                  leading: Text(
                    expense.amount.toStringAsFixed(2),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  title: Text(expense.description),
                )).toList(),
            ListTile(
              leading: Text(
                _total().toStringAsFixed(2),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              title: Text('Total'),
            ),
          ],
        ),
      ),
      ],
    ),)
    ,
    );
  }
}