import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tutorial/article.dart';
import 'package:flutter_testing_tutorial/news_change_notifier.dart';
import 'package:flutter_testing_tutorial/news_service.dart';
import 'package:mocktail/mocktail.dart';

// class BadMockNewsServices implements NewsService {
//   bool getArticleCalled = false;
//   @override
//   Future<List<Article>> getArticles() async {
//     getArticleCalled = true;

//     return [
//        Article(title: "Test 1", content: "Test 1 content"),
//       Article(title: "Test 2", content: "Test 2 content"),
//       Article(title: "Test 3", content: "Test 3 content"),
//     ];
//   }
// }

class MockNewsServices extends Mock implements NewsService {}

void main() {
  late NewsChangeNotifier sut;
  late MockNewsServices mockNewsService;

  setUp((() {
    mockNewsService = MockNewsServices();
    sut = NewsChangeNotifier(mockNewsService);
  }));
  test("initial value are correct", () {
    expect(sut.articles, []);
    expect(sut.isLoading, false);
  });
  group("get articles", (() {
    final getArticleServices = [
      Article(title: "Test 1", content: "Test 1 content"),
      Article(title: "Test 2", content: "Test 2 content"),
      Article(title: "Test 3", content: "Test 3 content"),
    ];
    void arrangeNewsServicesReturns3Articles() {
      when(() => mockNewsService.getArticles())
          .thenAnswer((_) async => getArticleServices);
    }

    test("get article using news services", () async {
      arrangeNewsServicesReturns3Articles();
      await sut.getArticles();
      verify(() => mockNewsService.getArticles()).called(1);
    });
    test(
        '''indicates loading of data, set article o one from the service, indicates the data is not be load''',
        (() async {
      arrangeNewsServicesReturns3Articles();
      final future = sut.getArticles();
      expect(sut.isLoading, true);
      await future;
      expect(sut.articles, getArticleServices);
      expect(sut.isLoading, false);
    }));
  }));
}
