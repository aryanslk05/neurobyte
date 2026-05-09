import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studybyte/features/home/data/models/video_timeline_item.dart';
import 'package:studybyte/features/home/presentation/widgets/video_reel.dart';
import 'package:studybyte/features/user/presentation/providers/user_provider.dart';

class SavedReelPlayerScreen extends ConsumerStatefulWidget {
  const SavedReelPlayerScreen({
    super.key,
    required this.videos,
    required this.initialIndex,
  });

  final List<VideoTimelineItem> videos;
  final int initialIndex;

  @override
  ConsumerState<SavedReelPlayerScreen> createState() =>
      _SavedReelPlayerScreenState();
}

class _SavedReelPlayerScreenState extends ConsumerState<SavedReelPlayerScreen> {
  late PageController _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    _currentPageIndex = widget.initialIndex;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);

    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      onPageChanged: (index) => setState(() => _currentPageIndex = index),
      itemCount: widget.videos.length,
      itemBuilder: (context, index) {
        final v = widget.videos[index];
        return VideoReel(
          key: ValueKey(v.id),
          video: v,
          isVisible: index == _currentPageIndex,
          onLike: () => userState.toggleLike(v.id),
          onSave: () => userState.toggleSave(v.id),
          isLiked: userState.isLiked(v.id),
          isSaved: userState.isSaved(v.id),
        );
      },
    );
  }
}
