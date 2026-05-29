class TransportEstimate {
  final String transportId;
  final bool isAvailable;
  final String? reasonUnavailable;
  final int? durationMinutes;
  final double? distanceKm;

  const TransportEstimate({
    required this.transportId,
    required this.isAvailable,
    this.reasonUnavailable,
    this.durationMinutes,
    this.distanceKm,
  });

  String get displayTime {
    if (!isAvailable) {
      return reasonUnavailable ?? 'Not available';
    }
    if (durationMinutes == null && distanceKm == null) {
      return '—';
    }
    final parts = <String>[];
    if (durationMinutes != null) {
      parts.add(_formatDuration(durationMinutes!));
    }
    if (distanceKm != null) {
      parts.add('${distanceKm!.toStringAsFixed(1)} km');
    }
    return parts.join(' · ');
  }

  static String _formatDuration(int minutes) {
    if (minutes < 60) return '$minutes min';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (m == 0) return '${h}h';
    return '${h}h ${m}m';
  }
}
