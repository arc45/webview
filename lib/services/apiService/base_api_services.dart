abstract class BaseApiService {
  Future<dynamic> getGetApiResponse(
      {required String url, Map<String, dynamic>? headers});

  Future<dynamic> getPostApiResponse(String url, dynamic data);

  Future<dynamic> getPutApiResponse(String url, dynamic data);

  Future<dynamic> getPatchApiResponse(String url, dynamic data);

  Future<dynamic> getDeleteApiResponse(String url, dynamic data);
}
