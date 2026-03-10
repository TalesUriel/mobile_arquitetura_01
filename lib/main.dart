import 'package:flutter/material.dart';
import 'core/network/http_client.dart';
import 'data/datasources/product_cache_datasource.dart';
import 'data/datasources/product_remote_datasource.dart';
import 'data/repositories/product_repository_impl.dart';
import 'presentation/pages/product_page.dart';
import 'presentation/viewmodels/product_viewmodel.dart';

void main() {
  final httpClient = HttpClient();
  final remoteDatasource = ProductRemoteDatasource(httpClient);
  final cacheDatasource = ProductCacheDatasource();
  final repository = ProductRepositoryImpl(remoteDatasource, cacheDatasource);
  final viewModel = ProductViewModel(repository);

  runApp(MyApp(viewModel: viewModel));
}

class MyApp extends StatelessWidget {
  final ProductViewModel viewModel;
  const MyApp({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Produtos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: ProductPage(viewModel: viewModel),
    );
  }
}
