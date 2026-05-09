import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studybyte/core/network/api_client.dart';
import 'package:studybyte/core/theme/theme_notifier.dart';
import 'package:studybyte/features/auth/presentation/providers/auth_provider.dart';
import 'package:studybyte/features/auth/presentation/screens/login_screen.dart';
import 'package:studybyte/features/user/presentation/providers/user_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProvider).loadProfileStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final userState = ref.watch(userProvider);
    final theme = Theme.of(context);
    final user = auth.user;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Please log in',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      );
    }

    final stats = userState.stats;
    final totalWatched = (stats['totalWatched'] ?? 0) as int;
    final totalSaved = (stats['totalSaved'] ?? 0) as int;
    final totalLiked = (stats['totalLiked'] ?? 0) as int;
    final subTopicProgress = userState.subTopicProgress;
    final isDark = ref.watch(themeNotifierProvider).themeMode == ThemeMode.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Profile',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary.withOpacity(0.12),
                      theme.colorScheme.secondary.withOpacity(0.06),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProfileCard(
                    theme: theme,
                    avatar: user.avatar,
                    name: user.name,
                    email: user.email,
                    semester: user.semester,
                    stream: user.stream,
                    onEdit: () => _showEditProfileSheet(context, ref, user),
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle(theme: theme, title: 'Stats'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          theme: theme,
                          icon: Icons.play_circle_outline_rounded,
                          label: 'Watched',
                          value: totalWatched.toString(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          theme: theme,
                          icon: Icons.bookmark_rounded,
                          label: 'Saved',
                          value: totalSaved.toString(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          theme: theme,
                          icon: Icons.favorite_rounded,
                          label: 'Liked',
                          value: totalLiked.toString(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  _SectionTitle(theme: theme, title: 'Completion'),
                  const SizedBox(height: 12),
                  _ProgressCard(
                    theme: theme,
                    label: 'Arrays',
                    progress: subTopicProgress,
                  ),
                  const SizedBox(height: 12),
                  _ProgressCard(
                    theme: theme,
                    label: 'Stack',
                    progress: subTopicProgress,
                  ),
                  const SizedBox(height: 28),
                  _SectionTitle(theme: theme, title: 'Settings'),
                  const SizedBox(height: 12),
                  _SettingsTile(
                    theme: theme,
                    icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    title: 'Dark Mode',
                    subtitle: isDark ? 'On' : 'Off',
                    trailing: Switch(
                      value: isDark,
                      onChanged: (_) {
                        ref.read(themeNotifierProvider).toggleTheme();
                      },
                      activeColor: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SettingsTile(
                    theme: theme,
                    icon: Icons.logout_rounded,
                    title: 'Log out',
                    subtitle: 'Sign out of your account',
                    onTap: () async {
                      await ref.read(authProvider).logout();
                      ref.read(userProvider).setSavedLikedFromAuth(null);
                      if (!mounted) return;
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (_) => false,
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileSheet(
    BuildContext context,
    WidgetRef ref,
    dynamic user,
  ) {
    final nameController = TextEditingController(text: user.name);
    final semesterController = TextEditingController(text: user.semester);
    final streamController = TextEditingController(text: user.stream);
    String selectedAvatar = user.avatar;

    final avatars = ['📚', '🎓', '💻', '🚀', '⭐', '🔥', '📖', '📝'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: Theme.of(ctx).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(ctx).dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Edit Profile',
                  style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 20),
                Text('Avatar', style: Theme.of(ctx).textTheme.labelLarge),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: avatars.map((a) {
                    final isSelected = selectedAvatar == a;
                    return GestureDetector(
                      onTap: () {
                        setModalState(() => selectedAvatar = a);
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(ctx).colorScheme.primary.withOpacity(0.2)
                              : Theme.of(ctx).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(14),
                          border: isSelected
                              ? Border.all(
                                  color: Theme.of(ctx).colorScheme.primary,
                                  width: 2,
                                )
                              : null,
                        ),
                        child: Center(
                          child: Text(a, style: const TextStyle(fontSize: 24)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: semesterController,
                  decoration: const InputDecoration(
                    labelText: 'Semester',
                    prefixIcon: Icon(Icons.school_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: streamController,
                  decoration: const InputDecoration(
                    labelText: 'Course / Stream',
                    prefixIcon: Icon(Icons.menu_book_outlined),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await ApiClient.instance.put(
                          '/api/user/updateProfile',
                          body: {
                            'name': nameController.text.trim(),
                            'semester': semesterController.text.trim(),
                            'stream': streamController.text.trim(),
                            'avatar': selectedAvatar,
                          },
                          authorized: true,
                        );
                        ref.read(userProvider).loadProfileStats();
                        if (ctx.mounted) Navigator.pop(ctx);
                      } catch (_) {}
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.theme,
    required this.avatar,
    required this.name,
    required this.email,
    required this.semester,
    required this.stream,
    required this.onEdit,
  });

  final ThemeData theme;
  final String avatar;
  final String name;
  final String email;
  final String semester;
  final String stream;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withOpacity(0.12),
            theme.colorScheme.secondary.withOpacity(0.06),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: theme.colorScheme.primary.withOpacity(0.2),
            ),
            child: Center(
              child: Text(avatar, style: const TextStyle(fontSize: 36)),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                if (semester.isNotEmpty || stream.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (semester.isNotEmpty)
                        _Chip(
                          theme: theme,
                          label: 'Sem $semester',
                        ),
                      if (semester.isNotEmpty && stream.isNotEmpty)
                        const SizedBox(width: 8),
                      if (stream.isNotEmpty)
                        _Chip(
                          theme: theme,
                          label: stream,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: Icon(
              Icons.edit_rounded,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.theme, required this.label});

  final ThemeData theme;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.theme, required this.title});

  final ThemeData theme;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.theme,
    required this.icon,
    required this.label,
    required this.value,
  });

  final ThemeData theme;
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.theme,
    required this.label,
    required this.progress,
  });

  final ThemeData theme;
  final String label;
  final Map<String, dynamic> progress;

  @override
  Widget build(BuildContext context) {
    final data = progress[label] as Map<String, dynamic>?;
    final watched = (data?['watched'] ?? 0) as int;
    final total = (data?['total'] ?? 10) as int;
    final value = total > 0 ? watched / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${(value * 100).round()}%',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 10,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$watched / $total videos',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.theme,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  final ThemeData theme;
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
