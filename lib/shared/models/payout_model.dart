import 'package:equatable/equatable.dart';

class PayoutModel extends Equatable {
  final String id;
  final double amount;
  /// 'PENDING' | 'PAID' | 'FAILED'
  final String status;
  final String vendorId;
  final String description;
  final DateTime createdAt;
  final String bankName;
  final String accountNumber;

  const PayoutModel({
    required this.id,
    required this.amount,
    required this.status,
    required this.vendorId,
    required this.description,
    required this.createdAt,
    required this.bankName,
    required this.accountNumber,
  });

  factory PayoutModel.fromJson(Map<String, dynamic> json) {
    return PayoutModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String? ?? 'PENDING',
      vendorId: json['vendorId'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      bankName: json['bankName'] as String,
      accountNumber: json['accountNumber'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'status': status,
        'vendorId': vendorId,
        'description': description,
        'createdAt': createdAt.toIso8601String(),
        'bankName': bankName,
        'accountNumber': accountNumber,
      };

  PayoutModel copyWith({
    String? id,
    double? amount,
    String? status,
    String? vendorId,
    String? description,
    DateTime? createdAt,
    String? bankName,
    String? accountNumber,
  }) {
    return PayoutModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      vendorId: vendorId ?? this.vendorId,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
    );
  }

  @override
  List<Object?> get props => [id, amount, status, vendorId, createdAt];
}
