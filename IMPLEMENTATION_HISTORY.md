# Implementation History

## 2026-11-23 — Android per-session system prompts

### Request

Allow an Android chat session to have its own system prompt. When that prompt is
set, it replaces the app-wide prompt for that session only. Other sessions must
continue to use the app-wide prompt (or the model-appropriate built-in default).
The existing Settings system prompt remains available.

### Implementation

- Added an optional `systemPrompt` field to `ChatSession` and included it in
  Hive session-map serialization. Existing stored sessions without the field
  load with `systemPrompt == null`, so no Hive migration is required.
- Added `ChatController.setCurrentSessionSystemPrompt` to trim, persist, clear,
  and publish a prompt change on the current session. Ordinary title/message
  updates preserve the prompt through `ChatSession.copyWith`.
- Added the pure resolver in `lib/core/system_prompt.dart`. A non-empty
  session prompt takes precedence over the global Settings prompt. With no
  session override, existing behavior is retained, including custom global
  prompts and model-specific defaults for uncensored local models. The selected
  prompt is sent to both local inference and cloud chat requests.
- Added an Android-only system-prompt action in the chat app bar. It is
  available for empty as well as populated sessions. The editor explains that
  the prompt replaces the Settings prompt only for the current session; “Use
  global prompt” removes the override.
- Gated prompt selection in the chat controller to Android. iOS and web continue
  to use the existing app-wide prompt behavior; their UI is unchanged.
- Added model tests for per-session persistence/isolation, legacy records, and
  clearing an override.

### Files

- `lib/models/chat_session.dart`
- `lib/controllers/chat_controller.dart`
- `lib/controllers/settings_controller.dart`
- `lib/core/system_prompt.dart`
- `lib/views/chat_view.dart`
- `test/chat_session_test.dart`
- `test/system_prompt_test.dart`

### Verification

Added automated coverage for prompt precedence, fallback behavior, prompt
serialization, legacy sessions, and clearing an override. Recommended Android
smoke test:

1. Set a custom app-wide prompt in Settings.
2. Open a chat, set a different session prompt, then send a message; the session
   prompt should take precedence.
3. Create/open another chat; it should still use the app-wide prompt.
4. Reopen the first chat to confirm its prompt persisted, then choose “Use global
   prompt” and confirm it falls back to Settings.

`git diff --check` passed during implementation. Flutter analysis, automated
tests, and an Android build could not be run because the Arena coding
environment does not have Flutter/Dart installed.
