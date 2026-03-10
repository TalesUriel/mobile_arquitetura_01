# mobile_arquitetura_01

Aplicação Flutter — Atividades 04 e 05 — Desenvolvimento de Dispositivos Móveis II.

## Funcionalidades

- Consome a [Fake Store API](https://fakestoreapi.com/products)
- Lista produtos com imagem, título, categoria e preço
- Filtro por categoria
- Estado explícito da interface (loading / erro / sucesso)
- Cache local com fallback automático quando a API está indisponível
- Banner visual indicando dados offline
- Testes unitários do ViewModel e do CacheDatasource

## Como rodar

\\\ash
flutter pub get
flutter run
\\\

## Como rodar os testes

\\\ash
flutter test
\\\

## Arquitetura

\\\
lib/
├── core/
│   ├── errors/failure.dart
│   └── network/http_client.dart
├── domain/
│   ├── entities/product.dart
│   └── repositories/product_repository.dart
├── data/
│   ├── models/product_model.dart
│   ├── datasources/product_remote_datasource.dart
│   ├── datasources/product_cache_datasource.dart
│   └── repositories/product_repository_impl.dart
├── presentation/
│   ├── viewmodels/product_state.dart
│   ├── viewmodels/product_viewmodel.dart
│   └── pages/product_page.dart
└── main.dart
\\\

### Regra de dependência

\\\
presentation → domain
data         → domain
domain       → nenhuma camada
\\\

---

## Questionário de Reflexão — Atividade 05

### 1. Em qual camada foi implementado o cache? Por quê?

O cache foi implementado na **camada de dados**, como um datasource
(ProductCacheDatasource). Essa decisão é adequada porque a camada de
dados é responsável por decidir **como** os dados são obtidos e armazenados.
O domínio define apenas **o que** precisa via contrato do repositório, sem
saber se os dados vêm da rede ou do cache. Isso preserva a independência
do domínio e o baixo acoplamento entre camadas. Para uma solução persistente,
bastaria trocar a implementação por SharedPreferences ou SQLite sem alterar
nenhuma outra camada.

### 2. Por que o ViewModel não deve realizar chamadas HTTP diretamente?

O ViewModel pertence à camada de apresentação e deve apenas coordenar o
estado da interface e delegar operações ao domínio. Se fizesse chamadas HTTP
diretamente, estaria acoplado a detalhes de infraestrutura, tornando os
testes impossíveis sem acesso real à rede, dificultando a manutenção e
violando a separação de responsabilidades da arquitetura em camadas.

### 3. O que poderia acontecer se a interface acessasse o DataSource diretamente?

A interface passaria a depender de detalhes técnicos como Dio, HTTP e JSON.
Qualquer mudança no DataSource exigiria mudanças na UI. A lógica de cache,
retry e tratamento de erro ficaria espalhada na camada de apresentação,
tornando o código impossível de testar isoladamente e muito difícil de manter.

### 4. Como essa arquitetura facilitaria a substituição da API por banco de dados local?

Bastaria criar um novo datasource (ex: ProductLocalDatasource) e injetá-lo
no ProductRepositoryImpl no lugar do ProductRemoteDatasource. O contrato
do repositório permaneceria o mesmo, e nenhuma outra camada precisaria ser
alterada — o ViewModel, a UI e o domínio continuariam funcionando sem
nenhuma modificação.
