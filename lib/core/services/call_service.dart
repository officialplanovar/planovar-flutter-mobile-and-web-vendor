import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';
import '../api/api_client.dart';
import '../api/api_utils.dart';

/// LiveKit voice calls. Fetches a Gold-gated room token from the API and
/// connects to the room. Throws with the server message if not Gold (403) or
/// voice isn't configured (503).
class CallService {
  final ApiClient _api;
  CallService({ApiClient? api}) : _api = api ?? ApiClient();

  Future<Room> connect(String conversationId) async {
    await Permission.microphone.request();

    final res = await _api.dio.post(
      '/calls/token',
      data: {'conversationId': conversationId},
    );
    ensureOk(res);
    final data = Map<String, dynamic>.from(res.data as Map);

    final room = Room();
    await room.connect(data['url'] as String, data['token'] as String);
    await room.localParticipant?.setMicrophoneEnabled(true);
    return room;
  }
}
