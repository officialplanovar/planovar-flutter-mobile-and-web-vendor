import 'package:equatable/equatable.dart';

class SubscriptionPlanModel extends Equatable {
  final String id;
  final String tier; // BASIC | PREMIUM | GOLD
  final String name;
  final double priceMonthly;
  final double priceYearly;
  final String currency; // e.g. USD
  final int? listingLimit; // null = unlimited
  final List<String> features;

  const SubscriptionPlanModel({
    required this.id,
    required this.tier,
    required this.name,
    required this.priceMonthly,
    required this.priceYearly,
    required this.currency,
    required this.listingLimit,
    required this.features,
  });

  bool get isFree => priceMonthly == 0;

  String get symbol {
    switch (currency.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'NGN':
        return '₦';
      default:
        return '$currency ';
    }
  }

  /// e.g. "Free", "₦32,000/month" or "$20.00/month"
  String priceLabel({bool yearly = false}) {
    if (isFree) return 'Free';
    return '${amountLabel(yearly: yearly)}/${yearly ? 'year' : 'month'}';
  }

  /// Just the amount, no period — e.g. "Free", "₦32,000", "$19.99".
  String amountLabel({bool yearly = false}) {
    if (isFree) return 'Free';
    final amount = yearly ? priceYearly : priceMonthly;
    final isNgn = currency.toUpperCase() == 'NGN';
    final str = isNgn ? _thousands(amount) : amount.toStringAsFixed(2);
    return '$symbol$str';
  }

  /// The period suffix shown next to the amount — "/ month" or "/ year".
  String periodLabel({bool yearly = false}) => yearly ? '/ year' : '/ month';

  static String _thousands(double n) {
    final s = n.toStringAsFixed(0);
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      id: json['id'] as String,
      tier: json['tier'] as String? ?? 'BASIC',
      name: json['name'] as String? ?? '',
      priceMonthly: _num(json['priceMonthly']),
      priceYearly: _num(json['priceYearly']),
      currency: json['currency'] as String? ?? 'USD',
      listingLimit: json['listingLimit'] == null
          ? null
          : (json['listingLimit'] as num).toInt(),
      features: List<String>.from(json['features'] as List? ?? const []),
    );
  }

  // Prisma serializes Decimal as a string ("19.99"); accept string or num.
  static double _num(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0;
  }

  @override
  List<Object?> get props =>
      [id, tier, name, priceMonthly, priceYearly, currency, listingLimit];
}
