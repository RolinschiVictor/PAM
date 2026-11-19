import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// "Description ⌄" / "Reviews ⌄" collapsible header used on the Product
/// Page. Starts expanded to match the Figma design.
class ExpandableSection extends StatefulWidget {
  final String title;
  final Widget child;
  final bool initiallyExpanded;

  const ExpandableSection({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = true,
  });

  @override
  State<ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<ExpandableSection> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => setState(() => _expanded = !_expanded),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.title, style: AppText.sectionHeading.copyWith(fontSize: 17)),
              Icon(
                _expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                color: AppColors.textPrimary,
              ),
            ],
          ),
        ),
        if (_expanded) ...[
          const SizedBox(height: 14),
          widget.child,
        ],
      ],
    );
  }
}
