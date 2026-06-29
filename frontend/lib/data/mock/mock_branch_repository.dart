import 'package:frontend/data/mock/mock_data.dart';
import 'package:frontend/data/models/branch.dart';
import 'package:frontend/data/repositories/branch_repository.dart';

class MockBranchRepository implements BranchRepository {
  int _nextId = 100;

  MockBranchRepository() {
    if (MockData.branches.isNotEmpty) {
      _nextId =
          MockData.branches.map((b) => b.id).reduce((a, b) => a > b ? a : b) +
              1;
    }
  }

  @override
  Future<Branch> createBranch(Branch branch) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final created = branch.copyWith(id: _nextId++);
    MockData.branches.add(created);
    return created;
  }

  @override
  Future<List<Branch>> getBranches() async => List.of(MockData.branches);

  @override
  Future<Branch?> getBranch(int id) async {
    try {
      return MockData.branches.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Branch> updateBranch(Branch branch) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final i = MockData.branches.indexWhere((b) => b.id == branch.id);
    if (i < 0) throw StateError('Branch not found');
    MockData.branches[i] = branch;
    return branch;
  }
}
