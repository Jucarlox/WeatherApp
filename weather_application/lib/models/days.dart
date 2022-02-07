//.add(const Duration(days: 1))

class Days {
  Days({required this.day});
  DateTime day;
}

final listaDias = [
  Days(day: DateTime.now()),
  Days(day: DateTime.now().add(const Duration(days: 1))),
  Days(day: DateTime.now().add(const Duration(days: 2))),
  Days(day: DateTime.now().add(const Duration(days: 3))),
  Days(day: DateTime.now().add(const Duration(days: 4))),
  Days(day: DateTime.now().add(const Duration(days: 5))),
  Days(day: DateTime.now().add(const Duration(days: 6))),
  Days(day: DateTime.now().add(const Duration(days: 7))),
];
