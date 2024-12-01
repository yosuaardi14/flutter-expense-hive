class Expense {
  String id;
  String title;
  double amount;
  String type;
  String payment;
  DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.payment,
    required this.date,
  });

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map["id"],
      title: map["title"],
      amount: double.parse(map["amount"].toString()),
      type: map["type"],
      payment: map["payment"],
      date: DateTime.parse(map["date"]),
    );
  }
}
