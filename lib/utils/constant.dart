class Constant {
  static const String semua = "Semua";
  static const String perHari = "Per Hari";
  static const String perMinggu = "Per Minggu";
  static const String perBulan = "Per Bulan";
  static const String expense = "Expense";
  static const String budget = "Budget";
  static const String outcome = "Outcome";
  static const String income = "Income";
  static const String pengeluaran = "Pengeluaran";
  static const String pemasukan = "Pemasukan";
  static const String importModeMerge = "Merge";
  static const String importModeInsert = "Insert";
  static const String importModeReplace = "Replace";
  static const String importModeUpdate = "Update";

  static const Map<String, String> dropdownMonth = {
    "0": semua,
    "1": "Januari",
    "2": "Februari",
    "3": "Maret",
    "4": "April",
    "5": "Mei",
    "6": "Juni",
    "7": "Juli",
    "8": "Agustus",
    "9": "September",
    "10": "Oktober",
    "11": "November",
    "12": "Desember",
  };

  static List<String> hari = [
    "Senin",
    "Selasa",
    "Rabu",
    "Kamis",
    "Jumat",
    "Sabtu",
    "Minggu",
  ];

  static Map<String, String> dropdownMonthOnly = {
    ...Map<String, String>.from(dropdownMonth)..remove("0"),
  };

  static const List<String> dropdownType = [
    semua,
    "Makan",
    "Minum",
    "Kebutuhan", // Belanja Pokok
    "Tagihan",
    "Jasa",
    "Belanja",
    "Transportasi",
    "Kesehatan",
    "Sosial",
    "Keuangan",
    "Gaya Hidup",
    "Lainnya",
  ];

  static List<String> dropdownTypeOnly = [
    ...List.unmodifiable(dropdownType.sublist(1)),
  ];

  static const List<String> dropdownPayment = [
    semua,
    "Tunai",
    "GoPay",
    "OVO",
    "Dana",
    "Bank",
    "Lainnya",
  ];

  static const List<String> mode = [outcome, income];

  static const List<String> dropdownBudgetPeriod = [
    perHari,
    perMinggu,
    perBulan,
  ];
}
