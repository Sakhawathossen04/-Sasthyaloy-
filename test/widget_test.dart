import 'package:flutter_test/flutter_test.dart';
import 'package:sasthyaloy/core/constants/app_strings.dart';

void main() {
  test('Sasthyaloy brand identity test', () {
    expect(AppStrings.appNameBn, 'স্বাস্থ্যালয়');
    expect(AppStrings.appNameEn, 'Sasthyaloy');
  });
}
