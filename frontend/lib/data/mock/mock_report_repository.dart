import 'package:frontend/data/mock/mock_data.dart';
import 'package:frontend/data/models/report.dart';
import 'package:frontend/data/repositories/report_repository.dart';

class MockReportRepository implements ReportRepository {
  int _nextId = 10;

  @override
  Future<Report> generateReport({
    required int userId,
    required String title,
  }) async {
    final report = Report(
      id: _nextId++,
      generatedByUserId: userId,
      generatedOn: DateTime.now(),
      title: title,
      summary: 'Generated mock report',
    );
    MockData.reports.insert(0, report);
    return report;
  }

  @override
  Future<List<Report>> getReports({int? userId}) async {
    if (userId == null) return List.of(MockData.reports);
    return MockData.reports.where((r) => r.generatedByUserId == userId).toList();
  }
}
