import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_model.freezed.dart';
part 'chat_model.g.dart';

/// Message role enum
enum MessageRole {
  user,
  assistant,
  system,
}

/// Message type enum
enum MessageType {
  text,
  question,
  analysis,
  recommendation,
  warning,
  information,
  followUp,
}

/// Chat session model
@freezed
class ChatSession with _$ChatSession {
  const factory ChatSession({
    /// Unique session ID
    String? id,
    
    /// User ID
    required String userId,
    
    /// Session title
    String? title,
    
    /// Session type (general, migraine_analysis, etc.)
    String? type,
    
    /// List of messages in the session
    @Default([]) List<ChatMessage> messages,
    
    /// Current context for the session
    Map<String, dynamic>? context,
    
    /// Session metadata
    Map<String, dynamic>? metadata,
    
    /// Session status (active, archived, deleted)
    @Default('active') String status,
    
    /// Creation timestamp
    required DateTime createdAt,
    
    /// Last message timestamp
    DateTime? lastMessageAt,
    
    /// Last update timestamp
    DateTime? updatedAt,
    
    /// Whether session is synced
    @Default(false) bool isSynced,
    
    /// Whether session is pinned
    @Default(false) bool isPinned,
    
    /// Session rating (0-5)
    int? rating,
    
    /// User feedback
    String? feedback,
  }) = _ChatSession;

  factory ChatSession.fromJson(Map<String, dynamic> json) =>
      _$ChatSessionFromJson(json);
}

/// Chat message model
@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    /// Unique message ID
    String? id,
    
    /// Session ID
    String? sessionId,
    
    /// Message role
    required MessageRole role,
    
    /// Message type
    MessageType? type,
    
    /// Message content
    required String content,
    
    /// Message data (structured data)
    Map<String, dynamic>? data,
    
    /// Message metadata
    Map<String, dynamic>? metadata,
    
    /// References to migraines, daily logs, etc.
    @Default([]) List<MessageReference> references,
    
    /// Message timestamp
    required DateTime timestamp,
    
    /// Whether message has been read
    @Default(false) bool isRead,
    
    /// Whether message has been edited
    @Default(false) bool isEdited,
    
    /// Edit timestamp
    DateTime? editedAt,
    
    /// Whether message is from AI
    @Default(false) bool isFromAI,
    
    /// AI model used
    String? model,
    
    /// AI response time in milliseconds
    int? responseTimeMs,
    
    /// Whether message was streamed
    @Default(false) bool wasStreamed,
    
    /// Message status (sent, delivered, read, failed)
    @Default('sent') String status,
    
    /// Error message (if status is failed)
    String? error,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}

/// Message reference
@freezed
class MessageReference with _$MessageReference {
  const factory MessageReference({
    /// Reference type (migraine, daily_log, insight, etc.)
    required String type,
    
    /// Reference ID
    required String id,
    
    /// Reference display text
    String? displayText,
    
    /// Reference data
    Map<String, dynamic>? data,
  }) = _MessageReference;

  factory MessageReference.fromJson(Map<String, dynamic> json) =>
      _$MessageReferenceFromJson(json);
}

/// AI context model
@freezed
class AIContext with _$AIContext {
  const factory AIContext({
    /// User ID
    required String userId,
    
    /// User information for context
    Map<String, dynamic>? userInfo,
    
    /// Recent migraines
    @Default([]) List<Map<String, dynamic>> recentMigraines,
    
    /// Recent daily logs
    @Default([]) List<Map<String, dynamic>> recentDailyLogs,
    
    /// Current weather
    Map<String, dynamic>? currentWeather,
    
    /// User's typical patterns
    Map<String, dynamic>? typicalPatterns,
    
    /// User's identified triggers
    @Default([]) List<String> identifiedTriggers,
    
    /// User's current treatments
    @Default([]) List<String> currentTreatments,
    
    /// Current date and time
    required DateTime currentDateTime,
    
    /// User's timezone
    String? timezone,
    
    /// User's preferences
    Map<String, dynamic>? preferences,
    
    /// Conversation history (for context)
    @Default([]) List<Map<String, dynamic>> conversationHistory,
    
    /// Available tools for AI
    @Default([]) List<String> availableTools,
    
    /// Constraints for AI responses
    @Default({}) Map<String, dynamic> constraints,
  }) = _AIContext;

