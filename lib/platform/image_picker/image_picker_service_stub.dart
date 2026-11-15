import 'image_picker_service.dart';

/// Native placeholder until the native builds use `image_picker`: offers
/// nothing and picks nothing.
class PlatformImagePickerService implements ImagePickerService {
  @override
  bool get canUseCamera => false;

  @override
  bool get supportsDrop => false;

  @override
  Future<ImagePickResult?> pickFromCamera() async => null;

  @override
  Future<ImagePickResult?> pickFile() async => null;

  @override
  Stream<ImageDropEvent> get drops => const Stream.empty();

  @override
  void dispose() {}
}
