/// Simple wrapper for the CSV string returned by the `exportCSV` action.
class ExportResultModel {
  /// The raw CSV content.
  final String csvContent;

  const ExportResultModel({required this.csvContent});

  factory ExportResultModel.fromApiResponse(Map<String, dynamic> json) {
    // The API may return the CSV as a 'data' field or as raw text.
    return ExportResultModel(
      csvContent: (json['data'] as String?) ?? (json['raw'] as String?) ?? '',
    );
  }
}
