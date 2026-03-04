/// DTO (Data Transfer Object) que representa o formato JSON
/// retornado pela Fake Store API.
/// Separado da entidade de domínio para evitar que mudanças
/// na API afetem o núcleo da aplicação.
class ProductModel {
  final int id;
  final String title;
  final double price;
  final String image;
  final String category;
  final String description;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.category,
    required this.description,
  });

  /// Cria um [ProductModel] a partir de um mapa JSON.
  /// Realiza validação e tratamento de campos nulos ou mal formatados.
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Validação: id deve ser inteiro não nulo
    final id = json['id'];
    if (id == null || id is! int) {
      throw FormatException('Campo "id" inválido ou ausente: $id');
    }

    // Validação: title deve ser string não vazia
    final title = json['title'];
    if (title == null || title.toString().trim().isEmpty) {
      throw FormatException('Campo "title" inválido ou ausente');
    }

    // Validação: price deve ser numérico positivo
    final rawPrice = json['price'];
    if (rawPrice == null || rawPrice is! num || rawPrice <= 0) {
      throw FormatException('Campo "price" inválido ou ausente: $rawPrice');
    }

    // Validação: image deve ser string não vazia
    final image = json['image'];
    if (image == null || image.toString().trim().isEmpty) {
      throw FormatException('Campo "image" inválido ou ausente');
    }

    return ProductModel(
      id: id,
      title: title.toString(),
      price: rawPrice.toDouble(),
      image: image.toString(),
      category: json['category']?.toString() ?? 'sem categoria',
      description: json['description']?.toString() ?? '',
    );
  }

  /// Converte o modelo de volta para mapa JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'image': image,
        'category': category,
        'description': description,
      };
}