  factory AIContext.fromJson(Map<String, dynamic> json) =>
      _$AIContextFromJson(json);
}

/// AI response constraints
@freezed
class AIConstraints with _$AIConstraints {
  const factory AIConstraints({
    /// Maximum response length in tokens
    @Default(1000) int maxTokens,
    
    /// Maximum response length in characters
    @Default(4000) int maxCharacters,
    
    /// Temperature (0-1)
    @Default(0.7) double temperature,
    
    /// Whether to use medical disclaimer
    @Default(true) bool useMedicalDisclaimer,
    
    /// Whether to cite sources
    @Default(true) bool citeSources,
    
    /// Whether to show confidence levels
    @Default(true) bool showConfidenceLevels,
    
    /// Whether to use French language
    @Default(true) bool useFrench,
    
    /// Allowed response types
    @Default([]) List<String> allowedResponseTypes,
    
    /// Forbidden content
    @Default([]) List<String> forbiddenContent,
    
    /// Required phrases
    @Default([]) List<String> requiredPhrases,
  }) = _AIConstraints;

  factory AIConstraints.fromJson(Map<String, dynamic> json) =>
      _$AIConstraintsFromJson(json);
}

/// AI tool call model
@freezed
class AIToolCall with _$AIToolCall {
  const factory AIToolCall({
    /// Tool name
    required String name,
    
    /// Tool arguments
    @Default({}) Map<String, dynamic> arguments,
    
    /// Tool call ID
    String? id,
    
    /// Tool result
    Map<String, dynamic>? result,
    
    /// Tool status (called, completed, failed)
    String? status,
    
    /// Error message
    String? error,
  }) = _AIToolCall;

  factory AIToolCall.fromJson(Map<String, dynamic> json) =>
      _$AIToolCallFromJson(json);
}

/// AI tool result model
@freezed
class AIToolResult with _$AIToolResult {
  const factory AIToolResult({
    /// Tool call ID
    required String toolCallId,
    
    /// Tool name
    required String toolName,
    
    /// Tool result data
    Map<String, dynamic>? data,
    
    /// Tool result content
    String? content,
    
    /// Tool status
    required String status,
    
    /// Error message
    String? error,
    
    /// Timestamp
    required DateTime timestamp,
  }) = _AIToolResult;

  factory AIToolResult.fromJson(Map<String, dynamic> json) =>
      _$AIToolResultFromJson(json);
}

/// Chat suggestion model
@freezed
class ChatSuggestion with _$ChatSuggestion {
  const factory ChatSuggestion({
    /// Suggestion ID
    String? id,
    
    /// Suggestion text
    required String text,
    
    /// Suggestion type
    String? type,
    
    /// Suggestion category
    String? category,
    
    /// Suggestion priority (0-10)
    @Default(5) int priority,
    
    /// Whether suggestion has been used
    @Default(false) bool isUsed,
    
    /// Usage timestamp
    DateTime? usedAt,
    
    /// Creation timestamp
    required DateTime createdAt,
  }) = _ChatSuggestion;

  factory ChatSuggestion.fromJson(Map<String, dynamic> json) =>
      _$ChatSuggestionFromJson(json);
}

/// Conversation summary model
@freezed
class ConversationSummary with _$ConversationSummary {
  const factory ConversationSummary({
    /// Session ID
    required String sessionId,
    
    /// Summary text
    required String summary,
    
    /// Key points
    @Default([]) List<String> keyPoints,
    
    /// Action items
    @Default([]) List<String> actionItems,
    
    /// Follow-up questions
    @Default([]) List<String> followUpQuestions,
    
    /// Topics discussed
    @Default([]) List<String> topics,
    
    /// Creation timestamp
    required DateTime createdAt,
  }) = _ConversationSummary;

