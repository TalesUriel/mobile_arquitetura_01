import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_arquitetura_01/data/datasources/product_cache_datasource.dart';
import 'package:mobile_arquitetura_01/data/models/product_model.dart';
import 'package:mobile_arquitetura_01/domain/entities/product.dart';
import 'package:mobile_arquitetura_01/domain/repositories/product_repository.dart';
import 'package:mobile_arquitetura_01/presentation/viewmodels/product_viewmodel.dart';

class FakeSuccessRepository implements ProductRepository {
  @override
  Future<List<Product>> getProducts() async => [
        const Product(id: 1, title: 'Produto A', price: 10.0,
            image: 'https://i.pravatar.cc/80', category: 'electronics', description: ''),
        const Product(id: 2, title: 'Produto B', price: 20.0,
            image: 'https://i.pravatar.cc/80', category: 'jewelery', description: ''),
        const Product(id: 3, title: 'Produto C', price: 30.0,
            image: 'https://i.pravatar.cc/80', category: 'electronics', description: ''),
      ];
}

class FakeFailRepository implements ProductRepository {
  @override
  Future<List<Product>> getProducts() async =>
      throw Exception('Sem conexão simulada');
}

void main() {
  group('ProductViewModel', () {
    test('carrega produtos com sucesso', () async {
      final vm = ProductViewModel(FakeSuccessRepository());
      await vm.loadProducts();
      expect(vm.state.value.products.length, 3);
      expect(vm.state.value.isLoading, false);
      expect(vm.state.value.error, null);
    });

    test('registra erro quando API falha', () async {
      final vm = ProductViewModel(FakeFailRepository());
      await vm.loadProducts();
      expect(vm.state.value.error, isNotNull);
      expect(vm.state.value.isLoading, false);
    });

    test('filtra por categoria corretamente', () async {
      final vm = ProductViewModel(FakeSuccessRepository());
      await vm.loadProducts();
      vm.filterByCategory('electronics');
      expect(vm.state.value.filtered.length, 2);
      expect(vm.state.value.selectedCategory, 'electronics');
    });

    test('remove filtro ao passar null', () async {
      final vm = ProductViewModel(FakeSuccessRepository());
      await vm.loadProducts();
      vm.filterByCategory('electronics');
      vm.filterByCategory(null);
      expect(vm.state.value.filtered.length, 3);
      expect(vm.state.value.selectedCategory, null);
    });

    test('retorna categorias unicas ordenadas', () async {
      final vm = ProductViewModel(FakeSuccessRepository());
      await vm.loadProducts();
      expect(vm.categories, ['electronics', 'jewelery']);
    });
  });

  group('ProductCacheDatasource', () {
    test('comeca sem dados em cache', () {
      final cache = ProductCacheDatasource();
      expect(cache.hasData, false);
      expect(cache.get(), null);
    });

    test('salva e recupera dados corretamente', () {
      final cache = ProductCacheDatasource();
      final models = [
        ProductModel(id: 1, title: 'A', price: 9.99,
            image: 'x', category: 'cat', description: ''),
      ];
      cache.save(models);
      expect(cache.hasData, true);
      expect(cache.get()!.first.title, 'A');
    });

    test('limpa o cache corretamente', () {
      final cache = ProductCacheDatasource();
      cache.save([ProductModel(id: 1, title: 'A', price: 1.0,
          image: 'x', category: 'c', description: '')]);
      cache.clear();
      expect(cache.hasData, false);
    });
  });
}
