# Modelagem do Cloud Firestore e Mapeamento para Classes Dart (Itens b.iii e b.iv)

Este documento descreve a estrutura de dados no **Cloud Firestore** (item **b.iii**) e o mapeamento bidirecional (`toMap` / `fromMap` / `toJson` / `fromJson`) com as classes de domínio em **Dart** (item **b.iv**) do projeto **CardioRisco**.

---

## 1. Modelagem do Banco de Dados — Cloud Firestore (Item b.iii)

O banco utiliza o modelo NoSQL orientado a documentos do **Cloud Firestore**, organizado em coleções principais e sincronizado com o armazenamento local (`SharedPreferences` via `LocalStorageService`) para operação *offline-first* com código anônimo do paciente (sem nome ou CPF).

### 1.1 Coleção `profissionais`

Armazena o cadastro e o perfil de acesso do profissional de saúde autenticado no Firebase Authentication.

- **Caminho do documento:** `profissionais/{uid}` (onde `{uid}` corresponde ao `uid` do usuário no Firebase Auth).
- **Campos do documento:**
  - `uid` (`string`): identificador único do profissional no Firebase Auth.
  - `nome` (`string`): nome completo do profissional de saúde.
  - `email` (`string`): e-mail profissional do usuário.
  - `ubs` (`string`): identificação da Unidade Básica de Saúde vinculada.
  - `perfilAcesso` (`string`): perfil de permissão (`"ACS"` ou `"Equipe de saúde"`).
  - `aceitouPrivacidade` (`boolean`): indica se o aceite da Política de Privacidade foi registrado.

### 1.2 Coleção `avaliacoes`

Armazena as avaliações de risco cardiovascular realizadas nas visitas domiciliares, identificando o paciente apenas por código anônimo (`P-XXXX`) e vinculando ao `profissionalId`.

- **Caminho do documento:** `avaliacoes/{id}` (onde `{id}` é o identificador único da avaliação).
- **Campos do documento:**
  - **Identificação e vínculo:**
    - `id` (`string`): identificador da avaliação.
    - `codigoPaciente` (`string`): código anônimo do paciente (ex.: `"P-0013"`), sem dados pessoais diretos como nome ou CPF.
    - `profissionalId` (`string`): `uid` do profissional responsável pela avaliação.
    - `dataHora` (`string` / ISO-8601): data e hora em que a avaliação foi registrada.
    - `etapaAtual` (`number` / `int`): etapa atual do formulário (`1` ou `2`) para retomada de rascunho.
  - **Etapa 1 — Dados demográficos e comportamentais:**
    - `idade` (`number` / `int` / `null`): idade do paciente em anos (faixa clínica esperada: `30` a `74`).
    - `sexo` (`string` / `null`): nome do enum `Sexo` (ex.: `"masculino"`, `"feminino"`).
    - `fumante` (`boolean` / `null`): indica tabagismo atual.
    - `diabetico` (`boolean` / `null`): indica diagnóstico de diabetes.
  - **Etapa 2 — Dados clínicos medidos:**
    - `pressaoSistolica` (`number` / `int` / `null`): pressão arterial sistólica em mmHg (faixa clínica: `70` a `250`).
    - `usaRemedioPressao` (`boolean` / `null`): indica uso de medicação anti-hipertensiva.
    - `colesterolTotal` (`number` / `int` / `null`): colesterol total em mg/dL (faixa clínica: `70` a `500`).
    - `hdl` (`number` / `int` / `null`): colesterol HDL em mg/dL (faixa clínica: `10` a `150`, devendo ser menor que `colesterolTotal`).
  - **Resultado do cálculo (campos achatados no documento):**
    - `percentualRisco` (`number` / `double` / `null`): percentual de risco cardiovascular calculado.
    - `classificacaoRisco` (`string` / `null`): nome do enum `NivelRisco` (ex.: `"baixo"`, `"moderado"`, `"alto"`).
    - `modeloRisco` (`string` / `null`): modelo de cálculo utilizado (ex.: `"Framingham"` ou `"ERG/SBC"`).
    - `calculadoEm` (`string` / ISO-8601 / `null`): data/hora em que o cálculo foi gerado.
  - **Controle de sincronização e auditoria temporal:**
    - `statusSync` (`string`): estado da sincronização (`"rascunho"`, `"pendenteEnvio"`, `"sincronizado"`).
    - `atualizadoEm` (`string` / ISO-8601): carimbo de data/hora da última atualização.

