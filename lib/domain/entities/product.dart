/// Entidade de domínio que representa um produto.
/// Esta classe pertence exclusivamente à camada de domínio
/// e não possui dependência de frameworks, APIs ou banco de dados.
class Product {
  final int id;
  final String title;
  final double price;
  final String image;
  final String category;
  final String description;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.category,
    required this.description,
  });
}
