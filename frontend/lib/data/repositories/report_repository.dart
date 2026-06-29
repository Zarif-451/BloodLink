import 'package:frontend/data/models/report.dart';

abstract class ReportRepository {
  Future<List<Report>> getReports({int? userId});
  Future<Report> generateReport({required int userId, required String title});
}
