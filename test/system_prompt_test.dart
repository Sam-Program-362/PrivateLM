import 'package:flutter_test/flutter_test.dart';
import 'package:privatelm/core/constants.dart';
import 'package:privatelm/core/system_prompt.dart';

void main() {
  group('resolveEffectiveSystemPrompt', () {
    test('session prompt replaces a custom global prompt', () {
      expect(
        resolveEffectiveSystemPrompt(
          modelName: 'Qwen 3',
          globalPrompt: 'The app-wide instructions',
          sessionPrompt: 'Only answer in haiku.',
        ),
        'Only answer in haiku.',
      );
    });

    test('blank session prompt falls back to the app-wide prompt', () {
      expect(
        resolveEffectiveSystemPrompt(
          modelName: 'Qwen 3',
          globalPrompt: 'The app-wide instructions',
          sessionPrompt: '  ',
        ),
        'The app-wide instructions',
      );
    });

    test('preserves model defaults when there is no custom global prompt', () {
      expect(
        resolveEffectiveSystemPrompt(
          modelName: 'ordinary model',
          globalPrompt: AppConstants.systemPrompt,
        ),
        AppConstants.systemPrompt,
      );
      expect(
        resolveEffectiveSystemPrompt(
          modelName: 'dolphin model',
          globalPrompt: AppConstants.systemPrompt,
        ),
        AppConstants.uncensoredSystemPrompt,
      );
    });
  });
}