  factory ConversationSummary.fromJson(Map<String, dynamic> json) =>
      _$ConversationSummaryFromJson(json);
}

/// AI response model
@freezed
class AIResponse with _$AIResponse {
  const factory AIResponse({
    /// Response ID
    String? id,
    
    /// Response content
    required String content,
    
    /// Response type
    MessageType? type,
    
    /// Response data
    Map<String, dynamic>? data,
    
    /// Tool calls made during response
    @Default([]) List<AIToolCall> toolCalls,
    
    /// Tool results
    @Default([]) List<AIToolResult> toolResults,
    
    /// References used
    @Default([]) List<MessageReference> references,
    
    /// Confidence level
    double? confidence,
    
    /// Response timestamp
    required DateTime timestamp,
    
    /// Processing time in milliseconds
    int? processingTimeMs,
    
    /// Model used
    String? model,
    
    /// Tokens used
    int? tokensUsed,
    
    /// Whether response was cached
    @Default(false) bool wasCached,
  }) = _AIResponse;

  factory AIResponse.fromJson(Map<String, dynamic> json) =>
      _$AIResponseFromJson(json);
}

// Extension methods for ChatSession
extension ChatSessionExtensions on ChatSession {
  /// Get last message
  ChatMessage? get lastMessage {
    if (messages.isEmpty) return null;
    return messages.last;
  }

  /// Get first message
  ChatMessage? get firstMessage {
    if (messages.isEmpty) return null;
    return messages.first;
  }

  /// Get unread message count
  int get unreadCount {
    return messages.where((m) => !m.isRead && m.role == MessageRole.assistant).length;
  }

  /// Get message count
  int get messageCount => messages.length;

  /// Check if session has AI messages
  bool get hasAIMessages {
    return messages.any((m) => m.role == MessageRole.assistant);
  }

  /// Get session title from first user message
  String get effectiveTitle {
    if (title != null && title!.isNotEmpty) return title!;
    
    final firstUserMessage = messages.firstWhere(
      (m) => m.role == MessageRole.user,
      orElse: () => null,
    );
    
    if (firstUserMessage != null) {
      final content = firstUserMessage.content;
      if (content.length > 50) {
        return '${content.substring(0, 47)}...';
      }
      return content;
    }
    
    return 'Nouvelle conversation';
  }

  /// Convert to map for storage
  Map<String, dynamic> toStorageMap() {
    final json = toJson();
    json.remove('id'); // Don't store ID
    return json;
  }
}

extension ChatMessageExtensions on ChatMessage {
  /// Get message type display name
  String get typeDisplayName {
    switch (type) {
      case MessageType.text:
        return 'Texte';
      case MessageType.question:
        return 'Question';
      case MessageType.analysis:
        return 'Analyse';
      case MessageType.recommendation:
        return 'Recommandation';
      case MessageType.warning:
        return 'Avertissement';
      case MessageType.information:
        return 'Information';
      case MessageType.followUp:
        return 'Suivi';
      default:
        return 'Message';
    }
  }

  /// Check if message is from user
  bool get isFromUser => role == MessageRole.user;

  /// Check if message is from assistant
  bool get isFromAssistant => role == MessageRole.assistant;

  /// Check if message is from system
  bool get isFromSystem => role == MessageRole.system;

  /// Get role display name
  String get roleDisplayName {
    switch (role) {
      case MessageRole.user:
        return 'Vous';
      case MessageRole.assistant:
        return 'Assistant';
      case MessageRole.system:
        return 'Système';
    }
  }

  /// Convert to map for storage
  Map<String, dynamic> toStorageMap() {
    final json = toJson();
    json.remove('id'); // Don't store ID
    return json;
  }
}

