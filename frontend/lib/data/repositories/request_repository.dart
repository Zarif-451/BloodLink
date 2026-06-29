import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/data/models/blood_request.dart';
import 'package:frontend/data/models/public_request_submission.dart';

abstract class RequestRepository {
  Future<List<BloodRequest>> getRequests({
    RequestStatus? status,
    Urgency? urgency,
    BloodGroup? bloodGroup,
    bool openOnly = false,
  });
  Future<BloodRequest?> getRequest(int id);
  Future<BloodRequest> approveRequest(int id);
  Future<BloodRequest> rejectRequest(int id, {required String reason});
  Future<BloodRequest> updateStatus(int id, RequestStatus status);
  Future<BloodRequest> createPublicRequest(PublicRequestSubmission submission);
  Future<BloodRequest?> trackRequest({
    required String requestIdInput,
    required String phone,
  });
  Future<Requester?> getRequester(int id);
}
