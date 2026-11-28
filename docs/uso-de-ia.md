# Registro de Uso de IA — CardioRisco

Este documento atende ao item b.vi do projeto da Unidade II: registra como cada integrante usou ferramentas de Inteligência Artificial, os prompts mais úteis, os erros gerados pela IA e como o grupo os resolveu, além da justificativa das bibliotecas escolhidas.

Regra do grupo: todo código ou texto gerado com IA foi lido, testado e entendido pelo integrante responsável antes de ir para o repositório, e os commits foram feitos com a conta de cada um.

---

## Item b.vi — Registro de Uso de IA (João Gabriel da Costa Souza)

### Exemplos de Prompts Utilizados no Gemini

1. **Integração com Firebase e estrutura de dados:** *"Ajude-me a estruturar a integração com Firebase Authentication e Cloud Firestore em Flutter/Dart mantendo a arquitetura do projeto e respeitando o formato do modelo de avaliação sem alterar a lógica de cálculo."*
2. **Persistência offline e sincronização sem duplicidade:** *"Como implementar uma fila local com `shared_preferences` e `connectivity_plus` no `SyncService` para guardar avaliações sem conexão com a internet usando código anônimo e sincronizar com o Firestore ao restabelecer a rede sem duplicar registros?"*
3. **Resolução de problemas de build e depuração Android:** *"O `flutter run` / build Android apresentou erro no Gradle ou não detectou o dispositivo/emulador; quais os passos para diagnosticar e corrigir mantendo o ambiente funcional?"*
4. **Correção do login e autenticação offline segura:** *"Como exigir e-mail e senha em todas as tentativas de login sem bypass offline indevido, mantendo o acesso offline apenas com validação criptográfica da senha salva?"*

### Erros Cometidos pela IA e Como Foram Resolvidos

- **Erro 1 — Sincronização automática restrita a mudanças de conectividade:** Inicialmente, a sugestão de sincronização automática concentrava o envio apenas em eventos de alteração de conectividade (`onConnectivityChanged`), deixando de enviar imediatamente os itens já pendentes na fila local quando o aplicativo era aberto ou o usuário fazia login com a rede já ativa, além de exigir validação cuidadosa para não alterar o `AvaliacaoModel` sem alinhamento prévio com a equipe.
  - **Resolução:** A implementação foi ajustada para disparar `sincronizarPendentes()` e `iniciarMonitoramentoAutomatico()` no fluxo pós-login e inicialização da sessão autenticada, garantindo o envio dos registros em fila mesmo com internet já disponível e evitando duplicidade pelo controle dos itens pendentes/sincronizados, mantendo intacta a estrutura de cálculo do `AvaliacaoModel`.

- **Erro 2 — Permissão de acesso sem senha / *fallback* offline indevido (botão ou fluxo "continuar off-line"):** Na revisão de controle de acesso (`a.iv`), identificou-se que o fluxo de login permitia acessar com senha vazia ou entrar sem conexão sem validar adequadamente a credencial, ao mesmo tempo em que o bloqueio puro sem validação local impedia o acesso offline de quem já possuía conta no dispositivo.
  - **Resolução:** A validação de e-mail e senha obrigatórios foi reforçada na `AuthScreen` e no `AuthService`, removendo o *bypass* sem senha e implementando no `LocalStorageService` o armazenamento de *hash* SHA-256 com *salt* único por e-mail após login/cadastro válido online, permitindo autenticar offline apenas com a senha correspondente à conta salva localmente.

### Justificativa das Bibliotecas Utilizadas

