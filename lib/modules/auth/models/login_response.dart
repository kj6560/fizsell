class Response<T> {
  int statusCode;
  String message;
  T data;

  Response({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson(Object Function(T) toJsonT) {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': toJsonT(data),
    };
  }
}
