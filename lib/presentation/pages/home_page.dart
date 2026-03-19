import 'package:flutter/material.dart';
import '../../data/datasources/product_cache_datasource.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../core/network/http_client.dart';
import '../viewmodels/product_viewmodel.dart';
import 'product_page.dart';

/// Tela inicial da aplicação.
/// Serve como ponto de entrada e direciona o usuário para a listagem.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.indigo.shade700,
              Colors.indigo.shade400,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.storefront, size: 100, color: Colors.white),
                  const SizedBox(height: 24),
                  const Text(
                    'Fake Store',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Explore nossos produtos',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Cria dependências e navega para a tela de produtos
                        final viewModel = ProductViewModel(
                          ProductRepositoryImpl(
                            ProductRemoteDatasource(HttpClient()),
                            ProductCacheDatasource(),
                          ),
                        );
                        // Navigator.push() empurra a tela de produtos na pilha
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductPage(viewModel: viewModel),
                          ),
                        );
                      },
                      icon: const Icon(Icons.shopping_bag),
                      label: const Text(
                        'Ver Produtos',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
