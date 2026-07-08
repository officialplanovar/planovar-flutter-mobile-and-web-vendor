import '../api/api_client.dart';
import '../api/api_utils.dart';
import '../../shared/models/conversation_model.dart';
import '../../shared/models/message_model.dart';

/// REST side of messaging for the vendor app. The "other party" is the CLIENT.
/// Live send/receive is handled by [ChatSocket].
class MessagingService {
  final ApiClient _api;
  MessagingService({ApiClient? api}) : _api = api ?? ApiClient();

  /// The current vendor-user's real id (from /users/me, bearer-auth). Reliable
  /// source for "is this my message" — the AuthBloc user can be empty.
  Future<String?> myId() async {
    try {
      final res = await _api.dio.get('/users/me');
      return (res.data as Map?)?['id'] as String?;
    } catch (_) {
      return null;
    }
  }

  Future<List<ConversationModel>> getConversations() async {
    final res = await _api.dio.get('/conversations');
    ensureOk(res);
    return (res.data as List? ?? const [])
        .map((e) => _mapConversation(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// History oldest-first (API returns newest-first); `isMe` computed from currentUserId.
  Future<List<MessageModel>> getMessages(
    String conversationId,
    String currentUserId,
  ) async {
    final res = await _api.dio.get('/conversations/$conversationId/messages');
    ensureOk(res);
    final list = (res.data as List? ?? const [])
        .map((e) => MessageModel.fromApi(Map<String, dynamic>.from(e), currentUserId))
        .toList();
    return list.reversed.toList();
  }

  /// Maps a live socket 'message' payload (saved message) → MessageModel.
  static MessageModel msgFromSocket(
    Map<String, dynamic> m,
    String currentUserId,
  ) =>
      MessageModel.fromApi(m, currentUserId);

  ConversationModel _mapConversation(Map<String, dynamic> c) {
    final clientId = c['clientId'] as String?;
    final isGroup = (c['type'] as String?)?.toLowerCase() == 'group';
    final participants = (c['participants'] as List? ?? const [])
        .map((p) => (p as Map)['user'])
        .whereType<Map>()
        .map((u) => Map<String, dynamic>.from(u))
        .toList();
    // For the vendor app, the other party (in a 1:1) is the client.
    Map<String, dynamic>? clientUser;
    for (final u in participants) {
      if (u['id'] == clientId) {
        clientUser = u;
        break;
      }
    }
    final lastMsg = c['lastMessage'];
    return ConversationModel(
      id: c['id'] as String,
      clientId: clientId,
      participantName: (clientUser?['name'] as String?) ?? 'Client',
      participantImage: clientUser?['image'] as String?,
      lastMessage: lastMsg is Map ? lastMsg['content'] as String? : null,
      lastMessageAt: c['lastMessageAt'] != null
          ? DateTime.tryParse(c['lastMessageAt'].toString())
          : null,
      unreadCount: (c['unreadCount'] as num?)?.toInt() ?? 0,
      type: isGroup ? 'group' : 'direct',
      status: (c['status'] as String?) ?? 'active',
      isGroup: isGroup,
      groupName: c['groupName'] as String?,
      groupParticipantCount: participants.length,
      groupAvatars: participants
          .map((u) => u['image'] as String?)
          .whereType<String>()
          .take(3)
          .toList(),
    );
  }
}
