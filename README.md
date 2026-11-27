# CardioRisco

## Descrição

O CardioRisco é um aplicativo mobile voltado para auxiliar profissionais
da atenção básica na avaliação do risco de desenvolvimento de doenças
cardiovasculares em um período de 10 anos.

## Integrantes

- Erick Gabriel Lima Matos
- José Victor Barbosa Neves
- João Gabriel da Costa Souza

## Turma

PROGRAMAÇÃO PARA DISPOSITIVOS MÓVEIS-GP0015NOT07A

## Como executar

**Requisitos:** Flutter 3.50 (Dart 3.14) e Android Studio com um emulador Android (ou um celular Android com a depuração USB ligada).

```bash
flutter pub get        # baixa os pacotes do projeto
flutter run            # compila e abre o app no emulador ou celular
```

**Testes automatizados:**

```bash
flutter test test/domain test/presentation
```

**Organização do código** (arquitetura em camadas):

- `lib/domain/`: modelos e regras de negócio (cálculo do risco, fatores, recomendações e indicadores).
- `lib/data/`: armazenamento no aparelho, sincronização e acesso ao Firebase.
- `lib/presentation/`: telas e controladores de estado (Provider).
- `docs/`: documentação do projeto (requisitos, personas, pesquisa, protótipos, diagramas, planejamento e uso de IA).

## Responsabilidades - Atividade 02/09/2026

- José Victor Barbosa Neves: análise do problema e público-alvo.
- José Victor Barbosa Neves: análise do contexto de uso e proposta de valor.
- Erick Gabriel Lima Matos: análise das funcionalidades e restrições.
- José Victor Barbosa Neves e Erick Gabriel Lima Matos: revisão da documentação e organização do repositório.

## Responsabilidades - Atividade 02 09/09/2026

- José Victor Barbosa Neves: Pesquisa sobre o problema e levantamento de fontes.
- Felipe Guimarães: Benchmark das soluções existentes.
- João Afonso: Criação e análise das personas.
- João Gabriel: Revisão da documentação e organização dos arquivos no repositório.
- Erick Gabriel Lima Matos: Criação dos slides e fez a apresentação 


## Responsabilidades — Atividade 03 16/09/2026


- José Victor: responsável pela definição das funcionalidades do CardioRisco, transformação dessas funcionalidades em requisitos funcionais e elaboração dos requisitos não funcionais, considerando usabilidade, privacidade, desempenho, compatibilidade, armazenamento e conectividade.

- Erick Gabriel: responsável pela elaboração do CRUD do sistema, identificando e organizando as operações de criação, consulta, atualização e exclusão dos registros de avaliações cardiovasculares. Também definiu como essas operações seriam aplicadas ao armazenamento e gerenciamento dos dados do aplicativo e pela priorização das funcionalidades, classificando os recursos do CardioRisco de acordo com sua importância para o funcionamento do sistema. As funcionalidades foram organizadas em categorias essenciais, importantes e secundárias, considerando quais recursos são indispensáveis para a realização da avaliação cardiovascular e quais podem ser aprimorados posteriormente.

- João Gabriel: Responsável pela criação do Slide sobre os requisitos e as funcionalidades para a apresentação.


## Responsabilidades — Atividade 04 22/09/2026

- José Victor: responsável pelo desenvolvimento e organização do protótipo de alta fidelidade do CardioRisco e pela documentação das principais escolhas de interface, incluindo cores, tipografia, organização das informações, navegação, componentes, acessibilidade e decisões relacionadas ao contexto de uso.

- Erick Gabriel: responsável pelo desenvolvimento e organização do protótipo de baixa fidelidade do CardioRisco e pela documentação do fluxo de navegação entre as telas, incluindo a estruturação das etapas de coleta de dados (demográficos/comportamentais e clínicos), a definição da sequência lógica das telas (dados → resultado → orientações → histórico) e o mapeamento das transições e retornos do fluxo.

- João Gabriel: Verificar toda a documentaçaõ para criação do slide para Apresentação do dia 23/09/2026.

- ## Responsabilidade - Apresentação Final 30/09/2026

- João Gabriel: Fiquei responsável pela criação do slide para a apresentação e não pude estar presente por motivos de saúde, irei apresentar o atestado após os dias que recebi.

## Responsabilidades — Unidade II (novembro/2026)

- **José Victor Barbosa Neves** (líder do grupo):
  - Divisão das tarefas da Unidade II e acompanhamento do prazo de entrega.
  - Revisão de todos os Pull Requests do grupo antes de entrarem na `main`: leitura do código e da documentação, aprovação, pedidos de ajuste e merge (PRs #4, #5, #11, #14, #16 e #17 dos colegas).
  - Integração dos módulos do grupo no app: home e histórico do Erick (com os pacotes `pdf` e `printing`) e sincronização do João.
  - Protótipo de alta fidelidade das telas da Unidade II no Figma (`docs/prototipoAltaFidelidadeUnidade2.pdf`).
  - Cálculo do risco cardiovascular: equação de Framingham e Escore de Risco Global da SBC pela tabela de pontos, com validações clínicas, classificação do risco, fatores de risco e recomendações personalizadas.
  - Telas 1 a 4 do fluxo da avaliação: formulário em 2 etapas com salvamento automático e modo edição, velocímetro, resultado e recomendações, usando Provider.
  - Ícone e nome do app no Android.
  - 37 testes automatizados (cálculos, validações, fatores, recomendações e telas da avaliação).
  - Documentação: diagrama de classes, escolhas de interface (seção 25), pesquisa (fontes do cálculo), registro de uso de IA (parte própria), README e CHANGELOG.

- **João Gabriel da Costa Souza:**
  - Projeto base em Flutter com a arquitetura em camadas e configuração do Firebase (Authentication e Cloud Firestore).
  - Login, cadastro e sessão do profissional.
  - Armazenamento no aparelho (rascunho e fila de avaliações) e sincronização com o Firestore, enviando só no Wi-Fi e sem duplicar registros.
  - Consentimento de privacidade, registro de auditoria de privacidade e exclusão dos dados.
  - Registro de uso de IA (parte própria).

- **Erick Gabriel Lima Matos:**
  - Diagrama de casos de uso, fluxo de navegação e planejamento do projeto (escopo, EAP e sprints).
  - Home, histórico (busca, filtro, detalhes, edição e exclusão), comparação entre avaliações, gráfico de evolução, dashboard do ACS e relatórios em PDF.
  - 8 testes automatizados dos indicadores e dos relatórios.
