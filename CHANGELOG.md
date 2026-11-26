## Changelog

## [26/11/2026]

## Adicionado

- Home (lib/presentation/home/cardiorisco_home_screen.dart): logo do CardioRisco, resumo com avaliações, pacientes e pacientes em alto risco, três últimas avaliações, botão "Nova avaliação" (vira "Continuar avaliação em andamento" quando há rascunho), atalhos para as telas de acompanhamento, atualizar, sair da conta e aviso de avaliações aguardando envio. Abre o formulário com FormularioAvaliacaoScreen() e só atualiza os números quando ele devolve true.
- Histórico completo (lib/presentation/historico/historico_screen.dart): lista das avaliações do aparelho, busca por código do paciente, filtro por nível de risco, ícone do status de envio, ver detalhes, editar pelo formulário (FormularioAvaliacaoScreen(avaliacao: x)) e excluir com confirmação.
- Tela de detalhes da avaliação (detalhe_avaliacao_screen.dart): dados pessoais e clínicos, resultado, editar, excluir e gerar o PDF da avaliação.
- Comparação entre avaliações (lib/presentation/comparacao/comparacao_screen.dart): duas avaliações do mesmo paciente lado a lado, com a variação do risco em pontos percentuais e a mudança de cada fator (pressão, colesterol, HDL, tabagismo, diabetes e remédio para pressão).
- Gráfico de evolução (lib/presentation/evolucao/evolucao_screen.dart e shared/grafico_evolucao.dart): risco do paciente ao longo das avaliações, desenhado com CustomPainter, com eixos, datas e as faixas de risco da SBC conforme o sexo.
- Dashboard do ACS (lib/presentation/dashboard/dashboard_screen.dart e shared/grafico_rosca.dart): gráficos de rosca de nível de risco, tabagismo, diabetes, remédio para pressão e sexo, além da lista de pacientes em alto risco.
- Relatórios epidemiológicos agregados (lib/presentation/relatorios/relatorios_screen.dart): filtro de período (todo o período, 30 ou 90 dias), classificação de risco, fatores de risco, faixa etária e médias clínicas, sem identificar pacientes.
- Relatório em PDF (lib/domain/services/relatorio_pdf_service.dart e relatorios/pdf_preview_screen.dart): relatório agregado e relatório individual da avaliação, com pré-visualização, compartilhamento e impressão.
- IndicadoresService (lib/domain/services/indicadores_service.dart): cálculo dos indicadores agregados. Cada paciente conta uma vez, pela avaliação mais recente, e rascunhos ficam de fora.
- CardioRiscoRepository (lib/data/local/cardiorisco_repository.dart): leitura das avaliações pelo LocalStorageService, ordenação, filtro por profissional e exclusão local.
- Funções de formatação de datas, números e percentuais em português (lib/core/utils/formatadores.dart).
- Componentes compartilhados das telas de acompanhamento: cartões de métrica, linhas de informação, estado vazio, carregador de avaliações e cores por nível de risco (lib/presentation/shared/).
- A home liga o monitoramento do SyncService ao abrir e o desliga ao fechar, porque o AuthScreen encerra o dele quando a tela é substituída.
- 8 novos testes automatizados: indicadores agregados (paciente contado uma vez, filtro por período, faixa etária, classificação por sexo) e geração dos PDFs (test/domain/indicadores_service_test.dart).
- Dependências pdf e printing no pubspec.yaml.
- Documento PlanejamentoCardioRisco e ApresentaçãoPlanejamento 

## Alterado

- AuthScreen: depois do login, e da ativação da sincronização, abre a home (CardioHomeScreen) em vez de mostrar a tela provisória.
- Gráfico de evolução e tela de evolução usam ResultadoRisco.limiteBaixo e ResultadoRisco.limiteAlto, em vez de repetir os limites das faixas.
- Diagrama de caso de uso (docs/diagramaCasodeUso.md) atualizado para as regras da Unidade II, com os casos de uso organizados em cinco grupos:
  - Acesso: criar conta, fazer login e recuperar senha.
  - Avaliação: continuar avaliação em andamento, salvamento automático e "usa remédio para pressão" nos dados clínicos.
  - Histórico: buscar e filtrar, ver detalhes, editar com registro de auditoria, excluir, ver evolução e comparação e exportar PDF.
  - Painel: ver indicadores, gerar relatório em PDF e relatório da equipe.
  - Conta: ver dados, política de privacidade, envio somente por Wi-Fi, excluir dados definitivamente e sair.
