import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/services/bank_service.dart';
import '../../core/theme/app_colors.dart';
import '../models/bank_models.dart';
import 'app_button.dart';

/// Bottom sheet to add/replace the vendor's receiving account. Verifies the
/// account via Paystack and, on save, creates the 0%-cut subaccount.
void showAddBankAccountSheet(
  BuildContext context, {
  void Function(BankAccount)? onSaved,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => AddBankAccountSheet(onSaved: onSaved),
  );
}

class AddBankAccountSheet extends StatefulWidget {
  final void Function(BankAccount)? onSaved;
  const AddBankAccountSheet({super.key, this.onSaved});

  @override
  State<AddBankAccountSheet> createState() => _AddBankAccountSheetState();
}

class _AddBankAccountSheetState extends State<AddBankAccountSheet> {
  final _service = BankService();
  final _accountCtrl = TextEditingController();

  List<BankOption> _banks = [];
  BankOption? _bank;
  String? _accountName;
  String? _error;
  String _lastResolvedKey = '';
  bool _loadingBanks = true;
  bool _resolving = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadBanks();
    _accountCtrl.addListener(_maybeResolve);
  }

  @override
  void dispose() {
    _accountCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadBanks() async {
    try {
      final banks = await _service.listBanks();
      if (mounted) setState(() { _banks = banks; _loadingBanks = false; });
    } catch (_) {
      if (mounted) setState(() => _loadingBanks = false);
    }
  }

  void _maybeResolve() {
    final num = _accountCtrl.text.trim();
    if (_bank == null || num.length != 10) {
      if (_accountName != null || _error != null) {
        setState(() { _accountName = null; _error = null; });
      }
      return;
    }
    final key = '${_bank!.code}:$num';
    if (key == _lastResolvedKey) return;
    _lastResolvedKey = key;
    _resolve(_bank!.code, num);
  }

  Future<void> _resolve(String bankCode, String number) async {
    setState(() { _resolving = true; _accountName = null; _error = null; });
    try {
      final name = await _service.resolve(bankCode, number);
      if (!mounted) return;
      setState(() { _accountName = name; _resolving = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _resolving = false;
      });
    }
  }

  Future<void> _save() async {
    if (_bank == null || _accountName == null) return;
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      final saved = await _service.save(
        bankCode: _bank!.code,
        bankName: _bank!.name,
        accountNumber: _accountCtrl.text.trim(),
        accountName: _accountName!,
      );
      navigator.pop();
      widget.onSaved?.call(saved);
      messenger.showSnackBar(
        const SnackBar(content: Text('Bank account added — you can now receive payments 🎉')),
      );
    } catch (e) {
      if (mounted) setState(() => _saving = false);
      messenger.showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  Future<void> _pickBank() async {
    final picked = await showModalBottomSheet<BankOption>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.c.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => _BankPicker(banks: _banks),
    );
    if (picked != null) {
      setState(() { _bank = picked; _lastResolvedKey = ''; });
      _maybeResolve();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Container(
        color: context.c.surface,
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40, height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                        color: const Color(0xFFD1D5DB),
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                Text('Add bank account',
                    style: GoogleFonts.urbanist(
                        fontSize: 18, fontWeight: FontWeight.w800, color: context.c.textPrimary)),
                const SizedBox(height: 2),
                Text('Clients pay you directly to this account.',
                    style: GoogleFonts.urbanist(fontSize: 13, color: context.c.textSecondary)),
                const SizedBox(height: 16),
                // Bank picker
                GestureDetector(
                  onTap: _loadingBanks ? null : _pickBank,
                  child: Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: context.c.surfaceElevated,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(children: [
                      Expanded(
                        child: Text(
                          _loadingBanks
                              ? 'Loading banks…'
                              : (_bank?.name ?? 'Select bank'),
                          style: GoogleFonts.urbanist(
                              fontSize: 14,
                              color: _bank == null ? context.c.textHint : context.c.textPrimary),
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down_rounded, color: context.c.textSecondary),
                    ]),
                  ),
                ),
                const SizedBox(height: 12),
                // Account number
                TextField(
                  controller: _accountCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  style: GoogleFonts.urbanist(color: context.c.textPrimary),
                  decoration: InputDecoration(
                    hintText: '10-digit account number',
                    hintStyle: GoogleFonts.urbanist(color: context.c.textHint),
                    filled: true,
                    fillColor: context.c.surfaceElevated,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 10),
                // Resolved name / status
                if (_resolving)
                  Row(children: [
                    const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)),
                    const SizedBox(width: 8),
                    Text('Verifying account…',
                        style: GoogleFonts.urbanist(fontSize: 13, color: context.c.textSecondary)),
                  ])
                else if (_accountName != null)
                  Row(children: [
                    const Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF047857)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(_accountName!,
                          style: GoogleFonts.urbanist(
                              fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF047857))),
                    ),
                  ])
                else if (_error != null)
                  Text(_error!,
                      style: GoogleFonts.urbanist(fontSize: 12.5, color: AppColors.error)),
                const SizedBox(height: 18),
                AppButton.primary(
                  _saving ? 'Saving…' : 'Save account',
                  loading: _saving,
                  onTap: (_accountName != null && !_saving) ? _save : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BankPicker extends StatefulWidget {
  final List<BankOption> banks;
  const _BankPicker({required this.banks});

  @override
  State<_BankPicker> createState() => _BankPickerState();
}

class _BankPickerState extends State<_BankPicker> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.banks
        .where((b) => b.name.toLowerCase().contains(_q.toLowerCase()))
        .toList();
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                  color: const Color(0xFFD1D5DB), borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                autofocus: true,
                onChanged: (v) => setState(() => _q = v),
                style: GoogleFonts.urbanist(color: context.c.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Search bank',
                  hintStyle: GoogleFonts.urbanist(color: context.c.textHint),
                  prefixIcon: Icon(Icons.search_rounded, color: context.c.textHint),
                  filled: true,
                  fillColor: context.c.surfaceElevated,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, i) => ListTile(
                  title: Text(filtered[i].name,
                      style: GoogleFonts.urbanist(fontSize: 14, color: context.c.textPrimary)),
                  onTap: () => Navigator.pop(context, filtered[i]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
