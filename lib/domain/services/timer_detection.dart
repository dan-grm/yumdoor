/// A duration found in step text: where it is, and how long a timer for it
/// runs.
final class DetectedDuration {
  const DetectedDuration({
    required this.start,
    required this.end,
    required this.duration,
  });

  /// The phrase is `text.substring(start, end)`, e.g. "25 Minuten".
  final int start;
  final int end;

  /// For a range ("10–12 Minuten"), the upper bound.
  final Duration duration;

  @override
  bool operator ==(Object other) =>
      other is DetectedDuration &&
      other.start == start &&
      other.end == end &&
      other.duration == duration;

  @override
  int get hashCode => Object.hash(start, end, duration);

  @override
  String toString() => 'DetectedDuration($start, $end, $duration)';
}

/// Finds durations in German and English step text, so they can be
/// highlighted and tapped to start a timer.
///
/// Understands seconds, minutes and hours, written out or abbreviated
/// ("25 Minuten", "10 Min", "1 Std", "2 hrs", "30 sec"); numbers as digits,
/// decimals ("1,5", "1.5"), fractions ("½", "1½", "1 1/2") and words ("zwei",
/// "anderthalb", "eineinhalb", "an", "three", "two and a half"); ranges, timed
/// to the upper bound ("10–12 Minuten", "2 bis 3 Stunden", "5 to 7 min");
/// combinations ("1 Stunde 20 Minuten", "1 hour and 20 minutes"); and a few
/// set phrases ("eine halbe Stunde", "Viertelstunde", "half an hour").
///
/// Anything else stays text: temperatures, "Schritt 3", "1 cm", compound words
/// ("Minutensteaks", "10-Minuten-Terrine"), "über Nacht".
abstract final class TimerDetection {
  /// The durations in [text], in order, never overlapping.
  static List<DetectedDuration> find(String text) {
    final found = <_Component>[];
    for (final match in _generic.allMatches(text)) {
      final component = _genericComponent(match);
      if (component != null) found.add(component);
    }
    for (final (pattern, duration, rank) in _phrases) {
      for (final match in pattern.allMatches(text)) {
        found.add(_Component(match.start, match.end, duration, rank));
      }
    }
    found.sort(
      (a, b) => a.start != b.start ? a.start - b.start : b.end - a.end,
    );

    // The earliest wins where two overlap: "half an hour" over "an hour".
    final components = <_Component>[];
    for (final component in found) {
      if (components.isEmpty || component.start >= components.last.end) {
        components.add(component);
      }
    }

    // "1 Stunde 20 Minuten": adjacent components of falling units add up.
    final result = <DetectedDuration>[];
    for (var i = 0; i < components.length; i++) {
      final first = components[i];
      var end = first.end;
      var duration = first.duration;
      var rank = first.rank;
      while (i + 1 < components.length) {
        final next = components[i + 1];
        if (next.rank >= rank ||
            !_joiner.hasMatch(text.substring(end, next.start))) {
          break;
        }
        end = next.end;
        duration += next.duration;
        rank = next.rank;
        i++;
      }
      result.add(
        DetectedDuration(start: first.start, end: end, duration: duration),
      );
    }
    return result;
  }

  static _Component? _genericComponent(RegExpMatch match) {
    final (unit, rank) = match.namedGroup('h') != null
        ? (const Duration(hours: 1), _hours)
        : match.namedGroup('m') != null
        ? (const Duration(minutes: 1), _minutes)
        : (const Duration(seconds: 1), _seconds);
    final from = match.namedGroup('from')!;
    final to = match.namedGroup('to');
    // "a second egg" is no duration: English seconds need a number in
    // digits.
    if (rank == _seconds &&
        match.namedGroup('s')!.toLowerCase().startsWith('sec') &&
        _startsWithWord.hasMatch(to ?? from)) {
      return null;
    }

    var value = _number(to ?? from);
    if (value == null) return null;
    if (match.namedGroup('half') != null) value += 0.5;
    final duration = Duration(
      milliseconds: (value * unit.inMilliseconds).round(),
    );
    // Whole seconds; "0 Minuten" is no timer.
    if (duration.inSeconds <= 0) return null;
    return _Component(
      match.start,
      match.end,
      Duration(seconds: duration.inSeconds),
      rank,
    );
  }

  /// The value of a number as matched by [_number] in the pattern.
  static double? _number(String raw) {
    var text = raw.trim().toLowerCase();
    var extra = 0.0;
    if (_andAHalf.firstMatch(text) case final match?) {
      text = text.substring(0, match.start);
      extra = 0.5;
    }
    if (_words[text] case final value?) return value + extra;

    if (_mixed.firstMatch(text) case final match?) {
      final whole = int.parse(match.group(1)!);
      final fraction = _fraction(match.group(2)!, match.group(3)!);
      return fraction == null ? null : whole + fraction + extra;
    }
    if (_simpleFraction.firstMatch(text) case final match?) {
      final fraction = _fraction(match.group(1)!, match.group(2)!);
      return fraction == null ? null : fraction + extra;
    }
    if (_decimal.firstMatch(text) case final match?) {
      final whole = match.group(1);
      final glyph = match.group(2);
      return (whole == null ? 0 : double.parse(whole.replaceAll(',', '.'))) +
          (glyph == null ? 0 : _glyphs[glyph]!) +
          extra;
    }
    return null;
  }

  static double? _fraction(String numerator, String denominator) {
    final d = int.parse(denominator);
    return d == 0 ? null : int.parse(numerator) / d;
  }

  static const _hours = 3;
  static const _minutes = 2;
  static const _seconds = 1;

