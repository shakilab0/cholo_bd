/// Helpers for place video URLs (YouTube or direct MP4/WebM).
class VideoUrlUtils {
  VideoUrlUtils._();

  static bool isYouTube(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    final host = uri.host.toLowerCase();
    return host.contains('youtube.com') ||
        host.contains('youtu.be') ||
        host.contains('youtube-nocookie.com');
  }

  static bool isDirectVideo(String url) {
    if (isYouTube(url)) return false;
    final lower = url.toLowerCase();
    return lower.endsWith('.mp4') ||
        lower.endsWith('.webm') ||
        lower.endsWith('.mov') ||
        lower.contains('/video/');
  }

  /// Extracts YouTube video ID for thumbnails and external launch.
  static String? youtubeVideoId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    if (uri.host.contains('youtu.be')) {
      final id = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
      return id != null && id.isNotEmpty ? id : null;
    }

    if (uri.host.contains('youtube.com')) {
      final v = uri.queryParameters['v'];
      if (v != null && v.isNotEmpty) return v;
      final segments = uri.pathSegments;
      if (segments.length >= 2 &&
          (segments[0] == 'embed' || segments[0] == 'shorts')) {
        return segments[1];
      }
    }
    return null;
  }

  static String? youtubeThumbnail(String url) {
    final id = youtubeVideoId(url);
    if (id == null) return null;
    return 'https://img.youtube.com/vi/$id/hqdefault.jpg';
  }

  static String youtubeWatchUrl(String url) {
    final id = youtubeVideoId(url);
    if (id != null) return 'https://www.youtube.com/watch?v=$id';
    return url;
  }
}
