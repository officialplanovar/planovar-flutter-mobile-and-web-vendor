import 'package:equatable/equatable.dart';

class QuoteLineItem extends Equatable {
  final String id;
  final String label;
  final double amount;

  const QuoteLineItem({
    required this.id,
    required this.label,
    required this.amount,
  });

  factory QuoteLineItem.fromJson(Map<String, dynamic> json) {
    return QuoteLineItem(
      id: json['id'] as String? ?? '',
      label: json['label'] as String,
      amount: (json['amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'amount': amount,
      };

  QuoteLineItem copyWith({
    String? id,
    String? label,
    double? amount,
  }) {
    return QuoteLineItem(
      id: id ?? this.id,
      label: label ?? this.label,
      amount: amount ?? this.amount,
    );
  }

  @override
  List<Object?> get props => [id, label, amount];
}
