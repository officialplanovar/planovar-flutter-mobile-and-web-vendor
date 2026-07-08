import 'package:equatable/equatable.dart';

class ConversationModel extends Equatable {
  final String id;

  /// The client's user id (the other party in a vendor DM) — needed to send
  /// a quote via the chat-order flow.
  final String? clientId;
  final String participantName;
  final String? participantImage;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;

  /// 'direct' | 'support' | 'group'
  final String type;

  /// Conversation lifecycle: 'active' | 'payment_pending' | 'confirmed' | 'completed' | 'cancelled' | 'disputed'
  final String status;

  /// null | 'QUOTE_SENT' | 'QUOTE_ACCEPTED' | 'INVOICE_SENT'
  final String? quoteStatus;

  /// Shown as coloured status text in the conversation list (replaces lastMessage preview)
  final String? statusLabel;

  /// 'quote_requested' | 'quote_accepted' | null — drives text colour in list
  final String? statusType;

  /// If true the vendor's KYC is incomplete — show KYC banner instead of quote action card
  final bool isKycRequired;

  /// Client rating for the conversation header
  final double ratingAvg;

  /// Whether the participant is currently online
  final bool isOnline;

  /// Event name for the AppBar subtitle
  final String? eventName;

  /// Event date for the AppBar subtitle
  final DateTime? eventDate;

  // ── Group chat fields ─────────────────────────────────────────────────────────

  /// True when this is a group conversation
  final bool isGroup;

  /// Display name for the group (used instead of participantName when isGroup is true)
  final String? groupName;

  /// Number of participants in the group
  final int groupParticipantCount;

  /// Up to 3 avatar URLs rendered as an overlapping stack in the list tile
  final List<String> groupAvatars;

  const ConversationModel({
    required this.id,
    this.clientId,
    required this.participantName,
    this.participantImage,
    this.lastMessage,
    this.lastMessageAt,
    required this.unreadCount,
    this.type = 'direct',
    this.status = 'active',
    this.quoteStatus,
    this.statusLabel,
    this.statusType,
    this.isKycRequired = false,
    this.ratingAvg = 4.7,
    this.isOnline = false,
    this.eventName,
    this.eventDate,
    this.isGroup = false,
    this.groupName,
    this.groupParticipantCount = 0,
    this.groupAvatars = const [],
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
      status: json['status'] as String? ?? 'active',
      quoteStatus: json['quoteStatus'] as String?,
      statusLabel: json['statusLabel'] as String?,
      statusType: json['statusType'] as String?,
      isKycRequired: json['isKycRequired'] as bool? ?? false,
      ratingAvg: (json['ratingAvg'] as num?)?.toDouble() ?? 4.7,
      isOnline: json['isOnline'] as bool? ?? false,
      eventName: json['eventName'] as String?,
      eventDate: json['eventDate'] != null
          ? DateTime.parse(json['eventDate'] as String)
          : null,
      isGroup: json['isGroup'] as bool? ?? false,
      groupName: json['groupName'] as String?,
      groupParticipantCount: json['groupParticipantCount'] as int? ?? 0,
      groupAvatars: (json['groupAvatars'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
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
        'status': status,
        'quoteStatus': quoteStatus,
        'statusLabel': statusLabel,
        'statusType': statusType,
        'isKycRequired': isKycRequired,
        'ratingAvg': ratingAvg,
        'isOnline': isOnline,
        'eventName': eventName,
        'eventDate': eventDate?.toIso8601String(),
        'isGroup': isGroup,
        'groupName': groupName,
        'groupParticipantCount': groupParticipantCount,
        'groupAvatars': groupAvatars,
      };

  ConversationModel copyWith({
    String? id,
    String? participantName,
    String? participantImage,
    String? lastMessage,
    DateTime? lastMessageAt,
    int? unreadCount,
    String? type,
    String? status,
    String? quoteStatus,
    String? statusLabel,
    String? statusType,
    bool? isKycRequired,
    double? ratingAvg,
    bool? isOnline,
    String? eventName,
    DateTime? eventDate,
    bool? isGroup,
    String? groupName,
    int? groupParticipantCount,
    List<String>? groupAvatars,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      participantName: participantName ?? this.participantName,
      participantImage: participantImage ?? this.participantImage,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
      type: type ?? this.type,
      status: status ?? this.status,
      quoteStatus: quoteStatus ?? this.quoteStatus,
      statusLabel: statusLabel ?? this.statusLabel,
      statusType: statusType ?? this.statusType,
      isKycRequired: isKycRequired ?? this.isKycRequired,
      ratingAvg: ratingAvg ?? this.ratingAvg,
      isOnline: isOnline ?? this.isOnline,
      eventName: eventName ?? this.eventName,
      eventDate: eventDate ?? this.eventDate,
      isGroup: isGroup ?? this.isGroup,
      groupName: groupName ?? this.groupName,
      groupParticipantCount:
          groupParticipantCount ?? this.groupParticipantCount,
      groupAvatars: groupAvatars ?? this.groupAvatars,
    );
  }

  /// Display name: groupName when isGroup, else participantName
  String get displayName => isGroup ? (groupName ?? participantName) : participantName;

  @override
  List<Object?> get props => [
        id,
        participantName,
        lastMessage,
        unreadCount,
        type,
        status,
        quoteStatus,
        statusLabel,
        statusType,
        isKycRequired,
        ratingAvg,
        isOnline,
        eventName,
        eventDate,
        isGroup,
        groupName,
        groupParticipantCount,
      ];
}
