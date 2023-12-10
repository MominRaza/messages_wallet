import 'package:flutter_test/flutter_test.dart';
import 'package:messages_wallet/data.dart';
import 'package:messages_wallet/extracts/extract_bob.dart';
import 'package:messages_wallet/models/transaction_model.dart';

void main() {
  group(
    'BOB EXTRACT',
    () {
      test(
        'Credited',
        () {
          expect(
            extractBOBMessages([bobMessages[0]]),
            equals(
              {
                'BoB XX7544': [
                  Transaction(
                    type: 'Credited',
                    transactionAmount: '30',
                    finalAmount: '92.1',
                    accountNumber: 'BoB XX7544',
                    body: bobMessages[0],
                    dateTime: DateTime.parse('2023-08-09 22:40:20'),
                  ),
                ],
              },
            ),
          );
        },
      );

      test(
        'withdrawn',
        () {
          expect(
            extractBOBMessages([bobMessages[1]]),
            equals(
              {
                'BoB XX7544': [
                  Transaction(
                    type: 'withdrawn',
                    transactionAmount: '5500',
                    finalAmount: '496.1',
                    accountNumber: 'BoB XX7544',
                    body: bobMessages[1],
                    dateTime: DateTime.parse('2023-11-29 16:48:04'),
                  ),
                ]
              },
            ),
          );
        },
      );

      test(
        'transferred',
        () {
          expect(
            extractBOBMessages([bobMessages[2]]),
            equals(
              {
                'BoB XX7544': [
                  Transaction(
                    type: 'transferred',
                    transactionAmount: '20',
                    finalAmount: '3352.1',
                    accountNumber: 'BoB XX7544',
                    body: bobMessages[2],
                    dateTime: DateTime.parse('2023-10-31 21:19:22'),
                  )
                ]
              },
            ),
          );
        },
      );
    },
  );
}
