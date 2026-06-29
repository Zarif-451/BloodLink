import 'package:frontend/data/models/branch.dart';

abstract class BranchRepository {
  Future<List<Branch>> getBranches();
  Future<Branch?> getBranch(int id);
  Future<Branch> createBranch(Branch branch);
  Future<Branch> updateBranch(Branch branch);
}
