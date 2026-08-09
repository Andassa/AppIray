/// États de lecture exposés aux widgets (AsyncValue-friendly, immuable).
enum AudioPlaybackStatus { idle, loading, playing, paused, error }

class AudioPlaybackState {
  const AudioPlaybackState({
    required this.status,
    this.url,
    this.errorMessage,
  });

  const AudioPlaybackState.idle()
      : status = AudioPlaybackStatus.idle,
        url = null,
        errorMessage = null;

  final AudioPlaybackStatus status;
  final String? url;
  final String? errorMessage;

  bool get isLoading => status == AudioPlaybackStatus.loading;
  bool get isPlaying => status == AudioPlaybackStatus.playing;
  bool get isPaused => status == AudioPlaybackStatus.paused;
  bool get hasError => status == AudioPlaybackStatus.error;

  AudioPlaybackState copyWith({
    AudioPlaybackStatus? status,
    String? url,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AudioPlaybackState(
      status: status ?? this.status,
      url: url ?? this.url,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioPlaybackState &&
          status == other.status &&
          url == other.url &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode => Object.hash(status, url, errorMessage);
}
