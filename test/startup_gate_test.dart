import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kankoo/core/startup_gate.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences preferences;
  setUp(() async {
    SharedPreferences.setMockInitialValues({'existing_lock_enabled': true, 'existing_user_note': 'Keep my settings'});
    preferences = await SharedPreferences.getInstance();
  });

  testWidgets('first app frame and taps do not wait for hung optional AI or download work', (tester) async {
    final optional = Completer<void>();
    var taps = 0, appBuilt = false, optionalStartedAfterApp = false;
    await tester.pumpWidget(
      StartupGate(
        loadPreferences: () async => preferences,
        afterReady: () {
          optionalStartedAfterApp = appBuilt;
          return optional.future;
        },
        builder: (_) => MaterialApp(
          home: Builder(
            builder: (_) {
              appBuilt = true;
              return Scaffold(
                body: TextButton(onPressed: () => taps++, child: const Text('App is ready')),
              );
            },
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(find.text('App is ready'), findsOneWidget);
    expect(optionalStartedAfterApp, isTrue);
    await tester.tap(find.text('App is ready'));
    expect(taps, 1);
    await tester.pump(const Duration(minutes: 1));
    expect(find.text('App is ready'), findsOneWidget);
    expect(tester.takeException(), isNull);
    optional.complete();
    await tester.pump();
  });

  testWidgets('optional plugin failure never replaces the usable app', (tester) async {
    await tester.pumpWidget(
      StartupGate(
        loadPreferences: () async => preferences,
        afterReady: () async => throw StateError('optional plugin failed'),
        builder: (_) => const MaterialApp(home: Scaffold(body: Text('Ready'))),
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(find.text('Ready'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('hung preferences paint a recoverable error without bypassing saved security settings', (tester) async {
    final pending = Completer<SharedPreferences>();
    var built = false, optionalCalled = false;
    await tester.pumpWidget(
      StartupGate(
        loadPreferences: () => pending.future,
        preferencesTimeout: const Duration(seconds: 2),
        afterReady: () async {
          optionalCalled = true;
        },
        builder: (_) {
          built = true;
          return const SizedBox();
        },
      ),
    );
    expect(find.text('Opening Kankoo…'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
    expect(find.text('Kankoo couldn’t open its saved settings.'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
    expect((built, optionalCalled), (false, false));
    pending.complete(preferences);
    await tester.pump();
    expect(built, isFalse, reason: 'A timed-out load cannot mount a late, stale app');
  });

  testWidgets('retry loads the original settings, retaining the enabled lock and existing data', (tester) async {
    var attempts = 0;
    SharedPreferences? received;
    await tester.pumpWidget(
      StartupGate(
        loadPreferences: () async {
          if (++attempts == 1) throw StateError('temporary settings error');
          return preferences;
        },
        builder: (prefs) {
          received = prefs;
          return const MaterialApp(home: Scaffold(body: Text('Restored startup')));
        },
      ),
    );
    await tester.pump();
    expect(received, isNull);
    await tester.tap(find.text('Retry'));
    await tester.pump();
    await tester.pump();
    expect(find.text('Restored startup'), findsOneWidget);
    expect(received, same(preferences));
    expect(received!.getBool('existing_lock_enabled'), isTrue);
    expect(received!.getString('existing_user_note'), 'Keep my settings');
    expect(attempts, 2);
  });

  testWidgets('late preference completion after disposal cannot restart the app', (tester) async {
    final pending = Completer<SharedPreferences>();
    var built = false;
    await tester.pumpWidget(
      StartupGate(
        loadPreferences: () => pending.future,
        builder: (_) {
          built = true;
          return const SizedBox();
        },
      ),
    );
    await tester.pumpWidget(const SizedBox());
    pending.complete(preferences);
    await tester.pump();
    expect(built, isFalse);
    expect(tester.takeException(), isNull);
  });
}