  /// Horizontal whitespace, including no-break spaces; never a line break.
  static const _s = r'[^\S\r\n]';

  /// Not inside a word or number: "Minutensteaks", "A4", the 5 in "1.5".
  static const _before = r'(?<![\p{L}\p{N}]|\p{N}[.,/])';
  static const _after = r'(?![\p{L}\p{N}])';

  static const _glyphs = {
    '½': 0.5,
    '¼': 0.25,
    '¾': 0.75,
    '⅓': 1 / 3,
    '⅔': 2 / 3,
  };

  static const Map<String, double> _words = {
    // German
    'ein': 1, 'eine': 1, 'einer': 1, 'einen': 1, 'einem': 1,
    'zwei': 2, 'drei': 3, 'vier': 4, 'fünf': 5, 'sechs': 6, 'sieben': 7,
    'acht': 8, 'neun': 9, 'zehn': 10, 'elf': 11, 'zwölf': 12,
    'fünfzehn': 15, 'zwanzig': 20, 'dreißig': 30, 'vierzig': 40,
    'anderthalb': 1.5, 'eineinhalb': 1.5, 'zweieinhalb': 2.5,
    'dreieinhalb': 3.5,
    // English
    'a': 1, 'an': 1, 'one': 1, 'two': 2, 'three': 3, 'four': 4, 'five': 5,
    'six': 6, 'seven': 7, 'eight': 8, 'nine': 9, 'ten': 10, 'eleven': 11,
    'twelve': 12, 'fifteen': 15, 'twenty': 20, 'thirty': 30, 'forty': 40,
  };

  static final String _wordPattern =
      (_words.keys.toList()..sort((a, b) => b.length - a.length)).join('|');

  /// A number: "1 1/2", "1/2", "1,5", "1½", "½", or a word followed by a
  /// space; optionally "and a half".
  static final String _numberPattern =
      '(?:'
      r'\d{1,4}'
      '$_s+'
      r'\d{1,2}/\d{1,2}'
      r'|\d{1,2}/\d{1,2}'
      r'|\d{1,4}(?:[.,]\d{1,3})?(?:'
      '$_s?'
      r'[½¼¾⅓⅔])?'
      r'|[½¼¾⅓⅔]'
      '|(?:$_wordPattern)(?=$_s)'
      ')'
      '(?:$_s+and$_s+a$_s+half)?';

  static final _generic = RegExp(
    '$_before'
    '(?<from>$_numberPattern)'
    '(?:(?:$_s*[-–—]$_s*|$_s+(?:bis|to|or|oder)$_s+)(?<to>$_numberPattern))?'
    '$_s*'
    '(?:'
    '(?<h>stunden|stunde|std|hours|hour|hrs|hr|h)'
    '|(?<m>minuten|minute|min|minutes|mins)'
    '|(?<s>sekunden|sekunde|sek|seconds|second|secs|sec)'
    ')'
    '(?<half>$_s+and$_s+a$_s+half)?'
    '$_after',
    caseSensitive: false,
    unicode: true,
  );

  static RegExp _phrase(String pattern) => RegExp(
    '$_before(?:$pattern)$_after',
    caseSensitive: false,
    unicode: true,
  );

  static const _article = '(?:(?:eine[rnms]?|die|der)$_s+)?';

  static final _phrases = [
    (
      _phrase('${_article}halbe[nr]?$_s+stunde'),
      const Duration(minutes: 30),
      _hours,
    ),
    (
      _phrase('${_article}halbe[nr]?$_s+minute'),
      const Duration(seconds: 30),
      _minutes,
    ),
    (
      _phrase('${_article}dreiviertelstunden?'),
      const Duration(minutes: 45),
      _hours,
    ),
    (
      _phrase('${_article}viertelstunden?'),
      const Duration(minutes: 15),
      _hours,
    ),
    (_phrase('half$_s+an$_s+hour'), const Duration(minutes: 30), _hours),
    (
      _phrase('(?:a$_s+)?half(?:-|$_s)hour'),
      const Duration(minutes: 30),
      _hours,
    ),
    (
      _phrase('(?:a$_s+)?quarter$_s+(?:of$_s+an$_s+)?hour'),
      const Duration(minutes: 15),
      _hours,
    ),
    (
      _phrase('three(?:-|$_s)quarters$_s+of$_s+an$_s+hour'),
      const Duration(minutes: 45),
      _hours,
    ),
    (_phrase('half$_s+a$_s+minute'), const Duration(seconds: 30), _minutes),
  ];

  /// Between parts of a combination: spaces, or "und" / "and", maybe after
  /// an abbreviation's dot ("1 Std. 20 Min").
  static final _joiner = RegExp(
    '^\\.?(?:$_s*|$_s+(?:und|and)$_s+)\$',
    caseSensitive: false,
  );

  static final _startsWithWord = RegExp(r'^\p{L}', unicode: true);
  static final _andAHalf = RegExp('$_s+and$_s+a$_s+half\$');
  static final _mixed = RegExp(
    r'^(\d+)'
    '$_s+'
    r'(\d+)/(\d+)$',
  );
  static final _simpleFraction = RegExp(r'^(\d+)/(\d+)$');
  static final _decimal = RegExp(
    r'^(\d+(?:[.,]\d+)?)?'
    '$_s?'
    r'([½¼¾⅓⅔])?$',
  );
}

class _Component {
  _Component(this.start, this.end, this.duration, this.rank);

  final int start;
  final int end;
  final Duration duration;

  /// 3 for hours, 2 for minutes, 1 for seconds: combinations fall.
  final int rank;
}
