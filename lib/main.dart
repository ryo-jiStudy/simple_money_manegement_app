import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class Income {
  final String description;
  final double amount;

  Income({required this.description, required this.amount});

  Map<String, dynamic> toJson() => {
    'description': description,
    'amount': amount,
  };
}

class Expense {
  final String description;
  final double amount;

  Expense({required this.description, required this.amount});

  Map<String, dynamic> toJson() => {
    'description': description,
    'amount': amount,
  };
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

  void _saveData() async {
    // SharedPreferencesのインスタンスを取得する
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> incomesA = incomes.map((income) => jsonEncode(income.toJson())).toList();
    List<String> expensesA = expenses.map((expense) => jsonEncode(expense.toJson())).toList();
    Map<String, List<String>> data = {
      'incomes': incomesA,
      'expenses': expensesA,
    };
    String encodedData = jsonEncode(data);

    // Save data to device storage
    prefs.setString('data', encodedData);
  }

  @override
  void initState() {
    super.initState();
    // 初期化処理を行う
    _loadData();
  }

  void _loadData() async {
    // 外部リソースからデータを読み込む処理を行う
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('data');

    if (encodedData == null) {
      return;
    }

    final Map<String, dynamic> decodedData = jsonDecode(encodedData);
    final List<Income> loadedIncomes = [];
    final List<Expense> loadedExpenses = [];

    for (final item in decodedData['incomes']) {
      loadedIncomes.add(Income(
      description: jsonDecode(item)['description'],
      amount: jsonDecode(item)['amount'],
//      date: DateTime.parse(item['date']),
        ));
    }
    for (final item in decodedData['expenses']) {
      loadedExpenses.add(Expense(
      description: jsonDecode(item)['description'],
      amount: jsonDecode(item)['amount'],
//      date: DateTime.parse(item['date']),
      ));
    }

    setState(() {
      incomes.addAll(loadedIncomes);
      expenses.addAll(loadedExpenses);
    });
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
      SizedBox(height: 10),
      TextButton(
        onPressed: () => _saveData(),
        child: Text('Save'),
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