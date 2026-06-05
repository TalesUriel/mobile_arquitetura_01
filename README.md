# mobile_arquitetura_01

Aplicação Flutter consolidada — Desenvolvimento de Dispositivos Móveis II.

Implementa autenticação com a [DummyJSON API](https://dummyjson.com), listagem e detalhes de produtos, controle de favoritos e fluxo completo de login/logout.

## Funcionalidades

- Tela de login com validação de campos obrigatórios
- Autenticação via POST `/auth/login` (DummyJSON)
- Sessão de usuário autenticado em memória
- Bloqueio de acesso à tela de produtos sem login
- Nome e foto do usuário exibidos no AppBar
- Listagem de produtos via GET `/products`
- Tela de detalhes via GET `/products/{id}`
- Controle de favoritos com atualização automática da interface
- Botão de logout com limpeza de sessão
- Botão para atualizar manualmente a lista de produtos
- Tratamento de carregamento e erros nas requisições

## Como rodar

```
flutter pub get
flutter run
```

## Credenciais de teste

```
Usuário: emilys
Senha:   emilyspass
```

## Estrutura do projeto

```
lib/
├── main.dart
├── models/
│   ├── auth_user.dart        # Modelo do usuário autenticado
│   └── product.dart          # Modelo de produto (DummyJSON)
├── services/
│   ├── auth_service.dart     # POST /auth/login
│   └── product_service.dart  # GET /products e /products/{id}
├── session/
│   └── session_controller.dart  # Singleton de sessão
└── pages/
    ├── login_page.dart           # Tela de login
    ├── product_page.dart         # Listagem com favoritos e logout
    └── product_detail_page.dart  # Detalhes do produto
```

## API utilizada

[DummyJSON](https://dummyjson.com) — API de testes com suporte a autenticação, usuários e produtos.

| Endpoint | Método | Uso |
|---|---|---|
| `/auth/login` | POST | Autenticação |
| `/products` | GET | Listagem de produtos |
| `/products/{id}` | GET | Detalhes do produto |
