# Funcionalidades e Requisitos — CardioRisco

## 1. Objetivo

Este documento apresenta as principais funcionalidades e requisitos do CardioRisco, definidos a partir do estudo de caso, das personas, da pesquisa realizada sobre o problema e do benchmark de soluções existentes.

O objetivo é estabelecer de forma clara o que o aplicativo deverá fazer e quais condições deverão ser respeitadas durante seu desenvolvimento.

## 2.1. Funcionalidades

### F01 — Coleta de dados demográficos e comportamentais

**Descrição:**  
Permitir que o profissional informe dados necessários para a avaliação, como idade, sexo, tabagismo e diabetes.

**Necessidade atendida:**  
Permitir que o ACS registre rapidamente os fatores do paciente necessários para o cálculo do risco cardiovascular.

**Justificativa:**  
Essas informações fazem parte da avaliação do risco e precisam ser coletadas de maneira simples, pois o aplicativo será utilizado durante visitas domiciliares e o profissional possui tempo limitado para preencher o formulário.

---

### F02 — Coleta de dados clínicos

**Descrição:**  
Permitir o registro de informações clínicas, como pressão arterial, colesterol total e HDL.

**Necessidade atendida:**  
Reunir os dados clínicos necessários para que o risco cardiovascular possa ser calculado.

**Justificativa:**  
O resultado da avaliação depende das informações clínicas do paciente. Por isso, o aplicativo precisa permitir que esses dados sejam informados de forma clara e organizada.

---

### F03 — Validação dos dados informados

**Descrição:**  
Verificar se os campos necessários foram preenchidos corretamente antes da realização do cálculo.

**Necessidade atendida:**  
Reduzir erros de preenchimento durante a utilização do aplicativo.

**Justificativa:**  
O ACS poderá utilizar o aplicativo enquanto conversa com o paciente e realiza outras atividades durante a visita. A validação ajuda a evitar cálculos baseados em informações ausentes ou preenchidas incorretamente.

---

### F04 — Cálculo do risco cardiovascular

**Descrição:**  
Calcular a probabilidade de ocorrência de um evento cardiovascular em um período de 10 anos utilizando os dados informados.

**Necessidade atendida:**  
Permitir que o profissional realize rapidamente uma avaliação do risco cardiovascular do paciente.

**Justificativa:**  
Essa é a funcionalidade central do CardioRisco e está diretamente relacionada à proposta principal do aplicativo: auxiliar profissionais da atenção básica na prevenção cardiovascular.

---

### F05 — Classificação do nível de risco

**Descrição:**  
Classificar o resultado da avaliação em categorias como risco baixo, intermediário ou alto.

**Necessidade atendida:**  
Facilitar a interpretação do resultado pelo profissional e pelo paciente.

**Justificativa:**  
A apresentação de apenas um percentual pode ser difícil de compreender. A classificação transforma o resultado em uma informação mais simples e direta.

---

### F06 — Visualização do risco por velocímetro

**Descrição:**  
Apresentar o risco cardiovascular por meio de um velocímetro com ponteiro, juntamente com o percentual calculado.

**Necessidade atendida:**  
Permitir que o ACS explique visualmente o resultado ao paciente.

**Justificativa:**  
Pacientes podem possuir dificuldade para interpretar percentuais e termos médicos. O velocímetro torna a informação mais visual e ajuda o profissional a utilizar a tela do smartphone como recurso educativo.

---

### F07 — Recomendações conforme o resultado

**Descrição:**  
Apresentar orientações relacionadas à classificação obtida, como prevenção, mudanças de hábitos ou necessidade de encaminhamento.

**Necessidade atendida:**  
Ajudar o profissional e o paciente a compreender quais ações podem estar relacionadas ao resultado apresentado.

**Justificativa:**  
O aplicativo não deve apenas mostrar um número. O resultado precisa contribuir para a prevenção e para a comunicação entre o profissional de saúde e o paciente.

---

### F08 — Funcionamento offline

**Descrição:**  
Permitir que a avaliação cardiovascular seja realizada mesmo quando o dispositivo estiver sem acesso à internet.

**Necessidade atendida:**  
Permitir que o ACS utilize o aplicativo durante visitas em locais com conectividade limitada ou inexistente.

**Justificativa:**  
O aplicativo poderá ser utilizado em regiões rurais e periféricas. Se a funcionalidade principal dependesse de internet, o profissional poderia ficar impossibilitado de realizar a avaliação.

---

### F09 — Armazenamento local e sincronização posterior

**Descrição:**  
Armazenar temporariamente as avaliações realizadas sem internet e sincronizá-las posteriormente quando uma conexão estiver disponível.

**Necessidade atendida:**  
Evitar a perda dos registros realizados durante períodos sem conectividade.

