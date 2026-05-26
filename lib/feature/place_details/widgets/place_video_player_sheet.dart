import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/core/utils/video_url_utils.dart';

/// Full-width bottom sheet that plays a direct video URL (MP4, etc.).
class PlaceVideoPlayerSheet extends StatefulWidget {
  final String videoUrl;
  final String title;

  const PlaceVideoPlayerSheet({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  static Future<void> show(
    BuildContext context, {
    required String videoUrl,
    required String title,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => PlaceVideoPlayerSheet(videoUrl: videoUrl, title: title),
    );
  }

  @override
  State<PlaceVideoPlayerSheet> createState() => _PlaceVideoPlayerSheetState();
}

class _PlaceVideoPlayerSheetState extends State<PlaceVideoPlayerSheet> {
  VideoPlayerController? _controller;
  var _initialized = false;
  var _failed = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );
      await controller.initialize();
      controller.setLooping(true);
      if (!mounted) {
        controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _initialized = true;
      });
      await controller.play();
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColor.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(widget.title,
              style: AppTextStyle.sectionTitle, maxLines: 2),
          const SizedBox(height: 12),
          AspectRatio(
            aspectRatio: _initialized && _controller != null
                ? _controller!.value.aspectRatio
                : 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildPlayerBody(),
            ),
          ),
          if (_initialized && _controller != null) ...[
            const SizedBox(height: 8),
            VideoProgressIndicator(
              _controller!,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: AppColor.primary,
                bufferedColor: AppColor.bgCardLight,
                backgroundColor: AppColor.border,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    final c = _controller!;
                    c.value.isPlaying ? c.pause() : c.play();
                    setState(() {});
                  },
                  icon: Icon(
                    _controller!.value.isPlaying
                        ? Icons.pause_circle_filled_rounded
                        : Icons.play_circle_filled_rounded,
                    color: AppColor.primary,
                    size: 48,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPlayerBody() {
    if (_failed) {
      return Container(
        color: AppColor.bgCardLight,
        alignment: Alignment.center,
        child: Text(
          'Could not play this video.',
          style: AppTextStyle.bodySmall.copyWith(color: AppColor.textSecondary),
        ),
      );
    }
    if (!_initialized || _controller == null) {
      return Container(
        color: AppColor.bgCardLight,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(color: AppColor.primary),
      );
    }
    return VideoPlayer(_controller!);
  }
}

/// Plays direct URLs in-app; opens YouTube externally.
Future<void> openPlaceVideo(BuildContext context, String url, String title) {
  if (VideoUrlUtils.isDirectVideo(url)) {
    return PlaceVideoPlayerSheet.show(
      context,
      videoUrl: url,
      title: title,
    );
  }
  return _openExternal(context, VideoUrlUtils.youtubeWatchUrl(url));
}

Future<void> _openExternal(BuildContext context, String url) async {
  final uri = Uri.parse(url);
  final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!launched && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not open video link')),
    );
  }
}
