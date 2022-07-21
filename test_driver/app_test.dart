import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('auth', () {
    final enterEmail = find.byValueKey("enterEmail");
    final enterPassword = find.byValueKey("enterPassword");
    final signIn = find.byValueKey("signIn");
    final homeScreen = find.byValueKey('homeScreen');
    final signOut = find.byValueKey('signOut');

    late FlutterDriver driver;
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    test('login', () async {
      await driver.tap(enterEmail);
      await driver.enterText("phualiting8@gmail.com");
      await driver.tap(enterPassword);
      await driver.enterText("123456");
      await driver.tap(signIn);
      await driver.waitFor(find.text("Home"));
    });

    test('signout', () async {
      await driver.tap(homeScreen);
      await driver.tap(signOut);
      await driver.waitFor(find.text('Seller Login'));
    });

    tearDownAll(() async {
      if(driver != null) {
        driver.close();
      }
    });
  });
}