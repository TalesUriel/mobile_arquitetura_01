# mobile_arquitetura_01

Aplicação Flutter desenvolvida como **Atividade 04** da disciplina Desenvolvimento de Dispositivos Móveis II.

## Evidência de funcionamento

![App funcionando](evidencia.png)

O app consome a [Fake Store API](https://fakestoreapi.com/products), exibe lista de produtos com imagem, título, categoria e preço, e permite filtrar por categoria.

## Como rodar

\\\ash
flutter pub get
flutter run
\\\

## Como rodar os testes

\\\ash
flutter test
\\\

## Arquitetura em Camadas

\\\
lib/
├── core/
│   ├── errors/failure.dart          # Estrutura de erro padronizada
│   └── network/http_client.dart     # Cliente HTTP centralizado (Dio)
├── domain/
│   ├── entities/product.dart        # Entidade de domínio
│   └── repositories/product_repository.dart  # Contrato do repositório
├── data/
│   ├── models/product_model.dart            # DTO com fromJson/toJson
│   ├── datasources/product_remote_datasource.dart  # Acesso à API
│   └── repositories/product_repository_impl.dart  # Implementação concreta
├── presentation/
│   ├── viewmodels/product_state.dart        # Estado imutável da tela
│   ├── viewmodels/product_viewmodel.dart    # Coordenação de ações
│   └── pages/product_page.dart             # Interface do usuário
└── main.dart                               # Composição de dependências
\\\

### Regra de dependência

\\\
presentation → domain
data         → domain
domain       → nenhuma camada
\\\

## Tecnologias

- Flutter 3.x / Dart 3.x
- [dio](https://pub.dev/packages/dio) — cliente HTTP
- [Fake Store API](https://fakestoreapi.com) — API pública de produtos
