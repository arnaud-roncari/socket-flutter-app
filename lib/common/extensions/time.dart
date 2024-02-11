extension TimeExtension on DateTime {
  String getWeekday() {
    switch (weekday) {
      case 1:
        return "Lundi";
      case 2:
        return "Mardi";
      case 3:
        return "Mercredi";
      case 4:
        return "Jeudi";
      case 5:
        return "Vendredi";
      case 6:
        return "Samedi";
      case 7:
        return "Dimanche";
    }
    return "NA";
  }

  String getTime() {
    return "${toLocal().hour}:${toLocal().minute}";
  }

  String getWTime() {
    return "${getWeekday()} ${getTime()}";
  }
}
