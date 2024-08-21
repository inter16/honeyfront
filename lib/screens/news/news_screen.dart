import 'package:flutter/material.dart';
import 'package:front/theme/colors.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart'; // url_launcher 추가

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<Map<String, String>> newsList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    final url = 'https://www.yangbong.co.kr/';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      dom.Document document = html_parser.parse(response.body);
      final newsContainer = document.getElementById('skin-55');
      if (newsContainer != null) {
        final newsItems = newsContainer.getElementsByClassName('item');
        List<Map<String, String>> fetchedNews = [];
        const String baseUrl = 'https://www.yangbong.co.kr';

        for (var item in newsItems.take(10)) {
          final titleElement = item.querySelector('h2.auto-titles.size-17.line-4x2.auto-fontA');
          final linkElement = item.querySelector('a');
          final imageElement = item.querySelector('a > span.frame.height-120 > em.auto-images');

          String title = titleElement?.text ?? 'No title';
          String link = linkElement?.attributes['href'] != null
              ? '$baseUrl${linkElement!.attributes['href']}'
              : 'No link';

          String imageUrl = 'No image';
          if (imageElement != null) {
            String? styleAttribute = imageElement.attributes['style'];
            if (styleAttribute != null) {
              RegExp urlPattern = RegExp(r'background-image:url\((.*?)\)');
              Match? match = urlPattern.firstMatch(styleAttribute);
              if (match != null) {
                imageUrl = match.group(1) ?? 'No image';
              }
            }
          }

          String summary = 'No summary';
          if (link != 'No link') {
            final summaryResponse = await http.get(Uri.parse(link));
            if (summaryResponse.statusCode == 200) {
              dom.Document summaryDocument = html_parser.parse(summaryResponse.body);
              final summaryElement = summaryDocument.querySelector('p');
              summary = summaryElement?.text ?? 'No summary';
            }
          }

          // summary를 30자로 자르고, 더 길 경우 "..."을 붙임
          if (summary.length > 30) {
            summary = '${summary.substring(0, 30)}...';
          }

          fetchedNews.add({
            'title': title,
            'link': link,
            'imageUrl': imageUrl,
            'summary': summary,
          });
        }

        setState(() {
          newsList = fetchedNews;
          isLoading = false;
        });
      }
    } else {
      print('Failed to load the page');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yelloMyStyle2,
      appBar: AppBar(
        backgroundColor: yelloMyStyle2,
        title: const Text(
          '양봉 뉴스',
          style: TextStyle(
            fontSize: 24.0,
            fontFamily: 'PretendardBold',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                '한국양봉신문 - 많이 본 뉴스',
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'PretendardSemiBold',
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: newsList.length,
                itemBuilder: (context, index) {
                  final news = newsList[index];
                  return InkWell(
                    onTap: () {
                      print(news['link']);
                      if (news['link'] != null && news['link'] != 'No link') {

                      }
                    },
                    child: Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Image.network(
                                  news['imageUrl']!,
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey,
                                      height: 200,
                                      child: const Center(child: Text('No Image')),
                                    );
                                  },
                                ),
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: Container(
                                    padding: const EdgeInsets.all(4.0),
                                    color: Colors.black54,
                                    child: Text(
                                      '${(index + 1).toString().padLeft(2, '0')}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              news['title']!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              news['summary']!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
