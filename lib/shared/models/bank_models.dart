class BankOption {
  final String name;
  final String code;
  const BankOption({required this.name, required this.code});

  factory BankOption.fromJson(Map<String, dynamic> j) => BankOption(
        name: j['name'] as String? ?? '',
        code: j['code'] as String? ?? '',
      );
}

/// The vendor's saved payout/receiving account.
class BankAccount {
  final String? bankCode;
  final String? bankName;
  final String? accountNumber;
  final String? accountName;

  /// True once the Paystack subaccount exists (ready to receive direct pay).
  final bool active;

  const BankAccount({
    this.bankCode,
    this.bankName,
    this.accountNumber,
    this.accountName,
    this.active = false,
  });

  String get maskedNumber {
    final n = accountNumber ?? '';
    if (n.length < 4) return n;
    return '${n.substring(0, 4)}${'*' * (n.length - 4)}';
  }

  factory BankAccount.fromJson(Map<String, dynamic> j) => BankAccount(
        bankCode: j['bankCode'] as String?,
        bankName: j['bankName'] as String?,
        accountNumber: j['accountNumber'] as String?,
        accountName: j['accountName'] as String?,
        active: j['active'] as bool? ?? false,
      );
}
