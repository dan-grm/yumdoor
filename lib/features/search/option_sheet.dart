import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design/design.dart';
import '../common/failure_view.dart';

/// A choice in an option sheet: its label and the value it returns.
typedef SheetOption<T> = (String label, T value);

/// Lets the user pick one of [options] and returns its value, or `null` if
/// the sheet was closed. [hint] explains the choices under the [title].
Future<T?> showOptionSheet<T>(
  BuildContext context, {
  required String title,
  String? hint,
  required List<SheetOption<T>> options,
}) => showLoadingOptionSheet<T>(
  context,
  title: title,
  hint: hint,
  options: (_) => AsyncData(options),
);

/// Like [showOptionSheet] for options that are loaded: [options] watches
/// them, [retry] loads them again after an error, and [empty] says why there
/// are none.
Future<T?> showLoadingOptionSheet<T>(
  BuildContext context, {
  required String title,
  String? hint,
  required AsyncValue<List<SheetOption<T>>> Function(WidgetRef ref) options,
  void Function(WidgetRef ref)? retry,
  String? empty,
}) {
  final t = context.tokens;
  return showModalBottomSheet<T>(
    context: context,
    showDragHandle: true,
    backgroundColor: t.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(t.radiusL)),
    ),
    builder: (context) => _OptionSheet<T>(
      title: title,
      hint: hint,
      options: options,
      retry: retry,
      empty: empty,
    ),
  );
}

class _OptionSheet<T> extends ConsumerWidget {
  const _OptionSheet({
    required this.title,
    required this.hint,
    required this.options,
    required this.retry,
    required this.empty,
  });

  final String title;
  final String? hint;
  final AsyncValue<List<SheetOption<T>>> Function(WidgetRef ref) options;
  final void Function(WidgetRef ref)? retry;
  final String? empty;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final hint = this.hint;
    final empty = this.empty;
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(t.space5, 0, t.space5, t.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: Text(title, style: t.titleS.copyWith(color: t.ink)),
            ),
            if (hint != null) ...[
              SizedBox(height: t.space1),
              Text(hint, style: t.caption.copyWith(color: t.inkMuted)),
            ],
            SizedBox(height: t.space2),
            ...switch (options(ref)) {
              AsyncData(value: final choices)
                  when choices.isEmpty && empty != null =>
                [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: t.space4),
                    child: Text(
                      empty,
                      textAlign: TextAlign.center,
                      style: t.body.copyWith(color: t.inkMuted),
                    ),
                  ),
                ],
              AsyncData(value: final choices) => [
                for (final (label, value) in choices)
                  InkWell(
                    onTap: () => Navigator.of(context).pop(value),
                    borderRadius: BorderRadius.circular(t.radiusM),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: t.sizeTouch),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          label,
                          style: t.body.copyWith(color: t.ink),
                        ),
                      ),
                    ),
                  ),
              ],
              AsyncError(:final error) => [
                FailureView(error: error, onRetry: () => retry?.call(ref)),
              ],
              _ => [
                Padding(
                  padding: EdgeInsets.all(t.space5),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ],
            },
          ],
        ),
      ),
    );
  }
}
