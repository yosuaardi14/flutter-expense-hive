class Constant {
  static const Map<String, String> dropdownMonth = {
    "0": "Semua",
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
    "Semua",
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
    ...List<String>.from(dropdownType).sublist(1),
  ];

  static const List<String> dropdownPayment = [
    "Semua",
    "Tunai",
    "GoPay",
    "OVO",
    "Dana",
    "Bank",
    "Lainnya",
  ];

  static const List<String> mode = ["Outcome", "Income"];

  static const List<String> dropdownBudgetPeriod = [
    "Per Hari",
    "Per Minggu",
    "Per Bulan",
  ];
}
