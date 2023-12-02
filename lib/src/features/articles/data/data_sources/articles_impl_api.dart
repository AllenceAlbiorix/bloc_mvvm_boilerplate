import 'package:dio/dio.dart';
import 'package:ny_times_app/src/core/network/error/dio_error_handler.dart';
import 'package:ny_times_app/src/core/network/error/exceptions.dart';
import 'package:ny_times_app/src/core/util/constant/network_constant.dart';
import 'package:ny_times_app/src/features/articles/data/data_sources/abstract_article_api.dart';
import 'package:ny_times_app/src/features/articles/data/entities/ny_times_article_response_model.dart';
import 'package:ny_times_app/src/features/articles/data/entities/article_model.dart';
import 'package:ny_times_app/src/features/articles/domain/usecases/articles_usecase.dart';

class ArticlesImplApi extends AbstractArticleApi {
  final Dio dio;

  CancelToken cancelToken = CancelToken();

  ArticlesImplApi(this.dio);

  // Articles Method
  @override
  Future<ApiResponse<List<ArticleModel>>> getArticles(
      ArticlesParams params) async {
    try {
      final result = (await dio.get(
        getArticlePath(params.period),
      ));
      if (result.data == null)
        throw ServerException("Unknown Error", result.statusCode);

      return ApiResponse.fromJson<List<ArticleModel>>(
          result.data, ArticleModel.fromJsonList);
    } on DioError catch (e) {
      if (e.type == DioErrorType.cancel) {
        throw CancelTokenException(handleDioError(e), e.response?.statusCode);
      } else {
        throw ServerException(handleDioError(e), e.response?.statusCode);
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString(), null);
    }
  }
}