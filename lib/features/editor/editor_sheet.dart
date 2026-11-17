import 'package:flutter/material.dart';

import '../../design/design.dart';

/// A bottom sheet of the editor that grows with its content and stays above
/// the keyboard.
Future<T?> showEditorSheet<T>(BuildContext context, WidgetBuilder builder) {
  final t = context.tokens;
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: t.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(t.radiusL)),
    ),
    builder: builder,
  );
}

/// The frame of an editor sheet: [title], then [children], scrolling when
/// the keyboard leaves too little room.
class EditorSheetFrame extends StatelessWidget {
  const EditorSheetFrame({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(t.space5, 0, t.space5, t.space4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: t.space4,
            children: [
              Semantics(
                header: true,
                child: Text(title, style: t.titleM.copyWith(color: t.ink)),
              ),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}
