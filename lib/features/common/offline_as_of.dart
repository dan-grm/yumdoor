import 'package:flutter/material.dart';

import '../../design/design.dart';
import '../../l10n/formatting.dart';
import '../../l10n/l10n.dart';

/// Says that what is shown comes from the offline cache, and when it was
/// last loaded from the server ([cachedAt]): "Offline · Stand vom 23. Nov.,
/// 14:05".
class OfflineAsOf extends StatelessWidget {
  const OfflineAsOf({super.key, required this.cachedAt, required this.now});

  final DateTime cachedAt;

  /// To leave out the year when it is this one's.
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final format = LocaleFormat.of(context);
    final local = cachedAt.toLocal();
    return Row(
      children: [
        Icon(Icons.cloud_off_rounded, size: t.space4, color: t.inkMuted),
        SizedBox(width: t.space2),
        Expanded(
          child: Text(
            context.l10n.offlineAsOf(
              format.dayMonthOrDate(local, now),
              format.time(local),
            ),
            style: t.caption.copyWith(color: t.inkMuted),
          ),
        ),
      ],
    );
  }
}
