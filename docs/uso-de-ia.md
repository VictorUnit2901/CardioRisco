## Item b.vi — Registro de Uso de IA (João Gabriel da Costa Souza)

### Exemplos de Prompts Utilizados no Gemini

1. **Integração com Firebase e estrutura de dados:** *"Ajude-me a estruturar a integração com Firebase Authentication e Cloud Firestore em Flutter/Dart mantendo a arquitetura do projeto e respeitando o formato do modelo de avaliação sem alterar a lógica de cálculo."*
2. **Persistência offline e sincronização sem duplicidade:** *"Como implementar uma fila local com `shared_preferences` e `connectivity_plus` no `SyncService` para guardar avaliações sem conexão com a internet usando código anônimo e sincronizar com o Firestore ao restabelecer a rede sem duplicar registros?"*
3. **Resolução de problemas de build e depuração Android:** *"O `flutter run` / build Android apresentou erro no Gradle ou não detectou o dispositivo/emulador; quais os passos para diagnosticar e corrigir mantendo o ambiente funcional?"*

### Erro Cometido pela IA e Como Foi Resolvido

* **Erro:** Inicialmente, a sugestão de sincronização automática concentrava o envio apenas em eventos de alteração de conectividade (`onConnectivityChanged`), deixando de enviar imediatamente os itens já pendentes na fila local quando o aplicativo era aberto ou o usuário fazia login com a rede já ativa, além de exigir validação cuidadosa para não alterar o `AvaliacaoModel` sem alinhamento prévio com a equipe.
* **Resolução:** A implementação foi ajustada para disparar `sincronizarPendentes()` e `iniciarMonitoramentoAutomatico()` no fluxo pós-login e inicialização da sessão autenticada, garantindo o envio dos registros em fila mesmo com internet já disponível e evitando duplicidade pelo controle dos itens pendentes/sincronizados, mantendo intacta a estrutura de cálculo do `AvaliacaoModel`.

### Justificativa das Bibliotecas Utilizadas

* **`firebase_core`:** Necessária para inicializar a conexão do Flutter com o projeto Firebase antes de utilizar qualquer serviço Firebase na aplicação.
* **`firebase_auth`:** Utilizada para gerenciar a autenticação de usuários (agentes de saúde) e o estado da sessão ativa.
* **`cloud_firestore`:** Utilizada como banco de dados remoto na nuvem para armazenar e consultar as avaliações sincronizadas.
* **`shared_preferences`:** Utilizada para persistência local leve no dispositivo, permitindo armazenar avaliações em fila quando o aparelho está offline e manter o estado local entre sessões.
* **`connectivity_plus`:** Utilizada para monitorar o estado da conexão com a rede (Wi-Fi, dados móveis ou offline) e acionar o `SyncService` quando a conectividade fica disponível.