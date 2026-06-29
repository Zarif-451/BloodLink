abstract final class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const forgotPassword = '/forgot-password';

  // Staff shell
  static const staffHome = '/staff';
  static const staffDonors = '/staff/donors';
  static const staffInventory = '/staff/inventory';
  static const staffRequests = '/staff/requests';
  static const staffMore = '/staff/more';

  // Staff donors (nested / full-screen)
  static const staffDonorRegister = '/staff/donors/register';
  static String staffDonorDetail(String nationalId) => '/staff/donors/$nationalId';
  static String staffDonorEdit(String nationalId) =>
      '/staff/donors/$nationalId/edit';
  static String staffDonorHistory(String nationalId) =>
      '/staff/donors/$nationalId/history';

  // Staff donations
  static const staffSelectDonor = '/staff/donations/select';
  static const staffRecordDonation = '/staff/donations/new';
  static String staffDonationDetail(int id) => '/staff/donations/$id';
  static String staffScreening(int donationId) =>
      '/staff/donations/$donationId/screening';

  // Staff inventory (nested / full-screen)
  static const staffInventoryAdd = '/staff/inventory/add';
  static String staffInventoryDetail(int id) => '/staff/inventory/$id';

  // Staff requests (nested / full-screen)
  static String staffRequestDetail(int id) => '/staff/requests/$id';
  static String staffAllocate(int requestId, {int? branchId}) {
    final base = '/staff/requests/$requestId/allocate';
    if (branchId != null) return '$base?branchId=$branchId';
    return base;
  }

  // Staff transports
  static const staffTransports = '/staff/transports';
  static const staffTransportNew = '/staff/transports/new';
  static String staffTransportDetail(int id) => '/staff/transports/$id';

  // Admin shell
  static const adminHome = '/admin';
  static const adminOperations = '/admin/operations';
  static const adminReports = '/admin/reports';
  static const adminSettings = '/admin/settings';

  // Superadmin shell
  static const superadminHome = '/superadmin';
  static const superadminOperations = '/superadmin/operations';
  static const superadminBranches = '/superadmin/branches';
  static const superadminUsers = '/superadmin/users';
  static const superadminInventory = '/superadmin/inventory';
  static const superadminRequests = '/superadmin/requests';
  static const superadminReports = '/superadmin/reports';
  static const superadminTransports = '/superadmin/transports';

  static const superadminBranchNew = '/superadmin/branches/new';
  static String superadminBranchEdit(int id) => '/superadmin/branches/$id/edit';
  static const superadminUserNew = '/superadmin/users/new';
  static String superadminUserEdit(int id) => '/superadmin/users/$id/edit';
  static String superadminBranchInventory(int branchId) =>
      '/superadmin/inventory/$branchId';

  static const publicRequest = '/public/request';
  static const publicRequestSuccess = '/public/request/success';
  static const publicTrack = '/public/track';
  static String publicTrackById(String id) => '/public/track/$id';
  static String publicPayment(int paymentId) => '/public/payment/$paymentId';

  static const devTheme = '/dev/theme';

  static const staffBranchHotline = '01700000001';
}
