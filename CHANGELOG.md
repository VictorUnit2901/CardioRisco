# Changelog

## [24/11/2026]

### Adicionado

- Enums de domínio `Sexo` e `NivelRisco` e a classe `ResultadoRisco`, com a classificação do risco pelas faixas do Escore de Risco Global da SBC (`lib/domain/models/`).
- Calculadora de risco cardiovascular em 10 anos pelo modelo de Framingham (2008), seguindo a interface `CalculadoraRisco` para permitir outros modelos de cálculo (`lib/domain/services/`).
- 11 testes automatizados do cálculo, da classificação do risco e da validação clínica (`test/domain/calculadora_framingham_test.dart`).
- Dependência `provider` para o gerenciamento de estado do app, como pede o aditivo da Unidade II.
- Formulário de avaliação em 2 etapas (Telas 1 e 2): 7 perguntas, validação por etapa, campos numéricos tolerantes a erros de digitação, código anônimo do paciente (sem nome ou CPF) e modo edição para avaliações já salvas (`lib/presentation/avaliacao/`).
- Salvamento automático do formulário em andamento: o rascunho fica salvo no aparelho e é retomado na mesma etapa se o app fechar no meio da visita (`FormularioAvaliacaoController`).
- 5 novos testes automatizados: validação por etapa e controlador do formulário (`test/presentation/formulario_avaliacao_controller_test.dart`).

### Alterado

- `AvaliacaoModel`: sexo passa a ser o enum `Sexo`, o resultado do risco passa a ser um objeto `ResultadoRisco`, e foram adicionados os métodos `estaCompleta()` e `validar()` (validações clínicas de idade, pressão arterial, colesterol total e HDL).
- `AvaliacaoModel.validar()` passa a aceitar a etapa (`validar(etapa: 1)` ou `validar(etapa: 2)`), para o formulário cobrar só as perguntas da etapa atual.

## [22/11/2026]

### Adicionado

- Implementação do `AuthService` com métodos de `login`, `cadastrar` e `logout` integrados ao Firebase Authentication e Cloud Firestore (coleção `profissionais`) e persistência local via `LocalStorageService`.
- Conexão da `AuthScreen` ao `AuthService` real (substituindo mocks locais anteriores), com tratamento de erros do Firebase Auth, indicador de carregamento durante a requisição e encerramento de sessão no logout.
- Validação do fluxo de cadastro e login em ambiente Web, refletindo automaticamente na criação/atualização de usuários no Firebase Authentication e de perfis no Firestore.

## [18/11/2026]

### Adicionado

- Diagrama de classes do domínio do CardioRisco (`documentos` / `diagramaClasses.md`), contemplando entidades, atributos, métodos, relacionamentos e regras de negócio.
- Atualizações e registros do planejamento do CardioRisco no `CHANGELOG.md` (diagrama de caso de uso, fluxo de navegação e documentação do projeto).

## [18/11/2026]

### Adicionado

- Atualização do diagrama de caso de uso do CardioRisco, contemplando as funcionalidades e interações dos usuários com o sistema.
- Atualização do fluxo de navegação, representando o caminho percorrido entre as telas e as principais funcionalidades do aplicativo.
- Organização dos fluxos de acesso, avaliação de risco cardiovascular, consulta ao histórico e visualização dos resultados.
- Criação do arquivo `docs/diagramaCasodeUso.md`.
- Criação do arquivo `docs/FluxodeNavegação.md`.

## [18/11/2026]

### Adicionado

- Documento `docs/diagramaClasses.md` com o diagrama de classes (modelos de domínio) do CardioRisco: entidades, atributos, métodos, relacionamentos e regras de negócio.

## [07/11/2026]

### Adicionado

- Arquivo `docs/prototipoAltaFidelidadeUnidade2.pdf` com o protótipo de alta fidelidade da Unidade II: telas de login, cadastro, home, histórico, paciente/evolução, painel e conta e privacidade.
- Tema visual (cores e estilos de texto) e componentes reutilizáveis no Figma, como base para o tema do app em Flutter.

### Alterado

- Tela 1: código do paciente gerado automaticamente, sem nome ou CPF.
- Tela 2: opção "Usa remédio para controlar a pressão?" dentro da pergunta de pressão (o formulário continua com 7 perguntas) e botão renomeado para "Avaliar risco".
- Tela 3: percentual de risco no velocímetro e aviso de que o resultado é uma estimativa e não substitui o profissional de saúde.
- Tela 4: classificação do risco, encaminhamento sugerido para a UBS e recomendações personalizadas conforme as respostas.
- Restaurado o nome `docs/escolhasInterface.md`, exigido na Atividade 04.

## [30/09/2026]

### Adicionado

- Arquivo `docs/apresentacaoFinalUnidadeI.pdf` 

## [23/09/2026] 

### Adicionado

- Arquivo `docs/Apresentação_ativ4.pdf`.

## [22/09/2026]

### Adicionado

- Arquivo `docs/prototipoBaixaFidelidade.pdf`.

### Alterado

- Atualização do `README.md` com a responsabilidade de Erick Gabriel na Atividade 04.

## [16/09/2026]

### Adicionado

- Arquivo `docs/prototipoAltaFidelidade.pdf`.
- Documento `docs/escolhasInterface.md`.

### Alterado

- Atualização do `README.md` com a responsabilidade de José Victor na Atividade 04.

## [15/09/2026]


### Adicionado

- Criação do Slide sobre Requisitos e Funcionalidades.

## [14/09/2026]

### Adicionado

- Elaboração da seção **2.4 — CRUD**, definindo as operações de criação, consulta, atualização e exclusão dos registros de avaliações cardiovasculares.
- Elaboração da seção **2.5 — Priorização**, classificando as funcionalidades do CardioRisco em essenciais, importantes e secundárias.
- Inclusão da justificativa relacionada à aplicação das operações CRUD no sistema.

### Alterado

- Atualização do `README.md` com a responsabilidade de Erick Gabriel na Atividade 03.
- Atualização da seção de responsabilidades da Atividade 03, detalhando as funções de cada integrante.
- Atualização do arquivo `docs/requisitos.md` com as definições relacionadas ao CRUD e à priorização das funcionalidades.

## [13/09/2026]

### Adicionado

- Definição das funcionalidades principais do CardioRisco.
- Elaboração dos requisitos funcionais relacionados às funcionalidades definidas.
- Elaboração dos requisitos não funcionais relacionados a usabilidade, acessibilidade visual, privacidade, desempenho, compatibilidade, conectividade e armazenamento.

### Alterado

- Atualização do `README.md` com a responsabilidade de José Victor na Atividade 03.
- Atualização do arquivo `docs/requisitos.md`.

## [09/09/2026]

### Adicionado

- Pesquisa sobre doenças cardiovasculares, público e contexto de uso do CardioRisco.
- Levantamento de fontes confiáveis para embasar as decisões do projeto.
- Benchmark de três soluções relacionadas à avaliação de risco cardiovascular.
- Criação de duas personas principais para o projeto.
- Definição da persona prioritária.
- Criação dos arquivos `docs/pesquisa.md`, `docs/benchmark.md` e `docs/personas.md`.
- Criação dos slides em pdf e apresentação.

### Alterado

- Atualização do `README.md` com as responsabilidades dos integrantes na Atividade 02.

## [02/09/2026]

### Adicionado

- Criação da documentação inicial do projeto.
- Criação do README.md.
- Criação do CHANGELOG.md.
- Criação da análise inicial do estudo de caso.
- Criação do arquivo `docs/estudo-de-caso.md`.
- 
