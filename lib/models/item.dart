class Item {
  final String id;
  final String name;
  final String? hsnCode;
  final double unitPrice;
  final double gstPercent;
  final DateTime createdAt;

  Item({
    required this.id,
    required this.name,
    this.hsnCode,
    required this.unitPrice,
    required this.gstPercent,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Item copyWith({
    String? id,
    String? name,
    String? hsnCode,
    double? unitPrice,
    double? gstPercent,
    DateTime? createdAt,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      hsnCode: hsnCode ?? this.hsnCode,
      unitPrice: unitPrice ?? this.unitPrice,
      gstPercent: gstPercent ?? this.gstPercent,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'hsnCode': hsnCode,
      'unitPrice': unitPrice,
      'gstPercent': gstPercent,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] as String,
      name: map['name'] as String,
      hsnCode: map['hsnCode'] as String?,
      unitPrice: (map['unitPrice'] as num).toDouble(),
      gstPercent: (map['gstPercent'] as num).toDouble(),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
    );
  }
}
