import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/offline.dart';
import '../../design/components/buttons.dart';
import '../../design/components/filter_chips.dart';
import '../../design/design.dart';
import '../../l10n/l10n.dart';
import '../../platform/image_picker/image_picker_service.dart';
import '../common/offline_disabled.dart';
import '../common/recipe_image.dart';
import 'editor_controller.dart';

/// Height of the photo preview, a bit lower than the image on the recipe
/// screen (mockup 04-rezept).
const _previewHeight = 180.0;

/// The recipe photo at the top of the "Allgemein" tab: a preview of the
/// photo it will have after saving, "Foto aufnehmen" (where there is a
/// camera), "Bild auswählen" and "Entfernen". On devices with a mouse the
/// empty area invites dropping an image; the editor screen listens for
/// drops, so a file dropped on any tab lands here.
///
/// Changes are only made to the draft; saving uploads them. Offline and
/// while saving the buttons are disabled.
class ImageArea extends ConsumerWidget {
  const ImageArea({
    super.key,
    required this.state,
    required this.canUseCamera,
    required this.supportsDrop,
    required this.dragging,
    required this.rejection,
    required this.onTakePhoto,
    required this.onPickFile,
    required this.onRemove,
  });

  final EditorState state;
  final bool canUseCamera;
  final bool supportsDrop;

  /// Whether an image file is being dragged over the window.
  final bool dragging;

  /// Why the last file chosen or dropped can't be used.
  final ImageRejection? rejection;
  final VoidCallback onTakePhoto;
  final VoidCallback onPickFile;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l10n = context.l10n;
    final enabled = !state.saving && !ref.watch(isOfflineProvider);
    final note = switch (rejection) {
      ImageRejection.notAnImage => l10n.editorImageNotAnImage,
      ImageRejection.tooLarge => l10n.editorImageTooLarge(
        maxImageBytes ~/ (1024 * 1024),
      ),
      ImageRejection.unreadable => l10n.editorImageUnreadable,
      null when state.newImage != null => l10n.editorImagePending,
      null when state.removeImage => l10n.editorImageRemoved,
      null => null,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(
            l10n.editorImage,
            style: t.caption.copyWith(
              color: t.inkMuted,
              fontWeight: t.label.fontWeight,
            ),
          ),
        ),
        SizedBox(height: t.space2),
        SizedBox(
          height: _previewHeight,
          child: dragging || !state.hasImage
              ? _EmptyFrame(
                  dragging: dragging,
                  enabled: enabled,
                  text: dragging
                      ? l10n.editorImageDropRelease
                      // Offline a drop is ignored; the notice above says why.
                      : supportsDrop && enabled
                      ? l10n.editorImageDrop
                      : l10n.editorImageNone,
                )
              : _Preview(state: state),
        ),
        if (note != null) ...[
          SizedBox(height: t.space2),
          Semantics(
            liveRegion: rejection != null,
            child: Text(
              note,
              style: t.caption.copyWith(
                color: rejection != null ? t.danger : t.inkMuted,
              ),
            ),
          ),
        ],
        SizedBox(height: t.space3),
        OfflineDisabled(
          builder: (context, _) {
            return Wrap(
              spacing: t.space2,
              runSpacing: t.space2,
              children: [
                if (canUseCamera)
                  PillButton(
                    label: l10n.editorImageTakePhoto,
                    icon: Icons.photo_camera_outlined,
                    kind: PillButtonKind.secondary,
                    compact: true,
                    onPressed: enabled ? onTakePhoto : null,
                  ),
                PillButton(
                  label: l10n.editorImagePick,
                  icon: Icons.image_outlined,
                  kind: PillButtonKind.secondary,
                  compact: true,
                  onPressed: enabled ? onPickFile : null,
                ),
                if (state.hasImage)
                  PillButton(
                    label: l10n.editorImageRemove,
                    icon: Icons.delete_outline_rounded,
                    kind: PillButtonKind.secondary,
                    compact: true,
                    onPressed: enabled ? onRemove : null,
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// The photo the recipe will have: the one just chosen, or the saved one.
class _Preview extends StatelessWidget {
  const _Preview({required this.state});

  final EditorState state;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final placeholder = Center(
      child: Icon(
        Icons.broken_image_outlined,
        size: t.sizeTouch,
        color: t.sage,
      ),
    );
    return Semantics(
      image: true,
      label: context.l10n.editorImage,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(t.radiusM),
        child: ColoredBox(
          color: t.sageSoft,
          child: switch (state.newImage) {
            final image? => Image.memory(
              image.bytes,
              // A camera photo decoded at full size takes ~50 MB.
              cacheWidth:
                  (MediaQuery.sizeOf(context).width *
                          MediaQuery.devicePixelRatioOf(context))
                      .round(),
              fit: BoxFit.cover,
              excludeFromSemantics: true,
              errorBuilder: (_, _, _) => placeholder,
            ),
            null => RecipeImage(
              url: state.savedImage,
              placeholder: placeholder,
            ),
          },
        ),
      ),
    );
  }
}

/// No photo, or a file dragged over the window: a dashed frame.
class _EmptyFrame extends StatelessWidget {
  const _EmptyFrame({
    required this.dragging,
    required this.enabled,
    required this.text,
  });

  final bool dragging;
  final bool enabled;
  final String text;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final color = dragging ? t.sage : t.inkMuted;
    return CustomPaint(
      painter: DashedOutlinePainter(
        color: dragging
            ? t.sage
            : enabled
            ? t.controlBorder
            : t.line,
        radius: t.radiusM,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: dragging ? t.sageSoft : Colors.transparent,
          borderRadius: BorderRadius.circular(t.radiusM),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(t.space4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: t.space2,
              children: [
                Icon(
                  Icons.add_photo_alternate_outlined,
                  size: t.sizeTouch / 2 + t.space2,
                  color: color,
                ),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: t.body.copyWith(color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
