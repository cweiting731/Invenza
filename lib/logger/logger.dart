import 'package:logger/logger.dart';

Logger get log => _logger;

final Logger _logger = Logger(
  printer: PrettyPrinter(
    dateTimeFormat: DateTimeFormat.dateAndTime,
  ),
);