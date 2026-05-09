import 'package:flutter/material.dart';
import 'package:studybyte/features/home/data/models/video_timeline_item.dart';

class QuizCard extends StatefulWidget {
  const QuizCard({super.key, required this.quiz});

  final QuizItem quiz;

  @override
  State<QuizCard> createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> {
  int? _selectedIndex;
  bool _submitted = false;

  void _onOptionTap(int index) {
    if (_submitted) return;
    setState(() => _selectedIndex = index);
  }

  void _submit() {
    if (_selectedIndex == null) return;
    setState(() => _submitted = true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCorrect =
        _submitted && _selectedIndex == widget.quiz.correctAnswerIndex;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withOpacity(0.12),
              theme.colorScheme.secondary.withOpacity(0.08),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Quick check-in',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.quiz.question,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 24),
              ...List.generate(widget.quiz.options.length, (index) {
                final option = widget.quiz.options[index];
                final isSelected = _selectedIndex == index;
                Color? tileColor;
                IconData? icon;

                if (_submitted) {
                  if (index == widget.quiz.correctAnswerIndex) {
                    tileColor = Colors.green.withOpacity(0.15);
                    icon = Icons.check_circle_rounded;
                  } else if (isSelected) {
                    tileColor = Colors.red.withOpacity(0.15);
                    icon = Icons.cancel_rounded;
                  }
                } else if (isSelected) {
                  tileColor = theme.colorScheme.primary.withOpacity(0.15);
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _onOptionTap(index),
                      borderRadius: BorderRadius.circular(16),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: tileColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.dividerColor.withOpacity(0.4),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                option,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight:
                                      isSelected ? FontWeight.w600 : FontWeight.w500,
                                ),
                              ),
                            ),
                            if (icon != null)
                              Icon(
                                icon,
                                size: 24,
                                color: index == widget.quiz.correctAnswerIndex
                                    ? Colors.green
                                    : Colors.red,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: _submitted ? null : _submit,
                  icon: Icon(
                    _submitted ? Icons.check_rounded : Icons.send_rounded,
                    size: 18,
                  ),
                  label: Text(_submitted ? 'Done' : 'Check answer'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              if (_submitted && widget.quiz.explanation.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (isCorrect ? Colors.green : Colors.orange)
                        .withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        isCorrect ? Icons.lightbulb_rounded : Icons.info_outline_rounded,
                        size: 20,
                        color: isCorrect ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.quiz.explanation,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
