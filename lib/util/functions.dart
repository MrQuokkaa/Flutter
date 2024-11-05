import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Functions {
  String dateDay = DateFormat('EEEE').format(DateTime.now());
  Future<void> OpenDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Welcome back Stefan!'),
          content: Text('It\'s ' +
              dateDay +
              '\n'
                  'Do you have your usual plans today?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  checkDay() {
    //check for current day -> int -> save to DB
    final weekDay = DateTime.now();
    print(weekDay.weekday);
  }
}
