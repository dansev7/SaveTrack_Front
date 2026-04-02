class ApiResult<T> {
  final bool isSuccess;
  final String? message;
  final T? data;

  ApiResult({
    required this.isSuccess,
    this.message,
    this.data,
  });

  factory ApiResult.fromJson(
    Map<String, dynamic> json, 
    T Function(Object? json) fromJsonT
  ) {
    return ApiResult<T>(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}