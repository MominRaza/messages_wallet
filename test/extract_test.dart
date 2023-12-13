import 'package:flutter_test/flutter_test.dart';
import 'package:messages_wallet/extracts/extract_axis.dart';
import 'package:messages_wallet/extracts/extract_bob.dart';
import 'package:messages_wallet/models/transaction_model.dart';

import 'test_data.dart';

void main() {
  group(
    'BOB Extract',
    () {
      test(
        'Credited',
        () => expect(
          extractBOBMessages([bobMessages[0]]).first.toString(),
          equals(
            Transaction(
              type: TransactionType.credited,
              transactionAmount: '30',
              finalAmount: '92.1',
              accountNumber: 'BoB XX7544',
              body: bobMessages[0],
              dateTime: DateTime.parse('2023-08-09 22:40:20'),
            ).toString(),
          ),
        ),
      );

      test(
        'withdrawn',
        () => expect(
          extractBOBMessages([bobMessages[1]]).first.toString(),
          equals(
            Transaction(
              type: TransactionType.withdrawn,
              transactionAmount: '5500',
              finalAmount: '496.1',
              accountNumber: 'BoB XX7544',
              body: bobMessages[1],
              dateTime: DateTime.parse('2023-11-29 16:48:04'),
            ).toString(),
          ),
        ),
      );

      test(
        'transferred',
        () => expect(
          extractBOBMessages([bobMessages[2]]).first.toString(),
          equals(
            Transaction(
              type: TransactionType.transferred,
              transactionAmount: '20',
              finalAmount: '3352.1',
              accountNumber: 'BoB XX7544',
              body: bobMessages[2],
              dateTime: DateTime.parse('2023-10-31 21:19:22'),
            ).toString(),
          ),
        ),
      );
    },
  );

  group(
    'Axis Extract',
    () {
      test(
        'credited',
        () => expect(
          extractAxisMessages([axisMessages[0]]).first.toString(),
          equals(
            Transaction(
              type: TransactionType.credited,
              transactionAmount: '42476.00',
              finalAmount: '65789.44',
              accountNumber: 'Axis XX5237',
              body: axisMessages[0],
              dateTime: DateTime.parse('2023-08-30 05:31:41'),
            ).toString(),
          ),
        ),
      );

      test(
        'Debit ATM-WDL/',
        () => expect(
          extractAxisMessages([axisMessages[1]]).first.toString(),
          equals(
            Transaction(
              type: TransactionType.withdrawn,
              transactionAmount: '5000.00',
              finalAmount: '4384.44',
              accountNumber: 'Axis XX5237',
              body: axisMessages[1],
              dateTime: DateTime.parse('2023-08-31 19:15:15'),
            ).toString(),
          ),
        ),
      );

      test(
        'Debit UPI/',
        () => expect(
          extractAxisMessages([axisMessages[2]]).first.toString(),
          equals(
            Transaction(
              type: TransactionType.transferred,
              transactionAmount: '435.00',
              finalAmount: null,
              accountNumber: 'Axis XX5237',
              body: axisMessages[2],
              dateTime: DateTime.parse('2023-09-20 16:47:23'),
            ).toString(),
          ),
        ),
      );
    },
  );
}
