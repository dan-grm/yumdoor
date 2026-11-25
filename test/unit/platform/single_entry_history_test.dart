import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/platform/browser_history/browser_history.dart';
import 'package:yumdoor/platform/browser_history/single_entry_history.dart';

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

class _FakeHistory implements BrowserHistory {
  int left = 0;

  @override
  bool get supported => true;

  @override
  void leaveApp() => left++;
}

void main() {
  const codec = JSONMethodCodec();
  late _RecordingMessenger engine;
  late _FakeHistory history;
  late SingleEntryHistoryMessenger messenger;
  late MethodChannel navigation;
  late MethodChannel platform;

  setUp(() {
    engine = _RecordingMessenger();
    history = _FakeHistory();
    messenger = SingleEntryHistoryMessenger(engine, history);
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

  test('back from the first screen goes to the page before the app, '
      'keeping the engine\'s history', () async {
    await platform.invokeMethod<void>('SystemNavigator.pop');

    expect(history.left, 1);
    expect(engine.sent, isEmpty);
  });

  test('passes on messages that aren\'t method calls', () async {
    final message = ByteData(2);
    await messenger.send(SystemChannels.platform.name, message);

    expect(engine.sent, [('flutter/platform', message)]);
  });

  test('passes other platform calls on with their answer', () async {
    final answer = await platform.invokeMethod<String>(
      'HapticFeedback.vibrate',
    );

    expect(sentMethods(), ['flutter/platform HapticFeedback.vibrate']);
    expect(answer, 'ok');
    expect(history.left, 0);
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
