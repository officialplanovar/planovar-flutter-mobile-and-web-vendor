import 'package:equatable/equatable.dart';

class MessageModel extends Equatable {
  final String id;
  final String conversationId;
  final String senderId;
  final String? content;
  /// 'TEXT' | 'IMAGE' | 'VOICE'
  final String type;
  final DateTime createdAt;
  final bool isMe;

  const MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.content,
    required this.type,
    required this.createdAt,
    required this.isMe,
  });

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
