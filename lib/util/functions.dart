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

  appBarDate() {
    final d = DateTime.now();
    var dayOfMonth = d.day;
    String dateFull = DateFormat('EEEE, MMMM d').format(DateTime.now());
    return dayOfMonth == 1 || dayOfMonth == 21 || dayOfMonth == 31
        ? Text(dateFull + 'st')
        : dayOfMonth == 2 || dayOfMonth == 22
            ? Text(dateFull + 'nd')
            : dayOfMonth == 3 || dayOfMonth == 23
                ? Text(dateFull + 'rd')
                : Text(dateFull + 'th');
  }

  checkDay() {
    //check for current day -> int -> save to DB
    final weekDay = DateTime.now();
    print(weekDay.weekday);
  }
}