**Justificativa:**  
O ACS poderá coletar informações durante as visitas e, posteriormente, ao retornar à UBS e conectar-se à internet, permitir que os registros anônimos sejam enviados ao Firebase.'

---

## 2.2. Requisitos funcionais

### RF01 — Iniciar avaliação
O sistema deve permitir que o usuário inicie uma nova avaliação de risco cardiovascular.

### RF02 — Registrar dados demográficos e comportamentais
O sistema deve permitir o registro de idade, sexo, tabagismo e diabetes do paciente.

### RF03 — Registrar dados clínicos
O sistema deve permitir o registro da pressão arterial, colesterol total e HDL do paciente.

### RF04 — Validar campos
O sistema deve verificar se os campos obrigatórios foram preenchidos antes de realizar o cálculo.

### RF05 — Informar erros de preenchimento
O sistema deve informar ao usuário quando um dado obrigatório estiver ausente ou possuir valor inválido.

### RF06 — Calcular risco cardiovascular
O sistema deve calcular o risco percentual de ocorrência de um evento cardiovascular em 10 anos a partir dos dados informados.

### RF07 — Classificar o risco
O sistema deve classificar o resultado da avaliação como baixo, intermediário ou alto risco.

### RF08 — Exibir percentual de risco
O sistema deve apresentar ao usuário o percentual de risco cardiovascular obtido na avaliação.

### RF09 — Exibir velocímetro
O sistema deve apresentar o resultado por meio de um velocímetro com ponteiro indicando visualmente o nível de risco.

### RF10 — Apresentar recomendações
O sistema deve apresentar orientações de prevenção ou encaminhamento de acordo com a classificação do risco calculado.

### RF11 — Realizar avaliação offline
O sistema deve permitir que o usuário preencha os dados e realize a avaliação cardiovascular sem conexão com a internet.

### RF12 — Armazenar registros offline
O sistema deve armazenar localmente os registros realizados quando não houver conexão disponível.

### RF13 — Sincronizar registros
O sistema deve sincronizar os registros armazenados localmente quando uma conexão com a internet estiver disponível.

### RF14 — Manter registros anônimos
O sistema deve armazenar os registros sem nome ou CPF do paciente, utilizando somente apelido ou código interno quando necessário.

### RF15 — Excluir registros armazenados
O sistema deve permitir a exclusão definitiva dos registros armazenados, conforme as regras de privacidade definidas para o aplicativo.

---

## 2.3. Requisitos não funcionais

### RNF01 — Usabilidade
A funcionalidade principal deverá seguir um fluxo simples, permitindo abrir o aplicativo, preencher os dados necessários e selecionar "Avaliar Risco", sem etapas intermediárias desnecessárias.

### RNF02 — Limite de perguntas
O formulário utilizado para realizar a avaliação deverá possuir no máximo 7 perguntas, conforme definido no estudo de caso.

### RNF03 — Quantidade de telas
O aplicativo deverá possuir no máximo 4 telas principais para realização e apresentação da avaliação cardiovascular.

### RNF04 — Legibilidade e acessibilidade visual
A interface deverá possuir alto contraste entre textos, fundos e elementos interativos, garantindo boa legibilidade inclusive durante utilização em ambientes externos e sob forte iluminação solar.

### RNF05 — Privacidade
Os registros armazenados não deverão conter nome ou CPF do paciente. Quando necessário identificar um registro, deverá ser utilizado apenas um apelido ou código interno.

### RNF06 — Proteção e exclusão dos dados
O tratamento e armazenamento dos dados deverão respeitar princípios de privacidade e proteção de dados aplicáveis, incluindo a possibilidade de exclusão definitiva dos registros armazenados.

### RNF07 — Desempenho
O aplicativo deverá apresentar funcionamento fluido em smartphones básicos com aproximadamente 2 GB a 4 GB de memória RAM, evitando bibliotecas gráficas excessivamente pesadas.

### RNF08 — Compatibilidade de tela
A interface deverá permanecer utilizável e legível em smartphones com resolução HD de 720p.

### RNF09 — Conectividade
A funcionalidade principal do aplicativo não deverá depender de conexão com a internet. A sincronização de dados deverá ocorrer posteriormente quando uma conexão estiver disponível.

### RNF10 — Armazenamento
Quando estiver offline, o aplicativo deverá manter os registros em armazenamento local até que a sincronização com o serviço remoto seja concluída.

---

### Observação sobre privacidade e LGPD

Como o CardioRisco trabalha com informações relacionadas à saúde, a privacidade deve ser considerada desde o desenvolvimento da aplicação.

O projeto deverá reduzir ao mínimo a identificação dos pacientes, evitando armazenar nome e CPF e utilizando somente os dados necessários para a finalidade da avaliação.

A implementação futura deverá observar os princípios e obrigações aplicáveis da Lei Geral de Proteção de Dados Pessoais (LGPD), principalmente no tratamento de dados relacionados à saúde.