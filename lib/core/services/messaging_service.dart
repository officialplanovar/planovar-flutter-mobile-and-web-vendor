import '../api/api_client.dart';
import '../api/api_utils.dart';
import '../../shared/models/conversation_model.dart';
import '../../shared/models/message_model.dart';

/// REST side of messaging for the vendor app. The "other party" is the CLIENT.
/// Live send/receive is handled by [ChatSocket].
class MessagingService {
  final ApiClient _api;
  MessagingService({ApiClient? api}) : _api = api ?? ApiClient();

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
        .map((e) => _mapMessage(Map<String, dynamic>.from(e), currentUserId))
        .toList();
    return list.reversed.toList();
  }

  /// Maps a live socket 'message' payload (saved message) → MessageModel.
  static MessageModel msgFromSocket(
    Map<String, dynamic> m,
    String currentUserId,
  ) =>
      _mapMessage(m, currentUserId);

  static MessageModel _mapMessage(Map<String, dynamic> m, String currentUserId) =>
      MessageModel(
        id: m['id'] as String,
        conversationId: m['conversationId'] as String,
        senderId: m['senderId'] as String,
        content: m['content'] as String?,
        type: m['type'] as String? ?? 'TEXT',
        createdAt: DateTime.parse(m['createdAt'] as String),
        isMe: m['senderId'] == currentUserId,
      );

  ConversationModel _mapConversation(Map<String, dynamic> c) {
    final clientId = c['clientId'] as String?;
    // For the vendor app, the other party is the client.
    Map<String, dynamic>? clientUser;
    for (final p in (c['participants'] as List? ?? const [])) {
      final u = (p as Map)['user'] as Map?;
      if (u != null && u['id'] == clientId) {
        clientUser = Map<String, dynamic>.from(u);
        break;
      }
    }
    final lastMsg = c['lastMessage'];
    return ConversationModel(
      id: c['id'] as String,
      participantName: (clientUser?['name'] as String?) ?? 'Client',
      participantImage: clientUser?['image'] as String?,
      lastMessage: lastMsg is Map ? lastMsg['content'] as String? : null,
      lastMessageAt: c['lastMessageAt'] != null
          ? DateTime.tryParse(c['lastMessageAt'].toString())
          : null,
      unreadCount: (c['unreadCount'] as num?)?.toInt() ?? 0,
      type: (c['type'] as String?)?.toLowerCase() == 'group' ? 'group' : 'direct',
      status: (c['status'] as String?) ?? 'active',
    );
  }
}
