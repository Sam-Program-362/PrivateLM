class ChatSession {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? lastMessage;
  /// Optional prompt that overrides the app-wide prompt for this session.
  final String? systemPrompt;

  ChatSession({
    required this.id,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.lastMessage,
    this.systemPrompt,
  })  : title = title ?? 'New Chat',
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'lastMessage': lastMessage,
        'systemPrompt': systemPrompt,
      };

  factory ChatSession.fromMap(Map<dynamic, dynamic> map) => ChatSession(
        id: map['id'] ?? '',
        title: map['title'] ?? 'New Chat',
        createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(map['updatedAt'] ?? '') ?? DateTime.now(),
        lastMessage: map['lastMessage'],
        systemPrompt: map['systemPrompt'] is String
            ? map['systemPrompt'] as String
            : null,
      );

  ChatSession copyWith({
    String? title,
    DateTime? updatedAt,
    String? lastMessage,
    String? systemPrompt,
    bool clearSystemPrompt = false,
  }) =>
      ChatSession(
        id: id,
        title: title ?? this.title,
        createdAt: createdAt,
        updatedAt: updatedAt ?? DateTime.now(),
        lastMessage: lastMessage ?? this.lastMessage,
        systemPrompt:
            clearSystemPrompt ? null : systemPrompt ?? this.systemPrompt,
      );
}