- **`firebase_core`:** Necessária para inicializar a conexão do Flutter com o projeto Firebase antes de utilizar qualquer serviço Firebase na aplicação.
- **`firebase_auth`:** Utilizada para gerenciar a autenticação de usuários (agentes de saúde) e o estado da sessão ativa.
- **`cloud_firestore`:** Utilizada como banco de dados remoto na nuvem para armazenar e consultar as avaliações sincronizadas.
- **`shared_preferences`:** Utilizada para persistência local leve no dispositivo, permitindo armazenar avaliações em fila quando o aparelho está offline, manter o estado local entre sessões e guardar os metadados de *hash*/*salt* para validação offline.
- **`connectivity_plus`:** Utilizada para monitorar o estado da conexão com a rede (Wi-Fi, dados móveis ou offline) e acionar o `SyncService` quando a conectividade fica disponível.
- **`crypto`:** Utilizada para gerar *hash* SHA-256 com *salt* aleatório na validação local de senha em modo offline, evitando armazenar senha em texto puro ou liberar acesso sem verificação.

---

## Registro de Uso de IA (José Victor Barbosa Neves)

### Áreas em que a IA foi usada

- Protótipo de alta fidelidade da Unidade II (Figma).
- Domínio da avaliação: `AvaliacaoModel`, `ResultadoRisco`, os dois modelos de cálculo (`CalculadoraFramingham` e `CalculadoraErgSbc`), fatores de risco e recomendações.
- Telas 1 a 4: formulário em etapas com salvamento automático e modo edição, velocímetro e recomendações.
- Testes automatizados, ícone do app, integração dos módulos do grupo e revisão dos Pull Requests.
- Documentação: diagrama de classes, escolhas de interface, pesquisa, este registro, README e CHANGELOG.

### Ferramenta e forma de uso

- **Ferramenta:** Claude (Anthropic), no modo Cowork do app Claude, com acesso à pasta do projeto.
- **Como funcionou:** a IA explicava cada passo, escrevia os arquivos de código, testes e documentação e revisava o código dos colegas. Eu rodava os comandos no meu computador (`flutter analyze`, `flutter test`, `flutter run` e os comandos do Git), testava no emulador, conferia o resultado e fazia os commits com a minha conta.

### Exemplos de prompts usados

1. **Forma de trabalho:** *"Quero explicações passo a passo, partindo do zero. Quando estivermos trabalhando com Git/GitHub, quero que você me diga exatamente o que devo esperar como resultado."*
2. **Entender o cálculo antes de programar:** *"Como seria feito o cálculo?"* A IA explicou a equação de Framingham e as faixas da SBC, e só depois o cálculo foi programado.
3. **Protótipo:** *"Vou te mandar o link [do Figma]. Quero que você faça as mudanças que tem que fazer"*, com a escolha do tema escuro com as melhorias da versão clara.
4. **Planejamento:** *"O que falta da minha parte ainda?"* e *"Qual o próximo passo?"*, para seguir a divisão de tarefas e o prazo.
5. **Revisão do grupo:** *"Antes de eu continuar, olhe as atualizações do grupo"*, para revisar os Pull Requests do João e do Erick antes do merge.

### Erros gerados pela IA e como foram resolvidos

| Erro | Como foi percebido | Solução |
|---|---|---|
| Teste de tela do formulário falhou com `Bad state: No element`: o teste procurava o botão "CONTINUAR", mas a lista da tela só monta o que está perto da parte visível, e a tela de teste (800x600) era pequena | Saída do `flutter test` | Aumentar a tela de teste para 800x2000 |
| No modo edição, o `FormularioAvaliacaoController` avisava a tela no meio da montagem dela (erro `!_dirty is not true`) | O Erick encontrou ao ligar o histórico ao formulário | Uma espera curta (`Future.delayed(Duration.zero)`) antes de avisar a tela |
| Um script de edição da IA duplicou parte do arquivo da tela do formulário | Conferência da diferença (`diff`) antes do commit | O arquivo foi restaurado do último commit e a edição refeita |
| A IA deixou arquivos de trava do Git (`index.lock`) na pasta ao conferir arquivos | Aviso do próprio Git | Os arquivos foram renomeados e a IA passou a usar só comandos de leitura que não travam o Git |
| Contagens erradas (7 arquivos num PR que tinha 6; 46 testes quando eram 45) | Comparação com o GitHub e com a saída do `flutter test` | Sempre conferir pelo resultado real, não pela previsão da IA |
| Três valores da tabela de pontos do ERG eram diferentes entre as fontes encontradas pela IA | A própria IA avisou que não conseguiu abrir o PDF oficial | Baixei a V Diretriz da SBC e as tabelas foram conferidas célula por célula. Um valor foi corrigido (mulheres com 18 pontos = 21,6%) |
| Depois de uma mudança no `SyncService`, a Tela 4 passou a chamar uma função que não conferia mais a regra de enviar só no Wi-Fi | Revisão do código do commit do João | A Tela 4 passou a usar `sincronizarTudo()`, que confere o Wi-Fi |

### Justificativa das bibliotecas que adicionei

- **`provider`:** gerenciamento de estado pedido no aditivo da Unidade II. Foi escolhido por ser simples, ser recomendado na documentação do Flutter e bastar para o tamanho do app. O `FormularioAvaliacaoController` (um `ChangeNotifier`) avisa a tela quando algo muda.
- **`flutter_launcher_icons`** (só para desenvolvimento): gera o ícone do app em todos os tamanhos do Android a partir de uma imagem. Não vai dentro do APK.
- **`pdf` e `printing`:** usados pelos relatórios em PDF desenvolvidos pelo Erick. Adicionei ao `pubspec.yaml` na integração. O `pdf` monta o documento e o `printing` mostra a prévia e abre as opções de imprimir e compartilhar do Android.

### Validação humana

- Todo o código foi lido e explicado passo a passo antes do commit.
- `flutter analyze` sem erros e 45 testes automatizados passando, incluindo os valores do cálculo conferidos com o artigo de D'Agostino (2008) e com as tabelas da SBC.
- Fluxo completo testado no emulador: login, home, avaliação nas 4 telas, histórico, edição, dashboard, evolução e PDF.
- Os textos da documentação foram redigidos com apoio da IA a partir do código e dos documentos do projeto, e revisados por mim