import 'package:equatable/equatable.dart';

class ConversationModel extends Equatable {
  final String id;
  final String participantName;
  final String? participantImage;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;
  /// 'direct' | 'support'
  final String type;

  const ConversationModel({
    required this.id,
    required this.participantName,
    this.participantImage,
    this.lastMessage,
    this.lastMessageAt,
    required this.unreadCount,
    this.type = 'direct',
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] as String,
      participantName: json['participantName'] as String,
      participantImage: json['participantImage'] as String?,
      lastMessage: json['lastMessage'] as String?,
      lastMessageAt: json['lastMessageAt'] != null
          ? DateTime.parse(json['lastMessageAt'] as String)
          : null,
      unreadCount: json['unreadCount'] as int? ?? 0,
      type: json['type'] as String? ?? 'direct',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'participantName': participantName,
        'participantImage': participantImage,
        'lastMessage': lastMessage,
        'lastMessageAt': lastMessageAt?.toIso8601String(),
        'unreadCount': unreadCount,
        'type': type,
      };

  ConversationModel copyWith({
    String? id,
    String? participantName,
    String? participantImage,
    String? lastMessage,
    DateTime? lastMessageAt,
    int? unreadCount,
    String? type,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      participantName: participantName ?? this.participantName,
      participantImage: participantImage ?? this.participantImage,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [id, participantName, lastMessage, unreadCount, type];
}
