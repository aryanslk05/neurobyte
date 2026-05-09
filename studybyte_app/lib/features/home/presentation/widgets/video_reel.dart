import 'package:flutter/material.dart';
import 'package:studybyte/features/home/data/models/video_timeline_item.dart';
import 'package:video_player/video_player.dart';

class VideoReel extends StatefulWidget {
  const VideoReel({
    super.key,
    required this.video,
    required this.isVisible,
    required this.onLike,
    required this.onSave,
    required this.isLiked,
    required this.isSaved,
  });

  final VideoTimelineItem video;
  final bool isVisible;
  final VoidCallback onLike;
  final VoidCallback onSave;
  final bool isLiked;
  final bool isSaved;
  

  @override
  State<VideoReel> createState() => _VideoReelState();
}

class _VideoReelState extends State<VideoReel>
    with AutomaticKeepAliveClientMixin {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();

    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.video.videoUrl))
          ..initialize().then((_) {
            if (!mounted) return;

            setState(() {
              _initialized = true;
            });

            _controller.setLooping(true);
            _controller.setVolume(1.0);
            if (widget.isVisible) _controller.play();
          });
  }

  @override
  void didUpdateWidget(covariant VideoReel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_initialized && oldWidget.isVisible != widget.isVisible) {
      if (widget.isVisible) {
        _controller.play();
      } else {
        _controller.pause();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        /// 🎥 VIDEO
        if (_initialized)
          GestureDetector(
            onTap: () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },
            child: SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
          )
        else
          const Center(
            child: CircularProgressIndicator(),
          ),

        /// 🌑 Gradient Overlay (Cinematic Look)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 220,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        /// 📄 Bottom Left Info
        Positioned(
          bottom: 60,
          left: 16,
          right: 90,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withOpacity(0.6),
                ),
                child: Text(
                  widget.video.subTopic,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.video.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        /// ❤️ Right Side Actions
        Positioned(
          right: 16,
          bottom: 100,
          child: Column(
            children: [
              _CircleIconButton(
                icon:
                    widget.isLiked ? Icons.favorite : Icons.favorite_border,
                color:
                    widget.isLiked ? Colors.redAccent : Colors.white,
                onPressed: widget.onLike,
              ),
              const SizedBox(height: 16),
              _CircleIconButton(
                icon: widget.isSaved
                    ? Icons.bookmark
                    : Icons.bookmark_border,
                color:
                    widget.isSaved ? Colors.amberAccent : Colors.white,
                onPressed: widget.onSave,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onPressed,
    this.color,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.4),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(
            icon,
            size: 28,
            color: color ?? Colors.white,
          ),
        ),
      ),
    );
  }
}