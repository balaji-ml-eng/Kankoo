import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:kankoo/ingestion/email/email_source.dart';
import 'package:kankoo/ingestion/email/gmail_api_source.dart';

void main() {
  test('Gmail reads every page rather than capping total imported messages', () async {
    var lists = 0;
    final client = MockClient((request) async {
      if (request.url.path.endsWith('/messages')) {
        lists++;
        return http.Response(
          jsonEncode({
            'messages': [
              {'id': lists == 1 ? 'one' : 'two'},
            ],
            if (lists == 1) 'nextPageToken': 'next',
          }),
          200,
        );
      }
      return http.Response(
        jsonEncode({
          'id': request.url.pathSegments.last,
          'internalDate': '${DateTime(2026).millisecondsSinceEpoch}',
          'payload': {
            'headers': [
              {'name': 'From', 'value': 'alerts@hdfcbank.net'},
              {'name': 'Subject', 'value': 'Payment'},
            ],
            'mimeType': 'text/plain',
            'body': {'data': base64Url.encode(utf8.encode('INR 10 debited'))},
          },
        }),
        200,
      );
    });
    addTearDown(client.close);
    final source = GmailApiSource(token: () async => 'fake', httpClient: client);
    expect(await source.fetchSince(DateTime(2026), limit: 1), hasLength(2));
    expect(lists, 2);
  });

  test('Gmail detail errors fail the import instead of silently dropping mail', () async {
    final client = MockClient(
      (request) async => request.url.path.endsWith('/messages')
          ? http.Response('{"messages":[{"id":"one"}]}', 200)
          : http.Response('busy', 429),
    );
    addTearDown(client.close);
    await expectLater(
      GmailApiSource(token: () async => 'fake', httpClient: client).fetchSince(DateTime(2026)),
      throwsA(isA<EmailConnectException>()),
    );
  });
}
