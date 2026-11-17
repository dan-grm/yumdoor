import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/domain/services/step_template_references.dart';

void main() {
  test('finds references to ingredients by position', () {
    expect(
      StepTemplateReferences.hasAny('Mit {{ ingredients[0] }} mischen'),
      isTrue,
    );
    expect(
      StepTemplateReferences.hasAny('{{ingredients[ -1 ].amount}}'),
      isTrue,
    );
    expect(StepTemplateReferences.hasAny('{{ scale(100) }} g'), isFalse);
    expect(StepTemplateReferences.hasAny('ingredients[0]'), isFalse);
  });

  test('a change at an index shifts references to it and after it', () {
    const text = '{{ ingredients[1] }} und {{ ingredients[2].food }}';
    expect(StepTemplateReferences.shiftedBy(text, 0), isTrue);
    expect(StepTemplateReferences.shiftedBy(text, 2), isTrue);
    expect(StepTemplateReferences.shiftedBy(text, 3), isFalse);
  });

  test('references from the end always shift', () {
    expect(
      StepTemplateReferences.shiftedBy('{{ ingredients[-1] }}', 5),
      isTrue,
    );
  });

  test('text without references is never shifted', () {
    expect(StepTemplateReferences.shiftedBy('Ofen vorheizen', 0), isFalse);
  });
}
