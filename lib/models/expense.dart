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

  factory Expense.fromList(List<dynamic> list) {
    return Expense(
      id: list[0].toString(),
      title: list[1].toString(),
      amount: double.tryParse(list[2].toString()) ?? 0.0,
      type: list[3].toString(),
      payment: list[4].toString(),
      date: DateTime.tryParse(list[5].toString()) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "amount": amount,
      "type": type,
      "payment": payment,
      "date": date.toString(),
    };
  }

  static List<String> props() => [
    "id",
    "title",
    "amount",
    "type",
    "payment",
    "date",
  ];

  List<dynamic> toList() {
    return [id, title, amount, type, payment, date.toString()];
  }
}
