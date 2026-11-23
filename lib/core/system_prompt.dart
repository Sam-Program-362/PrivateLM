import 'constants.dart';

/// Resolves the prompt sent for a conversation.
///
/// A non-empty session override replaces (rather than appends to) the global
/// prompt. Without an override, existing global and model-specific defaults
/// are preserved.
String resolveEffectiveSystemPrompt({
  required String modelName,
  required String globalPrompt,
  String? sessionPrompt,
}) {
  final sessionOverride = sessionPrompt?.trim();
  if (sessionOverride != null && sessionOverride.isNotEmpty) {
    return sessionOverride;
  }

  final prompt = globalPrompt.trim();
  final hasCustomPrompt =
      prompt.isNotEmpty && prompt != AppConstants.systemPrompt;
  if (hasCustomPrompt) return prompt;
  if (AppConstants.isUncensoredModelName(modelName)) {
    return AppConstants.uncensoredSystemPrompt;
  }
  return AppConstants.systemPrompt;
}
