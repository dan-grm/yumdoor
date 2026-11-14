import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/domain/services/timer_detection.dart';

void main() {
  /// The phrases found in [text] with their durations.
  List<(String, Duration)> find(String text) => [
    for (final found in TimerDetection.find(text))
      (text.substring(found.start, found.end), found.duration),
  ];

  const s = Duration(seconds: 1);
  const min = Duration(minutes: 1);
  const h = Duration(hours: 1);

  group('finds', () {
    final cases = <(String, String, Duration)>[
      // German, written out and abbreviated.
      ('und 25 Minuten rösten.', '25 Minuten', min * 25),
      ('1 Minute ruhen lassen', '1 Minute', min),
      ('10 Min. backen', '10 Min', min * 10),
      ('2 Stunden schmoren', '2 Stunden', h * 2),
      ('ca. 1 Std. gehen lassen', '1 Std', h),
      ('30 Sekunden pürieren', '30 Sekunden', s * 30),
      ('20 Sek. mixen', '20 Sek', s * 20),
      ('5 min köcheln', '5 min', min * 5),
      ('2 h kühlen', '2 h', h * 2),
      ('20min', '20min', min * 20),
      ('25 Minuten', '25 Minuten', min * 25),
      // English.
      ('Roast for 25 minutes.', '25 minutes', min * 25),
      ('Rest 1 minute', '1 minute', min),
      ('Simmer 10 mins', '10 mins', min * 10),
      ('Bake 1 hour', '1 hour', h),
      ('Chill 2 hrs', '2 hrs', h * 2),
      ('Blend 30 seconds', '30 seconds', s * 30),
      ('Whisk 45 secs', '45 secs', s * 45),
      ('Proof 1hr', '1hr', h),
      // Case doesn't matter.
      ('15 MINUTEN', '15 MINUTEN', min * 15),
      // Fractions and decimals.
      ('1½ Stunden garen', '1½ Stunden', h * 1.5),
      ('1 ½ Stunden', '1 ½ Stunden', h * 1.5),
      ('½ Stunde ziehen lassen', '½ Stunde', min * 30),
      ('1 1/2 hours', '1 1/2 hours', h * 1.5),
      ('1/2 Stunde', '1/2 Stunde', min * 30),
      ('¾ hour', '¾ hour', min * 45),
      ('1,5 Stunden', '1,5 Stunden', h * 1.5),
      ('1.5 hours', '1.5 hours', h * 1.5),
      // Words.
      ('anderthalb Stunden backen', 'anderthalb Stunden', h * 1.5),
      ('eineinhalb Stunden', 'eineinhalb Stunden', h * 1.5),
      ('zweieinhalb Stunden', 'zweieinhalb Stunden', min * 150),
      ('nach einer Stunde wenden', 'einer Stunde', h),
      ('drei Minuten kochen', 'drei Minuten', min * 3),
      ('Zwölf Stunden marinieren', 'Zwölf Stunden', h * 12),
      ('fünf Minuten', 'fünf Minuten', min * 5),
      ('eine Sekunde', 'eine Sekunde', s),
      ('for an hour', 'an hour', h),
      ('wait a minute', 'a minute', min),
      ('three minutes', 'three minutes', min * 3),
      ('two and a half hours', 'two and a half hours', min * 150),
      ('an hour and a half', 'an hour and a half', min * 90),
      // Set phrases.
      ('eine halbe Stunde', 'eine halbe Stunde', min * 30),
      ('nach einer halben Stunde', 'einer halben Stunde', min * 30),
      ('eine Viertelstunde', 'eine Viertelstunde', min * 15),
      ('eine Dreiviertelstunde', 'eine Dreiviertelstunde', min * 45),
      ('half an hour', 'half an hour', min * 30),
      ('a half-hour', 'a half-hour', min * 30),
      ('a quarter of an hour', 'a quarter of an hour', min * 15),
      ('three quarters of an hour', 'three quarters of an hour', min * 45),
      ('half a minute', 'half a minute', s * 30),
      // Ranges: the upper bound.
      ('10–12 Minuten', '10–12 Minuten', min * 12),
      ('10-12 Min', '10-12 Min', min * 12),
      ('10 - 12 Minuten', '10 - 12 Minuten', min * 12),
      ('2 bis 3 Stunden', '2 bis 3 Stunden', h * 3),
      ('zwei bis drei Minuten', 'zwei bis drei Minuten', min * 3),
      ('5 to 7 minutes', '5 to 7 minutes', min * 7),
      ('20 or 25 minutes', '20 or 25 minutes', min * 25),
      ('1–1½ Stunden', '1–1½ Stunden', h * 1.5),
      // Combinations.
      ('1 Stunde 20 Minuten', '1 Stunde 20 Minuten', min * 80),
      ('1 Stunde und 20 Minuten', '1 Stunde und 20 Minuten', min * 80),
      ('1 Std. 20 Min.', '1 Std. 20 Min', min * 80),
      ('1h 20min', '1h 20min', min * 80),
      ('1 hour and 20 minutes', '1 hour and 20 minutes', min * 80),
      ('2 Minuten 30 Sekunden', '2 Minuten 30 Sekunden', s * 150),
      (
        'eine halbe Stunde und 10 Minuten',
        'eine halbe Stunde und 10 Minuten',
        min * 40,
      ),
      ('2 hours 10–15 minutes', '2 hours 10–15 minutes', min * 135),
      // "or two": the upper bound.
      ('a minute or two', 'a minute or two', min * 2),
      ('cook an hour or two', 'an hour or two', h * 2),
      ('eine Minute oder zwei', 'eine Minute oder zwei', min * 2),
    ];
    for (final (text, phrase, duration) in cases) {
      test('"$phrase" in "$text"', () {
        expect(find(text), [(phrase, duration)]);
      });
    }
  });

  group('ignores', () {
    final cases = [
      // Temperatures.
      'Den Ofen auf 200 °C vorheizen.',
      'Bei 180 Grad backen.',
      'Preheat to 350°F.',
      'Gas mark 4',
      // Step numbers, lengths, amounts.
      'Wie in Schritt 3 beschrieben.',
      'As in step 3.',
      'In 1 cm dicke Scheiben schneiden.',
      '200 g Mehl',
      '3 Eier',
      'um 18 Uhr',
      // Compound words.
      '4 Minutensteaks braten',
      'Die 10-Minuten-Terrine',
      'Stundenlang köcheln',
      'Minuten später',
      '5 Hähnchenschenkel',
      '2 Hörnchen',
      '5 mindestens',
      'Add a second egg.',
      'Do it a second time.',
      'H1 2 Hz',
      // Clock notation isn't understood; better nothing than 30 hours.
      'Garzeit 1:30 h',
      '0:45 Std.',
      // Without a duration.
      'Über Nacht ziehen lassen.',
      'Leave overnight.',
      'ein paar Minuten',
      'a few minutes',
      '0 Minuten',
      'Minuten',
      // Template leftovers.
      '{{ ingredients[0] }} Minuten',
    ];
    for (final text in cases) {
      test('"$text"', () => expect(find(text), isEmpty));
    }
  });

  test('finds several in order, with their positions', () {
    const text = 'Erst 5 Minuten anbraten, dann 20–25 Minuten köcheln.';
    expect(TimerDetection.find(text), [
      const DetectedDuration(start: 5, end: 14, duration: Duration(minutes: 5)),
      const DetectedDuration(
        start: 30,
        end: 43,
        duration: Duration(minutes: 25),
      ),
    ]);
  });

  test('doesn\'t combine rising units or across words', () {
    expect(find('20 Minuten 1 Stunde'), [
      ('20 Minuten', min * 20),
      ('1 Stunde', h),
    ]);
    expect(find('5 Minuten braten und 2 Minuten ruhen lassen'), [
      ('5 Minuten', min * 5),
      ('2 Minuten', min * 2),
    ]);
    expect(find('Im Ofen 1 Stunde. 10 Minuten vor Ende Käse darauf.'), [
      ('1 Stunde', h),
      ('10 Minuten', min * 10),
    ]);
    expect(find('Bake for 1 hour. 15 minutes before the end, add cheese.'), [
      ('1 hour', h),
      ('15 minutes', min * 15),
    ]);
    expect(find('1 Stunde.\n20 Minuten'), [
      ('1 Stunde', h),
      ('20 Minuten', min * 20),
    ]);
  });

  test('rounds to whole seconds', () {
    expect(find('⅓ Minute'), [('⅓ Minute', s * 20)]);
    expect(find('0,001 Sekunden'), isEmpty);
  });
}
