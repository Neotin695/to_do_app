

enum Repeat {
  None,
  Daily,
  Weekly,
  Monthly,
}

class Task {
  int? id;
  String? title;
  String? note;
  String? startDate;
  String? endDate;

  int? remind;
  Repeat? repeat;
  int? color;
  int? isCompleted;

  int? get getId => this.id;

  set setId(int? id) => this.id = id;

  get getIsCompleted => this.isCompleted;

  set setIsCompleted(isCompleted) => this.isCompleted = isCompleted;

  get getColor => this.color;

  set setColor(color) => this.color = color;

  get getRemind => this.remind;

  set setRemind(remind) => this.remind = remind;

  get getTitle => this.title;

  set setTitle(title) => this.title = title;

  get getNote => this.note;

  set setNote(note) => this.note = note;

  get getStartDate => this.startDate;

  set setStartDate(startDate) => this.startDate = startDate;

  get getEndDate => this.endDate;

  set setEndDate(endDate) => this.endDate = endDate;

  get getRepeat => this.repeat;

  set setRepeat(repeat) => this.repeat = repeat;

  Task({
    this.id,
    this.isCompleted,
    this.color,
    this.remind,
    this.title,
    this.note,
    this.startDate,
    this.endDate,
    this.repeat,
  });

  static String toRepeats(Repeat repeat) {
    switch (repeat) {
      case Repeat.None:
        return 'None';
      case Repeat.Daily:
        return 'Daily';
      case Repeat.Weekly:
        return 'Weekly';
      case Repeat.Monthly:
        return 'Monthly';
    }
  }

  static Repeat fromRepeats(String value) {
    switch (value) {
      case 'Daily':
        return Repeat.Daily;
      case 'Weekly':
        return Repeat.Weekly;
      case 'Monthly':
        return Repeat.Monthly;
      default:
        return Repeat.None;
    }
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    result.addAll({'id': id});
    result.addAll({'title': title});
    result.addAll({'note': note});
    result.addAll({'startDate': startDate});
    result.addAll({'endDate': endDate});
    result.addAll({'remind': remind});
    result.addAll({'repeat': toRepeats(repeat!)});
    result.addAll({'color': color});
    result.addAll({'isCompleted': isCompleted});
    return result;
  }

  Task.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    isCompleted = map['isCompleted'];
    color = map['color'];
    remind = map['remind'];
    title = map['title'];
    note = map['note'];
    startDate = map['startDate'];
    endDate = map['endDate'];
    repeat = fromRepeats(map['repeat']);
  }
}
