import 'package:flutter_test/flutter_test.dart';
import 'package:privatelm/models/chat_session.dart';

void main() {
  group('ChatSession system prompt', () {
    test('round-trips a per-session prompt without affecting other sessions', () {
      final configured = ChatSession(
        id: 'session-with-prompt',
        systemPrompt: 'Answer only in haiku.',
      );
      final ordinary = ChatSession(id: 'ordinary-session');

      final restoredConfigured = ChatSession.fromMap(configured.toMap());
      final restoredOrdinary = ChatSession.fromMap(ordinary.toMap());

      expect(restoredConfigured.systemPrompt, 'Answer only in haiku.');
      expect(restoredOrdinary.systemPrompt, isNull);
    });

    test('loads legacy session records without a system prompt', () {
      final session = ChatSession.fromMap({
        'id': 'legacy-session',
        'title': 'Old chat',
      });

      expect(session.systemPrompt, isNull);
    });

    test('preserves the prompt through normal session updates and can clear it',
        () {
      final session = ChatSession(
        id: 'session',
        systemPrompt: 'Be concise.',
      );

      expect(session.copyWith(title: 'Renamed').systemPrompt, 'Be concise.');
      expect(session.copyWith(clearSystemPrompt: true).systemPrompt, isNull);
    });
  });
}
