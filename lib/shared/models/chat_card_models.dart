import 'package:equatable/equatable.dart';

/// Prisma Decimal fields serialize to STRINGS in JSON; tolerate num or string.
double numToDouble(dynamic v, [double fallback = 0]) {
  if (v == null) return fallback;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? fallback;
}

double? numToDoubleOrNull(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString());
}

class ChatLineItem extends Equatable {
  final String label;
  final double amount;
  const ChatLineItem({required this.label, required this.amount});

  factory ChatLineItem.fromJson(Map<String, dynamic> j) => ChatLineItem(
        label: j['label'] as String? ?? '',
        amount: numToDouble(j['amount']),
      );

  @override
  List<Object?> get props => [label, amount];
}

class ChatQuote extends Equatable {
  final String id;
  final String? quoteNumber;
  final double amount;
  final List<ChatLineItem> lineItems;

  /// Optional free-text payment terms the vendor writes (off-platform pay).
  final String? paymentTerms;
  final String? notes;
  final DateTime validUntil;
  final String status; // pending | accepted | rejected | expired | superseded
  final int version;
  final bool isActive;

  const ChatQuote({
    required this.id,
    this.quoteNumber,
    required this.amount,
    required this.lineItems,
    this.paymentTerms,
    this.notes,
    required this.validUntil,
    required this.status,
    required this.version,
    required this.isActive,
  });

  bool get isExpired => validUntil.isBefore(DateTime.now());

  factory ChatQuote.fromJson(Map<String, dynamic> j) => ChatQuote(
        id: j['id'] as String,
        quoteNumber: j['quoteNumber'] as String?,
        amount: numToDouble(j['amount']),
        lineItems: ((j['lineItems'] as List?) ?? const [])
            .map((e) => ChatLineItem.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        paymentTerms: j['paymentTerms'] is String
            ? j['paymentTerms'] as String?
            : null,
        notes: j['notes'] as String?,
        validUntil: DateTime.parse(j['validUntil'] as String),
        status: (j['status'] as String? ?? 'pending').toLowerCase(),
        version: (j['version'] as num?)?.toInt() ?? 1,
        isActive: j['isActive'] as bool? ?? true,
      );

  @override
  List<Object?> get props => [id, status, amount, version];
}

class ChatInvoice extends Equatable {
  final String id;
  final String invoiceNumber;
  final double total;
  final String status;
  final List<ChatLineItem> lineItems;

  /// Optional free-text payment terms shown on the invoice card (display-only).
  final String? paymentTerms;

  const ChatInvoice({
    required this.id,
    required this.invoiceNumber,
    required this.total,
    required this.status,
    required this.lineItems,
    this.paymentTerms,
  });

  factory ChatInvoice.fromJson(Map<String, dynamic> j) => ChatInvoice(
        id: j['id'] as String,
        invoiceNumber: j['invoiceNumber'] as String? ?? '',
        total: numToDouble(j['total']),
        status: (j['status'] as String? ?? 'sent').toLowerCase(),
        lineItems: ((j['lineItems'] as List?) ?? const [])
            .map((e) => ChatLineItem.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        paymentTerms: j['paymentTerms'] is String
            ? j['paymentTerms'] as String?
            : null,
      );

  @override
  List<Object?> get props => [id, status, total];
}

class ChatBookingRef extends Equatable {
  final String id;
  final String status;
  final String? fulfilmentType;
  final double? total;
  final String? listingTitle;

  const ChatBookingRef({
    required this.id,
    required this.status,
    this.fulfilmentType,
    this.total,
    this.listingTitle,
  });

  factory ChatBookingRef.fromJson(Map<String, dynamic> j) => ChatBookingRef(
        id: j['id'] as String,
        status: (j['status'] as String? ?? 'pending').toLowerCase(),
        fulfilmentType: (j['fulfilmentType'] as String?)?.toLowerCase(),
        total: numToDoubleOrNull(j['finalAmount']),
        listingTitle: (j['listing'] as Map?)?['title'] as String?,
      );

  @override
  List<Object?> get props => [id, status];
}

/// One assignee's slot on a group-chat to-do; each ticks their own task.
class ChatTodoAssignment extends Equatable {
  final String userId;
  final bool isDone;
  const ChatTodoAssignment({required this.userId, required this.isDone});

  factory ChatTodoAssignment.fromJson(Map<String, dynamic> j) =>
      ChatTodoAssignment(
        userId: j['userId'] as String,
        isDone: j['isDone'] as bool? ?? false,
      );

  @override
  List<Object?> get props => [userId, isDone];
}

/// A group-chat to-do. The client creates it; each assignee (including vendors)
/// ticks off their own task.
class ChatTodo extends Equatable {
  final String id;
  final String title;
  final String? description;
  final DateTime? dueAt;
  final List<ChatTodoAssignment> assignments;

  const ChatTodo({
    required this.id,
    required this.title,
    this.description,
    this.dueAt,
    required this.assignments,
  });

  int get doneCount => assignments.where((a) => a.isDone).length;
  int get totalCount => assignments.length;

  /// This user's own assignment, if any.
  ChatTodoAssignment? mine(String userId) {
    for (final a in assignments) {
      if (a.userId == userId) return a;
    }
    return null;
  }

  factory ChatTodo.fromJson(Map<String, dynamic> j) => ChatTodo(
        id: j['id'] as String,
        title: j['title'] as String? ?? '',
        description: j['description'] as String?,
        dueAt: j['dueAt'] != null
            ? DateTime.tryParse(j['dueAt'].toString())
            : null,
        assignments: ((j['assignments'] as List?) ?? const [])
            .map((e) =>
                ChatTodoAssignment.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
      );

  @override
  List<Object?> get props => [id, title, assignments];
}
