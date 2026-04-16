import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../viewmodels/product_viewmodel.dart';

class ProductFormPage extends StatefulWidget {
  final ProductViewModel viewModel;
  final Product? product;
  const ProductFormPage({super.key, required this.viewModel, this.product});

  @override
  State<ProductFormPage> createState() => _State();
}

class _State extends State<ProductFormPage> {
  final _key = GlobalKey<FormState>();
  bool _saving = false;
  late final _title = TextEditingController(text: widget.product?.title ?? '');
  late final _price = TextEditingController(text: widget.product != null ? '${widget.product!.price}' : '');
  late final _desc = TextEditingController(text: widget.product?.description ?? '');
  late final _cat = TextEditingController(text: widget.product?.category ?? '');
  late final _img = TextEditingController(text: widget.product?.image ?? '');

  bool get _editing => widget.product != null;

  @override
  void dispose() {
    for (final c in [_title, _price, _desc, _cat, _img]) c.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_key.currentState!.validate()) return;
    setState(() => _saving = true);
    final p = Product(
      id: widget.product?.id ?? 0,
      title: _title.text.trim(),
      price: double.parse(_price.text.trim()),
      description: _desc.text.trim(),
      category: _cat.text.trim(),
      image: _img.text.trim().isEmpty
          ? 'https://fakestoreapi.com/img/81fAn1cxK+L._AC_UY879_.jpg'
          : _img.text.trim(),
    );
    final ok = _editing
        ? await widget.viewModel.updateProduct(p)
        : await widget.viewModel.addProduct(p);
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_editing ? 'Produto atualizado!' : 'Produto criado!'),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context);
    }
  }

  Widget _field(TextEditingController c, String label, {TextInputType? type, int lines = 1, String? Function(String?)? val}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: c,
        keyboardType: type,
        maxLines: lines,
        validator: val ?? (v) => v == null || v.trim().isEmpty ? 'Campo obrigatório' : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editing ? 'Editar Produto' : 'Novo Produto'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _key,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            _field(_title, 'Título'),
            _field(_price, 'Preço', type: const TextInputType.numberWithOptions(decimal: true), val: (v) {
              if (v == null || v.trim().isEmpty) return 'Campo obrigatório';
              if (double.tryParse(v.trim()) == null) return 'Preço inválido';
              return null;
            }),
            _field(_cat, 'Categoria'),
            _field(_desc, 'Descrição', lines: 3),
            _field(_img, 'URL da imagem (opcional)', val: (_) => null),
            ElevatedButton.icon(
              onPressed: _saving ? null : _submit,
              icon: _saving
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : Icon(_editing ? Icons.save : Icons.add),
              label: Text(_saving ? 'Salvando...' : (_editing ? 'Salvar' : 'Criar')),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
