

extension NonNullJsonMap on Map<String, dynamic> {
  /// Removes all entries with null values from the map
  Map<String, dynamic> filterNulls() {
    removeWhere((key, value) => value == null);
    return this;
  }
}