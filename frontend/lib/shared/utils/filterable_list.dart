import 'package:flutter/foundation.dart';

enum SortDirection { ascending, descending }

class FilterableList<T> extends ChangeNotifier {
  List<T> _allItems = [];
  List<T> _filteredItems = [];
  String _searchQuery = '';
  final Set<String> _activeFilters = {};
  String? Function(T, String)? _searchFn;
  String? Function(T)? _filterKeyFn;

  List<T> get items => _filteredItems;
  List<T> get allItems => _allItems;
  String get searchQuery => _searchQuery;
  Set<String> get activeFilters => _activeFilters;

  void setItems(List<T> items) {
    _allItems = items;
    _applyFilters();
  }

  void configureSearch(String? Function(T, String) searchFn) {
    _searchFn = searchFn;
  }

  void configureFilter(String? Function(T) filterKeyFn) {
    _filterKeyFn = filterKeyFn;
  }

  void setSearch(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  void toggleFilter(String filter) {
    if (_activeFilters.contains(filter)) {
      _activeFilters.remove(filter);
    } else {
      _activeFilters.add(filter);
    }
    _applyFilters();
  }

  void clearFilters() {
    _activeFilters.clear();
    _searchQuery = '';
    _applyFilters();
  }

  void sort(int Function(T, T) compareFn, {SortDirection direction = SortDirection.ascending}) {
    _filteredItems.sort(compareFn);
    if (direction == SortDirection.descending) {
      _filteredItems = _filteredItems.reversed.toList();
    }
    notifyListeners();
  }

  void _applyFilters() {
    var result = _allItems;

    if (_searchQuery.isNotEmpty && _searchFn != null) {
      result = result.where((item) {
        final searchable = _searchFn!(item, _searchQuery);
        return searchable?.toLowerCase().contains(_searchQuery) ?? false;
      }).toList();
    }

    if (_activeFilters.isNotEmpty && _filterKeyFn != null) {
      result = result.where((item) {
        final key = _filterKeyFn!(item);
        return key != null && _activeFilters.contains(key);
      }).toList();
    }

    _filteredItems = result;
    notifyListeners();
  }
}