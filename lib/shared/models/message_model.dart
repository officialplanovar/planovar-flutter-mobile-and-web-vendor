import 'package:equatable/equatable.dart';
import 'chat_card_models.dart';

class MessageModel extends Equatable {
  final String id;
  final String conversationId;
  final String senderId;
  final String? content;
  /// Raw type (e.g. 'QUOTE'); use [typeLower] for switching on cards.
  final String type;
  final DateTime createdAt;
  final bool isMe;
  final Map<String, dynamic> metadata;

  // Structured-card payloads (only the one matching the type is set)
  final ChatQuote? quote;
  final ChatInvoice? invoice;
  final ChatBookingRef? booking;
  final ChatTodo? todo;

  String get typeLower => type.toLowerCase();

  const MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.content,
    required this.type,
    required this.createdAt,
    required this.isMe,
    this.metadata = const {},
    this.quote,
    this.invoice,
    this.booking,
    this.todo,
  });

  /// Parses an API/socket message payload, including structured cards.
  factory MessageModel.fromApi(Map<String, dynamic> m, String currentUserId) {
    return MessageModel(
      id: m['id'] as String,
      conversationId: m['conversationId'] as String,
      senderId: m['senderId'] as String,
      content: m['content'] as String?,
      type: m['type'] as String? ?? 'TEXT',
      createdAt: DateTime.parse(m['createdAt'] as String),
      isMe: m['senderId'] == currentUserId,
      metadata: m['metadata'] is Map
          ? Map<String, dynamic>.from(m['metadata'] as Map)
          : const {},
      quote: m['quote'] != null
          ? ChatQuote.fromJson(Map<String, dynamic>.from(m['quote'] as Map))
          : null,
      invoice: m['invoice'] != null
          ? ChatInvoice.fromJson(Map<String, dynamic>.from(m['invoice'] as Map))
          : null,
      booking: m['booking'] != null
          ? ChatBookingRef.fromJson(Map<String, dynamic>.from(m['booking'] as Map))
          : null,
      todo: m['todo'] != null
          ? ChatTodo.fromJson(Map<String, dynamic>.from(m['todo'] as Map))
          : null,
    );
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      content: json['content'] as String?,
      type: json['type'] as String? ?? 'TEXT',
      createdAt: DateTime.parse(json['createdAt'] as String),
      isMe: json['isMe'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'conversationId': conversationId,
        'senderId': senderId,
        'content': content,
        'type': type,
        'createdAt': createdAt.toIso8601String(),
        'isMe': isMe,
      };

  MessageModel copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? content,
    String? type,
    DateTime? createdAt,
    bool? isMe,
  }) {
    return MessageModel(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isMe: isMe ?? this.isMe,
    );
  }

  @override
  List<Object?> get props => [id, conversationId, senderId, type, createdAt, isMe];
}
