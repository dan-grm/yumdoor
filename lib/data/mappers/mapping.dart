// Helpers shared by the mappers. They throw [FormatException] for data the
// domain can't represent; `guardRequest` turns that into a `ServerFailure`.

/// Every `id` in the generated client is nullable (see
/// packages/tandoor_api/README.md), but the server always sends one.
int requireId(int? id, String type) =>
    id ?? (throw FormatException('$type without an id'));

/// Tandoor's URL fields are `null`, empty or a URL.
Uri? optionalUri(String? value) =>
    value == null || value.isEmpty ? null : Uri.tryParse(value);

/// Tandoor stores durations as whole minutes.
Duration minutes(int? value) => Duration(minutes: value ?? 0);

/// The generated client returns `null` data for an empty response body.
T requireBody<T>(T? body) =>
    body ?? (throw const FormatException('Empty response'));
