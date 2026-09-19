import 'dart:convert';
import 'bill_item.dart';

class Bill {
  final String id;
  final String invoiceNo;
  final DateTime date;
  final String partyId;
  final String partyName;
  final String partyMobile;
  final String partyAddress;
  final String partyState;
  final String? partyGstin;
  final List<BillItem> items;
  final double subtotal;
  final double totalCgst;
  final double totalSgst;
  final double totalIgst;
  final double totalTax;
  final double grandTotal;
  final bool isInterState;
  final String paymentStatus; // 'Paid', 'Unpaid', 'Partial'
  final String? notes;
  final DateTime createdAt;

  Bill({
    required this.id,
    required this.invoiceNo,
    required this.date,
    required this.partyId,
    required this.partyName,
    required this.partyMobile,
    required this.partyAddress,
    required this.partyState,
    this.partyGstin,
    required this.items,
    required this.subtotal,
    required this.totalCgst,
    required this.totalSgst,
    required this.totalIgst,
    required this.totalTax,
    required this.grandTotal,
    required this.isInterState,
    this.paymentStatus = 'Paid',
    this.notes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'invoiceNo': invoiceNo,
      'date': date.toIso8601String(),
      'partyId': partyId,
      'partyName': partyName,
      'partyMobile': partyMobile,
      'partyAddress': partyAddress,
      'partyState': partyState,
      'partyGstin': partyGstin,
      'items': jsonEncode(items.map((i) => i.toMap()).toList()),
      'subtotal': subtotal,
      'totalCgst': totalCgst,
      'totalSgst': totalSgst,
      'totalIgst': totalIgst,
      'totalTax': totalTax,
      'grandTotal': grandTotal,
      'isInterState': isInterState ? 1 : 0,
      'paymentStatus': paymentStatus,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Bill.fromMap(Map<String, dynamic> map) {
    List<BillItem> parsedItems = [];
    if (map['items'] != null) {
      if (map['items'] is String) {
        final decoded = jsonDecode(map['items'] as String) as List;
        parsedItems = decoded.map((e) => BillItem.fromMap(e as Map<String, dynamic>)).toList();
      } else if (map['items'] is List) {
        parsedItems = (map['items'] as List)
            .map((e) => BillItem.fromMap(e as Map<String, dynamic>))
            .toList();
      }
    }

    return Bill(
      id: map['id'] as String,
      invoiceNo: map['invoiceNo'] as String,
      date: DateTime.parse(map['date'] as String),
      partyId: map['partyId'] as String,
      partyName: map['partyName'] as String,
      partyMobile: (map['partyMobile'] as String?) ?? '',
      partyAddress: (map['partyAddress'] as String?) ?? '',
      partyState: map['partyState'] as String,
      partyGstin: map['partyGstin'] as String?,
      items: parsedItems,
      subtotal: (map['subtotal'] as num).toDouble(),
      totalCgst: (map['totalCgst'] as num).toDouble(),
      totalSgst: (map['totalSgst'] as num).toDouble(),
      totalIgst: (map['totalIgst'] as num).toDouble(),
      totalTax: (map['totalTax'] as num).toDouble(),
      grandTotal: (map['grandTotal'] as num).toDouble(),
      isInterState: map['isInterState'] == 1 || map['isInterState'] == true,
      paymentStatus: (map['paymentStatus'] as String?) ?? 'Paid',
      notes: map['notes'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
    );
  }
}
