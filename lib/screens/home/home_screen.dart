import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/colors.dart';

List<String> products = ['1번', '2번'];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: yelloMyStyle2,
        appBar: AppBar(
          backgroundColor: ClearMyStyle1,
          actions: [
            IconButton(
                onPressed: () => context.push('/register'),
                icon: Icon(
                  Icons.add,
                  color: yelloMyStyle1,
                  size: 42,
                )
            ),
          ],
        ),
        body: Center(
          child: products.isEmpty
              ? NoProductsWidget() // Widget to show if no products are registered
              : ProductsListWidget(), // Widget to show if products are available
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: yelloMyStyle1,
          child: Icon(Icons.history),
        )
      ),
    );
  }
}

class NoProductsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '등록된 카메라가 없습니다.',
          // '카메라를 등록해주세요.',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 24),
        Container(
          width: 160, height: 50,
          child: ElevatedButton(
            onPressed: () => context.push('/register'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
              ),
              backgroundColor: yelloMyStyle1,
              foregroundColor: blackMyStyle1,
              padding: EdgeInsets.symmetric(vertical: 8.0),
            ),
            child: const Text(
              '카메라 등록하기',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ProductsListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:32.0, vertical: 16.0),
      child: ListView.separated(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(products[index]),
            leading: Icon(Icons.camera_alt),
            onTap: () => context.push('/stream', extra: products[index]),
          );
        },
        separatorBuilder: (BuildContext context, int index) { return Divider(thickness: 1); },
      ),
    );
  }
}