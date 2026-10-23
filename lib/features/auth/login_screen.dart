import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/platform_providers.dart';
import '../../app/repository_providers.dart';
import '../../app/session.dart';
import '../../core/failures.dart';
import '../../design/design.dart';
import '../../domain/models/server_url.dart';
import '../../l10n/l10n.dart';

/// How the user logs in.
enum LoginMethod { password, token }

/// Server URL with a live version check, then username and password or an
/// API token (mockup `docs/design/mockups/screens/01-anmelden`).
///
/// The router leaves this screen as soon as a session starts.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  /// How long typing in the server field pauses before the version check.
  static const serverCheckDelay = Duration(milliseconds: 600);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _server = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _token = TextEditingController();

  LoginMethod _method = LoginMethod.password;
  bool _showPassword = false;
  bool _submitting = false;
  _ServerStatus _serverStatus = const _ServerUnchecked();
  String? _error;

  Timer? _serverCheckTimer;

  /// Increases with every check, so a slow answer for an old URL is ignored.
  int _serverCheck = 0;

  @override
  void initState() {
    super.initState();
    unawaited(_prefillServer());
  }

  /// The last server, or on the web the app's own origin.
  Future<void> _prefillServer() async {
    Uri? saved;
    try {
      saved = await ref.read(savedServerUrlProvider.future);
    } on Object {
      // Nothing stored that can be read; fall back to the origin.
    }
    final url = saved ?? ref.read(webOriginProvider);
    if (!mounted || url == null || _server.text.isNotEmpty) return;
    _server.text = url.toString();
    unawaited(_checkServer());
  }

  @override
  void dispose() {
    _serverCheckTimer?.cancel();
    _server.dispose();
    _username.dispose();
    _password.dispose();
    _token.dispose();
    super.dispose();
  }

  void _onServerChanged(String _) {
    _serverCheckTimer?.cancel();
    _serverCheck++;
    setState(() {
      _serverStatus = const _ServerUnchecked();
      _error = null;
    });
    _serverCheckTimer = Timer(LoginScreen.serverCheckDelay, _checkServer);
  }

  /// Checks the URL in the server field and returns it if a supported
  /// Tandoor answered.
  Future<Uri?> _checkServer() async {
    _serverCheckTimer?.cancel();
    final check = ++_serverCheck;
    final text = _server.text;
    final url = parseServerUrl(text);
    final origin = ref.read(webOriginProvider);
    final _ServerStatus status;
    if (url == null) {
      status = text.trim().isEmpty
          ? const _ServerUnchecked()
          : const _ServerProblem(_ServerProblemKind.invalid);
    } else if (origin != null && !isSameOrigin(url, origin)) {
      // The browser would block the request without saying why.
      status = _ServerOtherOrigin(origin);
    } else {
      setState(() => _serverStatus = const _ServerChecking());
      status = await _fetchServerStatus(url);
    }
    if (!mounted || check != _serverCheck) return null;
    setState(() => _serverStatus = status);
    return status is _ServerFound ? status.url : null;
  }

  Future<_ServerStatus> _fetchServerStatus(Uri url) async {
    try {
      final info = await ref
          .read(serverRepositoryProvider)
          .fetchServerInfo(url);
      return info.isSupported
          ? _ServerFound(url, info.version)
          : _ServerUnsupported(info.version);
    } on IncompatibleServerFailure {
      return const _ServerProblem(_ServerProblemKind.notTandoor);
    } on OfflineFailure {
      return const _ServerProblem(_ServerProblemKind.unreachable);
    } on Failure {
      return const _ServerProblem(_ServerProblemKind.error);
    }
  }

  Future<void> _submit() async {
    if (_submitting || !_formKey.currentState!.validate()) return;
    final current = _serverStatus;
    final url =
        current is _ServerFound && current.url == parseServerUrl(_server.text)
        ? current.url
        : await _checkServer();
    if (url == null || !mounted) return;

    setState(() {
      _submitting = true;
      _error = null;
    });
    final session = ref.read(sessionControllerProvider.notifier);
    try {
      switch (_method) {
        case LoginMethod.password:
          await session.loginWithPassword(
            url,
            username: _username.text.trim(),
            password: _password.text,
          );
        case LoginMethod.token:
          await session.loginWithToken(url, cleanToken(_token.text));
      }
    } on Failure catch (failure) {
      if (mounted) setState(() => _error = _loginError(failure));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String _loginError(Failure failure) {
    final l10n = context.l10n;
    return switch (failure) {
      InvalidCredentialsFailure() => l10n.loginErrorCredentials,
      UnauthorizedFailure() =>
        _method == LoginMethod.token
            ? l10n.loginErrorToken
            : l10n.loginErrorCredentials,
      ThrottledFailure() => l10n.loginErrorThrottled,
      OfflineFailure() => l10n.loginServerUnreachable,
      IncompatibleServerFailure() => l10n.loginServerNotTandoor,
      NotFoundFailure() ||
      CancelledFailure() ||
      ServerFailure() => l10n.loginServerError,
    };
  }

  void _selectMethod(LoginMethod method) => setState(() {
    _method = method;
    _error = null;
  });

  Future<void> _explainTandoor() => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(context.l10n.loginWhatIsTandoor),
      content: Text(context.l10n.loginWhatIsTandoorText),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MaterialLocalizations.of(context).closeButtonLabel),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: t.space5,
              vertical: t.space6,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: _maxFormWidth,
                  minHeight: constraints.maxHeight - 2 * t.space6,
                ),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: AutofillGroup(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: t.space8 + t.space4),
                          const _Header(),
                          SizedBox(height: t.space8),
                          _FieldLabel(l10n.loginServerLabel),
                          TextFormField(
                            controller: _server,
                            keyboardType: TextInputType.url,
                            autocorrect: false,
                            enableSuggestions: false,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.url],
                            style: t.bodyL,
                            decoration: _inputDecoration(context),
                            onChanged: _onServerChanged,
                            onFieldSubmitted: (_) => _checkServer(),
                            validator: (value) => (value ?? '').trim().isEmpty
                                ? l10n.loginServerRequired
                                : null,
                          ),
                          _ServerStatusLine(_serverStatus),
                          SizedBox(height: t.space5),
                          _MethodSwitch(
                            selected: _method,
                            onSelected: _selectMethod,
                          ),
                          SizedBox(height: t.space4),
                          ...switch (_method) {
                            LoginMethod.password => _passwordFields(context),
                            LoginMethod.token => _tokenFields(context),
                          },
                          if (_error case final error?) ...[
                            SizedBox(height: t.space4),
                            Semantics(
                              liveRegion: true,
                              child: Text(
                                error,
                                style: t.body.copyWith(color: t.danger),
                              ),
                            ),
                          ],
                          SizedBox(height: t.space6),
                          _SubmitButton(
                            label: l10n.loginSubmit,
                            busy: _submitting,
                            onPressed: _submit,
                          ),
                          const Spacer(),
                          SizedBox(height: t.space6),
                          TextButton(
                            onPressed: _explainTandoor,
                            style: TextButton.styleFrom(
                              foregroundColor: t.sage,
                              minimumSize: Size.fromHeight(t.sizeTouch),
                              textStyle: t.label,
                            ),
                            child: Text(l10n.loginWhatIsTandoor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _passwordFields(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    return [
      _FieldLabel(l10n.loginUsernameLabel),
      TextFormField(
        key: const ValueKey('username'),
        controller: _username,
        autocorrect: false,
        enableSuggestions: false,
        textInputAction: TextInputAction.next,
        autofillHints: const [AutofillHints.username],
        style: t.bodyL,
        decoration: _inputDecoration(context),
        validator: (value) =>
            (value ?? '').trim().isEmpty ? l10n.loginUsernameRequired : null,
      ),
      SizedBox(height: t.space3),
      _FieldLabel(l10n.loginPasswordLabel),
      TextFormField(
        key: const ValueKey('password'),
        controller: _password,
        obscureText: !_showPassword,
        autocorrect: false,
        enableSuggestions: false,
        textInputAction: TextInputAction.done,
        autofillHints: const [AutofillHints.password],
        style: t.bodyL,
        decoration: _inputDecoration(context).copyWith(
          suffixIcon: IconButton(
            tooltip: _showPassword
                ? l10n.loginHidePassword
                : l10n.loginShowPassword,
            color: t.inkMuted,
            icon: Icon(
              _showPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
            onPressed: () => setState(() => _showPassword = !_showPassword),
          ),
        ),
        onFieldSubmitted: (_) => _submit(),
        validator: (value) =>
            (value ?? '').isEmpty ? l10n.loginPasswordRequired : null,
      ),
      _Note(icon: Icons.lock_outline, text: l10n.loginPasswordNote),
    ];
  }

  List<Widget> _tokenFields(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    return [
      _FieldLabel(l10n.loginTokenLabel),
      TextFormField(
        key: const ValueKey('token'),
        controller: _token,
        autocorrect: false,
        enableSuggestions: false,
        textInputAction: TextInputAction.done,
        style: t.bodyL,
        decoration: _inputDecoration(context),
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        onFieldSubmitted: (_) => _submit(),
        validator: (value) =>
            cleanToken(value ?? '').isEmpty ? l10n.loginTokenRequired : null,
      ),
      _Note(icon: Icons.key_outlined, text: l10n.loginTokenNote),
    ];
  }

  /// Keeps the form readable on tablets and desktop browsers.
  static const _maxFormWidth = 480.0;
}

/// A pasted token without surrounding whitespace or a `Bearer ` prefix.
@visibleForTesting
String cleanToken(String input) =>
    input.trim().replaceFirst(RegExp(r'^bearer\s+', caseSensitive: false), '');

InputDecoration _inputDecoration(BuildContext context) {
  final t = context.tokens;
  OutlineInputBorder border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(t.radiusM),
    borderSide: BorderSide(color: color, width: 2),
  );
  return InputDecoration(
    filled: true,
    fillColor: t.surface,
    contentPadding: EdgeInsets.symmetric(
      horizontal: t.space4,
      vertical: t.space4,
    ),
    border: border(t.controlBorder),
    enabledBorder: border(t.controlBorder),
    focusedBorder: border(t.sage),
    errorBorder: border(t.danger),
    focusedErrorBorder: border(t.danger),
    errorStyle: t.caption.copyWith(color: t.danger),
  );
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final dot = t.space5;
    return Column(
      children: [
        ExcludeSemantics(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: t.space2,
            children: [
              for (final filled in [true, true, false])
                Container(
                  width: dot,
                  height: dot,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: filled ? t.sage : null,
                    border: filled
                        ? null
                        : Border.all(color: t.sage, width: dot / 8),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: t.space3),
        Semantics(
          header: true,
          child: Text(context.l10n.appTitle, style: t.titleL),
        ),
        SizedBox(height: t.space2),
        Text(
          context.l10n.loginTagline,
          textAlign: TextAlign.center,
          style: t.bodyL.copyWith(color: t.inkMuted),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: EdgeInsets.only(bottom: t.space2),
      child: Text(
        text,
        style: t.caption.copyWith(fontWeight: FontWeight.w800, color: t.ink),
      ),
    );
  }
}

/// A caption with an icon under a field.
class _Note extends StatelessWidget {
  const _Note({required this.icon, required this.text, this.color});

  final IconData icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final color = this.color ?? t.inkMuted;
    return Padding(
      padding: EdgeInsets.only(top: t.space2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: t.space2,
        children: [
          Icon(icon, size: t.space4, color: color),
          Expanded(
            child: Text(text, style: t.caption.copyWith(color: color)),
          ),
        ],
      ),
    );
  }
}

class _ServerStatusLine extends StatelessWidget {
  const _ServerStatusLine(this.status);

  final _ServerStatus status;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final Widget line = switch (status) {
      _ServerUnchecked() => const SizedBox.shrink(),
      _ServerChecking() => Padding(
        padding: EdgeInsets.only(top: t.space2),
        child: Row(
          spacing: t.space2,
          children: [
            SizedBox.square(
              dimension: t.space4,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: t.inkMuted,
              ),
            ),
            Text(
              l10n.loginServerChecking,
              style: t.caption.copyWith(color: t.inkMuted),
            ),
          ],
        ),
      ),
      _ServerFound(:final version) => _Note(
        icon: Icons.check,
        color: t.sage,
        text: l10n.loginServerFound(version),
      ),
      _ServerUnsupported(:final version) => _Note(
        icon: Icons.error_outline,
        color: t.danger,
        text: l10n.loginServerUnsupported(version),
      ),
      _ServerOtherOrigin(:final origin) => _Note(
        icon: Icons.info_outline,
        color: t.danger,
        text: l10n.loginServerOtherOrigin(origin.toString()),
      ),
      _ServerProblem(:final kind) => _Note(
        icon: Icons.error_outline,
        color: t.danger,
        text: switch (kind) {
          _ServerProblemKind.invalid => l10n.loginServerInvalid,
          _ServerProblemKind.notTandoor => l10n.loginServerNotTandoor,
          _ServerProblemKind.unreachable => l10n.loginServerUnreachable,
          _ServerProblemKind.error => l10n.loginServerError,
        },
      ),
    };
    return Semantics(liveRegion: true, child: line);
  }
}

class _MethodSwitch extends StatelessWidget {
  const _MethodSwitch({required this.selected, required this.onSelected});

  final LoginMethod selected;
  final ValueChanged<LoginMethod> onSelected;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    return Semantics(
      label: l10n.loginMethodLabel,
      container: true,
      child: Container(
        padding: EdgeInsets.all(t.space1),
        decoration: BoxDecoration(
          color: t.surfaceSunken,
          borderRadius: BorderRadius.circular(t.radiusFull),
        ),
        child: Row(
          spacing: t.space1,
          children: [
            for (final (method, label) in [
              (LoginMethod.password, l10n.loginMethodPassword),
              (LoginMethod.token, l10n.loginMethodToken),
            ])
              Expanded(
                child: _MethodTab(
                  label: label,
                  selected: method == selected,
                  onTap: () => onSelected(method),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MethodTab extends StatelessWidget {
  const _MethodTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(t.radiusFull),
      side: selected ? BorderSide(color: t.line) : BorderSide.none,
    );
    return Semantics(
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      excludeSemantics: true,
      label: label,
      onTap: onTap,
      child: Material(
        color: selected ? t.surface : Colors.transparent,
        shape: shape,
        child: InkWell(
          customBorder: shape,
          onTap: onTap,
          child: SizedBox(
            height: t.sizeTouch,
            child: Center(
              child: Text(
                label,
                style: t.label.copyWith(color: selected ? t.ink : t.inkMuted),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The accent button (docs/design/components/Button.md).
class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.label,
    required this.busy,
    required this.onPressed,
  });

  final String label;
  final bool busy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return FilledButton(
      onPressed: busy ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: t.sage,
        foregroundColor: t.onSage,
        disabledBackgroundColor: t.sage,
        disabledForegroundColor: t.onSage,
        minimumSize: Size.fromHeight(t.sizeButton),
        shape: const StadiumBorder(),
        textStyle: t.bodyL.copyWith(fontWeight: FontWeight.w800),
      ),
      child: busy
          ? SizedBox.square(
              dimension: t.space6,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: t.onSage,
                semanticsLabel: label,
              ),
            )
          : Text(label),
    );
  }
}

sealed class _ServerStatus {
  const _ServerStatus();
}

/// Nothing entered yet, or typing.
final class _ServerUnchecked extends _ServerStatus {
  const _ServerUnchecked();
}

final class _ServerChecking extends _ServerStatus {
  const _ServerChecking();
}

final class _ServerFound extends _ServerStatus {
  const _ServerFound(this.url, this.version);

  final Uri url;
  final String version;
}

final class _ServerUnsupported extends _ServerStatus {
  const _ServerUnsupported(this.version);

  final String version;
}

/// Web only: a server the browser won't let the app talk to.
final class _ServerOtherOrigin extends _ServerStatus {
  const _ServerOtherOrigin(this.origin);

  final Uri origin;
}

final class _ServerProblem extends _ServerStatus {
  const _ServerProblem(this.kind);

  final _ServerProblemKind kind;
}

enum _ServerProblemKind { invalid, notTandoor, unreachable, error }
