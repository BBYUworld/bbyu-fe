import 'package:dio/dio.dart';
import 'package:gagyebbyu_fe/storage/TokenStorage.dart';
import 'package:flutter/material.dart';
import '../views/login/login_view.dart';
import '../services/navigation_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  final NavigationService _navigationService;

  late Dio _dio;
  final TokenStorage _tokenStorage = TokenStorage();

  ApiService._internal() : _navigationService = NavigationService() {
    _dio = Dio(BaseOptions(
      baseUrl: 'http://10.0.2.2:8080',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 3),
    ));
    _dio.interceptors.add(TokenInterceptor(_tokenStorage, _dio, _navigationService));
  }

  Future<Response> get(String path) async {
    return await _dio.get(path);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }

// 다른 HTTP 메서드들도 필요에 따라 추가...
}


class TokenInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final Dio _dio;
  final NavigationService _navigationService;

  TokenInterceptor(this._tokenStorage, this._dio, this._navigationService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    String? accessToken = await _tokenStorage.getAccessToken();
    options.headers['Authorization'] = 'Bearer $accessToken';
    return handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // AccessToken이 만료된 경우
      if (await _refreshToken()) {
        // 토큰 갱신 성공, 원래 요청 재시도
        return handler.resolve(await _retry(err.requestOptions));
      } else {
        // 토큰 갱신 실패, 로그인 화면으로 이동
        _navigateToLogin();
      }
    }
    return handler.next(err);
  }

  Future<bool> _refreshToken() async {
    try {
      String? refreshToken = await _tokenStorage.getRefreshToken();
      final response = await _dio.post(
        '/auth/refresh',
        options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
      );
      if (response.statusCode == 200) {
        String newAccessToken = response.data['accessToken'];
        await _tokenStorage.saveTokens(newAccessToken, refreshToken!);
        return true;
      }
    } catch (e) {
      print('Token refresh failed: $e');
    }
    return false;
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  void _navigateToLogin() {
    _navigationService.navigateToReplacement(LoginView());
  }
}