extension MessageRoleExtensions on MessageRole {
  /// Get role display name
  String get displayName {
    switch (this) {
      case MessageRole.user:
        return 'Vous';
      case MessageRole.assistant:
        return 'Assistant';
      case MessageRole.system:
        return 'Système';
    }
  }
}

extension MessageTypeExtensions on MessageType {
  /// Get message type display name
  String get displayName {
    switch (this) {
      case MessageType.text:
        return 'Texte';
      case MessageType.question:
        return 'Question';
      case MessageType.analysis:
        return 'Analyse';
      case MessageType.recommendation:
        return 'Recommandation';
      case MessageType.warning:
        return 'Avertissement';
      case MessageType.information:
        return 'Information';
      case MessageType.followUp:
        return 'Suivi';
    }
  }
}

// Helper methods for creating chat models
extension ChatSessionCreator on ChatSession {
  /// Create a new chat session
  static ChatSession createNew({
    required String userId,
    String? title,
    String? type,
    Map<String, dynamic>? context,
  }) {
    return ChatSession(
      userId: userId,
      title: title,
      type: type,
      context: context,
      createdAt: DateTime.now(),
      lastMessageAt: DateTime.now(),
      isSynced: false,
    );
  }

  /// Create a new chat session with first message
  static ChatSession createWithFirstMessage({
    required String userId,
    required String messageContent,
    String? title,
    String? type,
    Map<String, dynamic>? context,
  }) {
    final session = createNew(
      userId: userId,
      title: title,
      type: type,
      context: context,
    );
    
    final message = ChatMessage(
      sessionId: session.id,
      role: MessageRole.user,
      content: messageContent,
      timestamp: DateTime.now(),
      isFromAI: false,
    );
    
    return session.copyWith(
      messages: [message],
      lastMessageAt: DateTime.now(),
    );
  }
}

extension ChatMessageCreator on ChatMessage {
  /// Create a user message
  static ChatMessage createUserMessage({
    required String sessionId,
    required String content,
    String? id,
    MessageType? type,
    Map<String, dynamic>? data,
    List<MessageReference>? references,
  }) {
    return ChatMessage(
      id: id,
      sessionId: sessionId,
      role: MessageRole.user,
      type: type,
      content: content,
      data: data,
      references: references ?? [],
      timestamp: DateTime.now(),
      isFromAI: false,
      status: 'sent',
    );
  }

  /// Create an assistant message
  static ChatMessage createAssistantMessage({
    required String sessionId,
    required String content,
    String? id,
    MessageType? type,
    Map<String, dynamic>? data,
    List<MessageReference>? references,
    String? model,
    int? responseTimeMs,
    bool? wasStreamed,
  }) {
    return ChatMessage(
      id: id,
      sessionId: sessionId,
      role: MessageRole.assistant,
      type: type,
      content: content,
      data: data,
      references: references ?? [],
      timestamp: DateTime.now(),
      isFromAI: true,
      model: model,
      responseTimeMs: responseTimeMs,
      wasStreamed: wasStreamed ?? false,
      status: 'delivered',
    );
  }

  /// Create a system message
  static ChatMessage createSystemMessage({
    required String sessionId,
    required String content,
    String? id,
    MessageType? type,
    Map<String, dynamic>? data,
  }) {
    return ChatMessage(
      id: id,
      sessionId: sessionId,
      role: MessageRole.system,
      type: type,
      content: content,
      data: data,
      timestamp: DateTime.now(),
      isFromAI: false,
      status: 'delivered',
    );
  }

  /// Create a medical disclaimer message
  static ChatMessage createMedicalDisclaimerMessage(String sessionId) {
    return createSystemMessage(
      sessionId: sessionId,
      content: 'Rappel: Je suis un assistant IA et ne peux pas fournir de diagnostic médical. '
               'Mes réponses sont basées sur vos données personnelles et des analyses statistiques. '
               'Consultez toujours un professionnel de santé pour toute question médicale.',
      type: MessageType.warning,
    );
  }
}