---

## 2. Mapeamento entre Classes Dart e Firestore (Item b.iv)

A conversão entre os objetos de domínio em Dart e os mapas (`Map<String, dynamic>`) usados no Cloud Firestore e no `SharedPreferences` é feita diretamente nas classes de modelo via `toMap()`, `fromMap()`, `toJson()` e `fromJson()`.

### 2.1 `ProfissionalModel` (`lib/domain/models/profissional_model.dart`)

| Atributo Dart | Tipo Dart | Chave no Firestore / Map | Observações de Mapeamento |
|---|---|---|---|
| `uid` | `String` | `uid` | `fromMap` aplica fallback `''` se nulo |
| `nome` | `String` | `nome` | `fromMap` aplica fallback `''` se nulo |
| `email` | `String` | `email` | `fromMap` aplica fallback `''` se nulo |
| `ubs` | `String` | `ubs` | `fromMap` aplica fallback `''` se nulo |
| `perfilAcesso` | `String` | `perfilAcesso` | `fromMap` aplica fallback `'ACS'` se nulo |
| `aceitouPrivacidade` | `bool` | `aceitouPrivacidade` | `fromMap` aplica fallback `false` se nulo |

### 2.2 `AvaliacaoModel` (`lib/domain/models/avaliacao_model.dart`)

| Atributo Dart | Tipo Dart | Chave no Firestore / Map | Conversão `toMap` / `fromMap` |
|---|---|---|---|
| `id` | `String` | `id` | Direta (`?? ''` no `fromMap`) |
| `codigoPaciente` | `String` | `codigoPaciente` | Direta (`?? ''` no `fromMap`); sem nome/CPF |
| `profissionalId` | `String` | `profissionalId` | Direta (`?? ''` no `fromMap`) |
| `dataHora` | `DateTime` | `dataHora` | `toIso8601String()` na escrita; `DateTime.tryParse` com fallback `DateTime.now()` na leitura |
| `etapaAtual` | `int` | `etapaAtual` | Direta (`?? 1` no `fromMap`) |
| `idade` | `int?` | `idade` | Nullable direto |
| `sexo` | `Sexo?` | `sexo` | `sexo?.name` na escrita; `_lerSexo` aceita `enum.name` ou `enum.rotulo` para retrocompatibilidade |
| `fumante` | `bool?` | `fumante` | Nullable direto |
| `diabetico` | `bool?` | `diabetico` | Nullable direto |
| `pressaoSistolica` | `int?` | `pressaoSistolica` | Nullable direto |
| `usaRemedioPressao` | `bool?` | `usaRemedioPressao` | Nullable direto |
| `colesterolTotal` | `int?` | `colesterolTotal` | Nullable direto |
| `hdl` | `int?` | `hdl` | Nullable direto |
| `resultado` (`ResultadoRisco?`) | `ResultadoRisco?` | `percentualRisco`, `classificacaoRisco`, `modeloRisco`, `calculadoEm` | Serializado em campos planos no `toMap()`; reconstruído via `_lerResultado()` quando `percentualRisco != null` |
| `statusSync` | `StatusSincronizacao` | `statusSync` | `statusSync.name` na escrita; busca em `StatusSincronizacao.values` com fallback `StatusSincronizacao.rascunho` |
| `atualizadoEm` | `DateTime` | `atualizadoEm` | `toIso8601String()` na escrita; `DateTime.tryParse` com fallback `DateTime.now()` na leitura |

### 2.3 Regras de Validação e Consistência no Domínio

- **Anonimização:** `AvaliacaoModel` não possui campos para nome ou CPF, garantindo a identificação apenas por `codigoPaciente`.
- **Validação por etapa (`validar({int? etapa})`):** separa `_validarDadosPessoais()` (etapa 1: idade entre `30` e `74`, sexo, tabagismo, diabetes) e `_validarDadosClinicos()` (etapa 2: pressão sistólica entre `70` e `250`, uso de anti-hipertensivo, colesterol total entre `70` e `500`, HDL entre `10` e `150` e `< colesterolTotal`).
- **Serialização JSON local:** `toJson()` e `fromJson()` usam `jsonEncode` / `jsonDecode` sobre `toMap()` / `fromMap()`, permitindo armazenar listas de avaliações no `SharedPreferences` sem alterar o formato usado no Firestore.