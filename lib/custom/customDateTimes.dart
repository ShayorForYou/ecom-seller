

import 'package:intl/intl.dart';

class CustomDateTime{
  static String getDate = DateFormat('MMMM d, y').format(DateTime.now());
  static String getDayName = DateFormat('EEEE').format(DateTime.now());
  static String getLast7Date = DateFormat('EEEE').format(DateTime.now());


}