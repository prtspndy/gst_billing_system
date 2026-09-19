class BillItem {
  final String itemId;
  final String name;
  final String? hsnCode;
  final int qty;
  final double rate;
  final double gstPercent;
  final double taxableAmount;
  final double cgst;
  final double sgst;
  final double igst;
  final double lineTotal;

  const BillItem({
    required this.itemId,
    required this.name,
    this.hsnCode,
    required this.qty,
    required this.rate,
    required this.gstPercent,
    required this.taxableAmount,
    required this.cgst,
    required this.sgst,
    required this.igst,
    required this.lineTotal,
  });

  double get totalTax => cgst + sgst + igst;

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'name': name,
      'hsnCode': hsnCode,
      'qty': qty,
      'rate': rate,
      'gstPercent': gstPercent,
      'taxableAmount': taxableAmount,
      'cgst': cgst,
      'sgst': sgst,
      'igst': igst,
      'lineTotal': lineTotal,
    };
  }

  factory BillItem.fromMap(Map<String, dynamic> map) {
    return BillItem(
      itemId: map['itemId'] as String,
      name: map['name'] as String,
      hsnCode: map['hsnCode'] as String?,
      qty: (map['qty'] as num).toInt(),
      rate: (map['rate'] as num).toDouble(),
      gstPercent: (map['gstPercent'] as num).toDouble(),
      taxableAmount: (map['taxableAmount'] as num).toDouble(),
      cgst: (map['cgst'] as num).toDouble(),
      sgst: (map['sgst'] as num).toDouble(),
      igst: (map['igst'] as num).toDouble(),
      lineTotal: (map['lineTotal'] as num).toDouble(),
    );
  }
}
