import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_arquitetura_01/domain/entities/product.dart';
import 'package:mobile_arquitetura_01/domain/repositories/product_repository.dart';
import 'package:mobile_arquitetura_01/presentation/viewmodels/product_viewmodel.dart';

// Repositório fake para simular sucesso na requisição
class FakeProductRepository implements ProductRepository {
  @override
  Future<List<Product>> getProducts() async {
    return [
      const Product(
        id: 1,
        title: 'Produto A',
        price: 10.0,
        image: 'https://example.com/a.png',
        category: 'electronics',
        description: 'Desc A',
      ),
      const Product(
        id: 2,
        title: 'Produto B',
        price: 20.0,
        image: 'https://example.com/b.png',
        category: 'jewelery',
        description: 'Desc B',
      ),
      const Product(
        id: 3,
        title: 'Produto C',
        price: 30.0,
        image: 'https://example.com/c.png',
        category: 'electronics',
        description: 'Desc C',
      ),
    ];
  }
}

// Repositório fake para simular falha na requisição
class FailingProductRepository implements ProductRepository {
  @override
  Future<List<Product>> getProducts() async {
    throw Exception('Falha de conexão simulada');
  }
}

void main() {
  group('ProductViewModel', () {
    test('deve carregar produtos com sucesso', () async {
      final viewModel = ProductViewModel(FakeProductRepository());

      await viewModel.loadProducts();

      expect(viewModel.state.value.isLoading, false);
      expect(viewModel.state.value.error, null);
      expect(viewModel.state.value.products.length, 3);
    });

    test('deve atualizar estado de loading durante carregamento', () async {
      final viewModel = ProductViewModel(FakeProductRepository());

      // Inicia carregamento sem aguardar
      final future = viewModel.loadProducts();
      expect(viewModel.state.value.isLoading, true);

      await future;
      expect(viewModel.state.value.isLoading, false);
    });

    test('deve registrar erro quando repositório falha', () async {
      final viewModel = ProductViewModel(FailingProductRepository());

      await viewModel.loadProducts();

      expect(viewModel.state.value.isLoading, false);
      expect(viewModel.state.value.error, isNotNull);
      expect(viewModel.state.value.products, isEmpty);
    });

    test('deve filtrar produtos por categoria corretamente', () async {
      final viewModel = ProductViewModel(FakeProductRepository());
      await viewModel.loadProducts();

      viewModel.filterByCategory('electronics');

      expect(viewModel.state.value.filtered.length, 2);
      expect(viewModel.state.value.selectedCategory, 'electronics');
    });

    test('deve remover filtro ao selecionar null', () async {
      final viewModel = ProductViewModel(FakeProductRepository());
      await viewModel.loadProducts();

      viewModel.filterByCategory('electronics');
      viewModel.filterByCategory(null);

      expect(viewModel.state.value.filtered.length, 3);
      expect(viewModel.state.value.selectedCategory, null);
    });

    test('deve retornar lista de categorias únicas', () async {
      final viewModel = ProductViewModel(FakeProductRepository());
      await viewModel.loadProducts();

      final categories = viewModel.categories;

      expect(categories.length, 2);
      expect(categories, containsAll(['electronics', 'jewelery']));
    });
  });
}
