import 'package:intl/intl.dart';

class GetTimeDate {
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('dd-MM-yyyy h:mma');
  String currentDateFormatter() {
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  String currentTimeDate() {
    String date = formatter.format(now);
    String time = DateFormat.jm().format(now);
    String currentDateTime = "${date}_$time";
    return currentDateTime;
  }
}
