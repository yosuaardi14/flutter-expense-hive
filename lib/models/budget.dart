class Budget {
  String id; // => type_month_year_param
  int month;
  int year;
  String type;
  String period;
  double amount;
  int param; // Default = 0
  String? parentid;
  //
  List<Budget> children;
  double? totalExpense;
  double? percentage;
  double? remainder;

  Budget({
    required this.id,
    required this.month,
    required this.year,
    required this.type,
    required this.period,
    required this.amount,
    required this.param,
    this.parentid,
    required this.children,
    this.totalExpense,
    this.percentage,
  });

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map["id"],
      month: int.parse(map["month"].toString()),
      year: int.parse(map["year"].toString()),
      amount: double.parse(map["amount"].toString()),
      type: map["type"],
      period: map["period"],
      param: map["param"],
      parentid: map["parentid"],
      children: List<Budget>.from(map["children"] ?? []),
    );
  }

  factory Budget.fromList(List<dynamic> list) {
    return Budget(
      id: list[0].toString(),
      month: int.parse(list[1].toString()),
      year: int.parse(list[2].toString()),
      amount: double.tryParse(list[2].toString()) ?? 0,
      type: list[3].toString(),
      period: list[4].toString(),
      param: list[5],
      children: [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "month": month,
      "year": year,
      "amount": amount,
      "type": type,
      "period": period,
      "param": param,
      "parentid": parentid,
    };
  }

  static List<String> props() => [
    "id",
    "month",
    "year",
    "amount",
    "type",
    "period",
    "param",
    "parentid",
  ];

  List<dynamic> toList() {
    return [id, month, year, amount, type, period, param, parentid];
  }
}

// class Budget {
//   String id;
//   int month;
//   int year;
//   String type;
//   String period;
//   double amount;
//   List<BudgetRule> rules;

//   Budget({
//     required this.id,
//     required this.month,
//     required this.year,
//     required this.type,
//     required this.period,
//     required this.amount,
//     required this.rules,
//   });

//   factory Budget.fromMap(Map<String, dynamic> map) {
//     return Budget(
//       id: map["id"],
//       month: int.parse(map["month"].toString()),
//       year: int.parse(map["year"].toString()),
//       amount: double.parse(map["amount"].toString()),
//       type: map["type"],
//       period: map["period"],
//       rules: List<BudgetRule>.from(map["rules"] ?? []),
//     );
//   }
// }

// class BudgetRule {
//   String id;
//   String budgetid;
//   String paramtype;
//   String param;
//   double amount;

//   BudgetRule({
//     required this.id,
//     required this.budgetid,
//     required this.paramtype,
//     required this.param,
//     required this.amount,
//   });

//   factory BudgetRule.fromMap(Map<String, dynamic> map) {
//     return BudgetRule(
//       id: map["id"],
//       budgetid: map["budgetid"],
//       amount: double.parse(map["amount"].toString()),
//       paramtype: map["paramtype"],
//       param: map["param"],
//     );
//   }
// }
