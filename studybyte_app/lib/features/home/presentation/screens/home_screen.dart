import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studybyte/core/widgets/loading_skeleton.dart';
import 'package:studybyte/features/home/data/models/video_timeline_item.dart';
import 'package:studybyte/features/home/presentation/providers/video_timeline_provider.dart';
import 'package:studybyte/features/home/presentation/widgets/quiz_card.dart';
import 'package:studybyte/features/home/presentation/widgets/video_reel.dart';
import 'package:studybyte/features/user/presentation/providers/user_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController _pageController = PageController();
  String _selectedSubTopic = 'arrays';
  int _currentPageIndex = 0;
  

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(videoTimelineProvider).loadForSubTopic(_selectedSubTopic);
      ref.read(userProvider).syncFromAuth();
    });
  }

  void _onSubTopicChanged(String subTopic) {
    setState(() => _selectedSubTopic = subTopic);
    ref.read(videoTimelineProvider).loadForSubTopic(subTopic);
  }

  @override
  Widget build(BuildContext context) {
    final timelineState = ref.watch(videoTimelineProvider);
    final userState = ref.watch(userProvider);
    final entries = timelineState.timelineFor(_selectedSubTopic);
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.secondary,
            ],
          ).createShader(bounds),
          child: Text(
            'StudyByte',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withOpacity(0.3),
                  theme.colorScheme.secondary.withOpacity(0.2),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.code_rounded, size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 6),
                Text(
                  'DSA',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 72),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _SubTopicChip(
                  label: 'Arrays',
                  isSelected: _selectedSubTopic == 'arrays',
                  onTap: () => _onSubTopicChanged('arrays'),
                ),
                const SizedBox(width: 12),
                _SubTopicChip(
                  label: 'Stack',
                  isSelected: _selectedSubTopic == 'stack',
                  onTap: () => _onSubTopicChanged('stack'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: timelineState.isLoading && entries.isEmpty
                ? const LoadingSkeleton()
                : PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    onPageChanged: (index) {
                      setState(() => _currentPageIndex = index);
                    },
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      if (entry.type == TimelineType.quiz && entry.quiz != null) {
                        return QuizCard(quiz: entry.quiz!);
                      }
                      if (entry.type == TimelineType.video && entry.video != null) {
                        final v = entry.video!;
                        return VideoReel(
                          key: ValueKey(v.id),
                          video: v,
                          isVisible: index == _currentPageIndex,
                          onLike: () => userState.toggleLike(v.id),
                          onSave: () => userState.toggleSave(v.id),
                          isLiked: userState.isLiked(v.id),
                          isSaved: userState.isSaved(v.id),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _SubTopicChip extends StatelessWidget {
  const _SubTopicChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withOpacity(0.8),
                  ],
                )
              : null,
          color: isSelected ? null : theme.cardColor.withOpacity(0.9),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : theme.dividerColor.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : theme.colorScheme.onSurface,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Icon(Icons.bolt_rounded, size: 18, color: Colors.white.withOpacity(0.9)),
            ],
          ],
        ),
      ),
    );
  }
}
