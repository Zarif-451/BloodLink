import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/data/mock/mock_data.dart';
import 'package:frontend/data/models/blood_request.dart';
import 'package:frontend/data/models/public_request_submission.dart';
import 'package:frontend/data/repositories/request_repository.dart';

class MockRequestRepository implements RequestRepository {
  int _nextRequesterId = 100;
  int _nextRequestId = 2000;

  MockRequestRepository() {
    if (MockData.requesters.isNotEmpty) {
      _nextRequesterId =
          MockData.requesters.map((r) => r.id).reduce((a, b) => a > b ? a : b) +
              1;
    }
    if (MockData.requests.isNotEmpty) {
      _nextRequestId =
          MockData.requests.map((r) => r.id).reduce((a, b) => a > b ? a : b) + 1;
    }
  }

  static String _normalizePhone(String phone) =>
      phone.replaceAll(RegExp(r'\D'), '');

  static int _urgencyRank(Urgency u) => switch (u) {
        Urgency.critical => 0,
        Urgency.urgent => 1,
        Urgency.normal => 2,
      };

  static int _statusRank(RequestStatus s) => switch (s) {
        RequestStatus.pending => 0,
        RequestStatus.approved => 1,
        _ => 2,
      };

  @override
  Future<BloodRequest> approveRequest(int id) async {
    return updateStatus(id, RequestStatus.approved);
  }

  @override
  Future<BloodRequest> createPublicRequest(
    PublicRequestSubmission submission,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final requesterId = _nextRequesterId++;
    final requester = Requester(
      id: requesterId,
      type: submission.requesterType,
      name: submission.name,
      street: submission.street,
      area: submission.area,
      city: submission.city,
      phones: submission.phones,
    );
    MockData.requesters.add(requester);

    final created = BloodRequest(
      id: _nextRequestId++,
      requesterId: requesterId,
      bloodGroup: submission.bloodGroup,
      quantity: submission.quantity,
      urgency: submission.urgency,
      requestDate: DateTime.now(),
      status: RequestStatus.pending,
      requesterName: submission.name,
    );
    MockData.requests.insert(0, created);
    return created;
  }

  @override
  Future<BloodRequest?> getRequest(int id) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    try {
      return MockData.requests.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Requester?> getRequester(int id) async {
    try {
      return MockData.requesters.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<BloodRequest>> getRequests({
    RequestStatus? status,
    Urgency? urgency,
    BloodGroup? bloodGroup,
    bool openOnly = false,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    var list = MockData.requests.where((r) {
      if (status != null && r.status != status) return false;
      if (urgency != null && r.urgency != urgency) return false;
      if (bloodGroup != null && r.bloodGroup != bloodGroup) return false;
      if (openOnly &&
          (r.status == RequestStatus.fulfilled ||
              r.status == RequestStatus.rejected ||
              r.status == RequestStatus.cancelled)) {
        return false;
      }
      return true;
    }).toList();

    list.sort((a, b) {
      final u = _urgencyRank(a.urgency).compareTo(_urgencyRank(b.urgency));
      if (u != 0) return u;
      final s = _statusRank(a.status).compareTo(_statusRank(b.status));
      if (s != 0) return s;
      return a.requestDate.compareTo(b.requestDate);
    });
    return list;
  }

  @override
  Future<BloodRequest> rejectRequest(int id, {required String reason}) async {
    final i = MockData.requests.indexWhere((r) => r.id == id);
    if (i < 0) throw StateError('Request not found');
    MockData.requests[i] = MockData.requests[i].copyWith(
      status: RequestStatus.rejected,
      rejectReason: reason,
    );
    return MockData.requests[i];
  }

  @override
  Future<BloodRequest?> trackRequest({
    required String requestIdInput,
    required String phone,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final id = PublicRequestId.parse(requestIdInput);
    if (id == null) return null;

    final request = await getRequest(id);
    if (request == null) return null;

    final requester = await getRequester(request.requesterId);
    if (requester == null) return null;

    final normalized = _normalizePhone(phone);
    final matches = requester.phones.any(
      (p) => _normalizePhone(p) == normalized,
    );
    if (!matches) return null;
    return request;
  }

  @override
  Future<BloodRequest> updateStatus(int id, RequestStatus status) async {
    final i = MockData.requests.indexWhere((r) => r.id == id);
    if (i < 0) throw StateError('Request not found');
    MockData.requests[i] = MockData.requests[i].copyWith(
      status: status,
      clearRejectReason: status != RequestStatus.rejected,
    );
    return MockData.requests[i];
  }
}
