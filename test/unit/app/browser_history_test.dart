import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/app/browser_history.dart';

/// Records what reaches the engine.
class _RecordingMessenger implements BinaryMessenger {
  final sent = <(String, ByteData?)>[];
  final handlers = <String, MessageHandler?>{};

  @override
  Future<ByteData?>? send(String channel, ByteData? message) {
    sent.add((channel, message));
    return Future.value(const JSONMethodCodec().encodeSuccessEnvelope('ok'));
  }

  @override
  void setMessageHandler(String channel, MessageHandler? handler) =>
      handlers[channel] = handler;

  @override
  Future<void> handlePlatformMessage(
    String channel,
    ByteData? data,
    PlatformMessageResponseCallback? callback,
  ) async {}
}

void main() {
  const codec = JSONMethodCodec();
  late _RecordingMessenger engine;
  late SingleEntryHistoryMessenger messenger;
  late MethodChannel navigation;
  late MethodChannel platform;

  setUp(() {
    engine = _RecordingMessenger();
    messenger = SingleEntryHistoryMessenger(engine);
    navigation = MethodChannel(
      SystemChannels.navigation.name,
      codec,
      messenger,
    );
    platform = MethodChannel(SystemChannels.platform.name, codec, messenger);
  });

  List<String> sentMethods() => [
    for (final (channel, message) in engine.sent)
      '$channel ${codec.decodeMethodCall(message).method}',
  ];

  test('asks for one history entry instead of one per location', () async {
    await navigation.invokeMethod<void>('selectMultiEntryHistory');

    expect(sentMethods(), ['flutter/navigation selectSingleEntryHistory']);
  });

  test('passes location updates on as they are', () async {
    final arguments = {'uri': '/recipe/7', 'state': null, 'replace': false};
    await navigation.invokeMethod<void>('routeInformationUpdated', arguments);

    final call = codec.decodeMethodCall(engine.sent.single.$2);
    expect(call.method, 'routeInformationUpdated');
    expect(call.arguments, arguments);
  });

  test('stays in the app on back from its first screen', () async {
    await platform.invokeMethod<void>('SystemNavigator.pop');

    expect(engine.sent, isEmpty);
  });

  test('passes other platform calls on with their answer', () async {
    final answer = await platform.invokeMethod<String>(
      'HapticFeedback.vibrate',
    );

    expect(sentMethods(), ['flutter/platform HapticFeedback.vibrate']);
    expect(answer, 'ok');
  });

  test('passes binary messages and handlers on', () async {
    final message = ByteData(2);
    await messenger.send('flutter/keyevent', message);
    await messenger.send(SystemChannels.navigation.name, null);
    Future<ByteData?> handler(ByteData? data) async => null;
    messenger.setMessageHandler('flutter/lifecycle', handler);

    expect(engine.sent, [
      ('flutter/keyevent', message),
      ('flutter/navigation', null),
    ]);
    expect(engine.handlers['flutter/lifecycle'], handler);
  });
}