- Diagrama de caso de uso: novo ator geral "Profissional de saúde" (ACS, Enfermeiro e Médico), relatório da equipe ligado somente ao Enfermeiro e ao Médico, matriz de acesso por área, legenda de cores e diagrama redesenhado, com ligações dos atores até os casos de uso, fonte maior e mais contraste.
- Regras de negócio do caso de uso: "quando houver internet" trocado por "quando houver Wi-Fi" e removida a restrição de "no máximo quatro telas principais", que era da Unidade I.
- Fluxo de navegação (docs/FluxodeNavegação.md): nova decisão "Já está logado?" depois de "Abrir aplicativo" (o login só é pedido no primeiro acesso).
- Fluxo de navegação: no Painel, o ACS permanece na tela e apenas não vê o botão "Relatório da equipe", visível para enfermeiro e médico.
- Fluxo de navegação: a avaliação em andamento retoma na etapa em que parou (dados pessoais ou dados clínicos), com a nova decisão "Em que etapa parou?".

## Corrigido

- Formulário de avaliação em modo edição (FormularioAvaliacaoController.iniciar): o aviso à tela acontecia durante a construção dela e causava o erro !_dirty is not true ao editar pelo histórico.

## [25/11/2026]

### Adicionado

- Tela 3 (resultado) com velocímetro desenhado com `CustomPainter`: o ponteiro anima até o percentual, e as faixas verde, amarela e vermelha seguem os limites da SBC para o sexo do paciente (`lib/presentation/avaliacao/resultado_screen.dart` e `widgets/velocimetro.dart`).
- Lista "O que influencia seu risco?" com os fatores alterados nas respostas (`FatorRisco` e `IdentificadorFatores`, em `lib/domain/`), com explicação ao tocar em cada fator.
- Painel "Saiba mais sobre o cálculo", com o modelo usado e as faixas de risco da SBC.
- Cabeçalho das telas da avaliação no estilo do protótipo (`widgets/cabecalho_avaliacao.dart`).
- 7 novos testes automatizados: fatores de risco, posição do ponteiro do velocímetro e Tela 3 (23 testes no total).
- Ícone do app (coração com a linha de pulso, nas cores do tema escuro), gerado para todos os tamanhos do Android com o `flutter_launcher_icons` (`assets/icone/` e `flutter_launcher_icons.yaml`). O nome embaixo do ícone passa a ser "CardioRisco".
- Tela 4 (recomendações): encaminhamento sugerido conforme o nível de risco e os fatores alterados, e recomendações de estilo de vida personalizadas ("Parar de fumar" só para fumantes e "Controle do diabetes" só para diabéticos), com explicação ao tocar em cada cartão (`Recomendacao` e `GeradorRecomendacoes`, em `lib/domain/`, e `recomendacoes_screen.dart`).
- Botão "Concluir e voltar ao início": salva a avaliação na fila local, apaga o rascunho (só em avaliação nova), tenta enviar ao Firestore na hora com o `SyncService` e volta para a tela que abriu o formulário.
- 7 novos testes automatizados: recomendações, Tela 4 e reinício do formulário (30 testes no total).
- Teste de tela do formulário: sem respostas, a etapa 1 mostra os erros e não avança (31 testes no total).

### Alterado

- `ResultadoRisco`: os limites das faixas (5%, 20% e 10%) viraram constantes (`limiteBaixo` e `limiteAlto`), usadas pela classificação e pelo velocímetro.
- O botão "Avaliar risco" do formulário passa a abrir a Tela 3.
- O botão "Ver orientações" da Tela 3 passa a abrir a Tela 4.
- Telas 1 e 2 ajustadas ao protótipo de alta fidelidade: cabeçalho "CardioRisco", indicador de etapas com bolinhas numeradas, títulos em verde com subtítulo, ícones nas perguntas e nos campos, notas de rodapé da etapa 1 e caixa de dica da etapa 2.

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
