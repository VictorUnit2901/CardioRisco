# Benchmark — CardioRisco

## 1. Objetivo

O objetivo deste benchmark é analisar soluções existentes relacionadas à avaliação de risco cardiovascular, identificando funcionalidades, pontos positivos, limitações e decisões de interface que possam contribuir para o desenvolvimento do CardioRisco.

Foram analisadas três soluções:

1. CVD Risk Estimator Plus — American College of Cardiology (ACC);
2. ESC CVD Risk Calculation App — European Society of Cardiology (ESC);
3. Framingham Risk Score — MDCalc.

A comparação tem como foco principalmente a experiência de uso e a forma como essas ferramentas coletam informações e apresentam o risco cardiovascular.

Os modelos clínicos utilizados pelas ferramentas não devem ser copiados diretamente para o CardioRisco, pois cada solução possui público, população de referência e regras clínicas próprias.

---

## 2. CVD Risk Estimator Plus — American College of Cardiology

### 2.1. Visão geral

O CVD Risk Estimator Plus é uma ferramenta de apoio à decisão clínica desenvolvida pelo American College of Cardiology.

A solução está disponível tanto como aplicativo para dispositivos móveis quanto em versão web.

A ferramenta reúne dois modelos de cálculo: as Pooled Cohort Equations (PCE) e as equações PREVENT. Com isso, pode apresentar diferentes estimativas de risco cardiovascular, incluindo risco em 10 e 30 anos.

### 2.2. Principais funcionalidades

A solução permite calcular diferentes tipos de risco cardiovascular utilizando informações como idade, sexo, pressão arterial, colesterol, tabagismo e diabetes.

Na utilização do modelo PREVENT, também podem ser considerados fatores relacionados à saúde metabólica e renal.

Além do cálculo, a ferramenta oferece:

- classificação do risco;
- recomendações relacionadas à prevenção;
- orientações de estilo de vida;
- comparação entre modelos de cálculo;
- possibilidade de exportar resultados;
- materiais adicionais para profissionais e pacientes.

### 2.3. Pontos positivos

Um dos principais pontos positivos é não apresentar apenas um percentual. A ferramenta transforma o resultado em uma classificação, como baixo, limítrofe, intermediário ou alto risco.

Esse tipo de classificação facilita a interpretação do resultado e pode melhorar a conversa entre profissional e paciente.

Outro ponto positivo é a presença de recomendações relacionadas ao risco identificado. Dessa forma, o resultado não representa o final da experiência: a aplicação também auxilia na compreensão das possíveis ações posteriores.

A possibilidade de exportar os resultados também é interessante para contextos profissionais.

### 2.4. Pontos negativos

A quantidade de informações e recursos disponíveis pode aumentar a complexidade da aplicação para usuários que precisam apenas realizar uma avaliação rápida.

Para o contexto do CardioRisco, principalmente durante uma visita domiciliar de um ACS, oferecer vários modelos, opções e recursos ao mesmo tempo poderia aumentar a carga cognitiva e o tempo necessário para realizar a tarefa.

Também existem campos clínicos mais avançados no modelo PREVENT que podem não estar disponíveis durante uma visita domiciliar comum.

### 2.5. Interface e experiência

A solução é orientada ao uso clínico e organiza o processo em torno da entrada dos dados do paciente, cálculo do risco e apresentação das recomendações.

Um aspecto relevante é a separação entre o valor numérico do risco e sua classificação clínica.

A aplicação também foi projetada para apoiar a conversa entre profissional e paciente, e não apenas para fornecer um número isolado.

### 2.6. O que pode ser aproveitado no CardioRisco

O CardioRisco pode aproveitar principalmente:

- apresentação do percentual junto com uma categoria de risco;
- recomendações após o cálculo;
- utilização do resultado como ferramenta de comunicação entre profissional e paciente;
- separação clara entre entrada de dados e resultado.

Entretanto, o CardioRisco deverá possuir um fluxo mais simples, adequado à rapidez exigida durante visitas domiciliares.

---

## 3. ESC CVD Risk Calculation App — European Society of Cardiology

### 3.1. Visão geral

O ESC CVD Risk Calculation App é uma aplicação desenvolvida pela European Society of Cardiology para auxiliar profissionais de saúde na avaliação individual do risco cardiovascular.

A ferramenta está disponível para Android e iOS.

Um diferencial é reunir diferentes calculadoras cardiovasculares dentro do mesmo aplicativo, permitindo selecionar a ferramenta mais apropriada de acordo com o perfil do paciente.

### 3.2. Principais funcionalidades

A aplicação possui diferentes modelos de risco, incluindo:

- SCORE2;
- SCORE2-OP;
- SCORE2-Diabetes;
- ASCVD;
- ADVANCE;
- SMART;
- outros modelos destinados a diferentes populações.

Dependendo do modelo escolhido, podem ser apresentadas estimativas de risco em até 10 anos ou ao longo da vida.

O aplicativo também auxilia o profissional na escolha da calculadora adequada para o paciente.

### 3.3. Pontos positivos

Um ponto positivo importante é a possibilidade de adaptar a avaliação ao perfil do paciente.

A solução também apresenta forte caráter visual. As imagens oficiais disponibilizadas pela ESC mostram a utilização de um medidor semelhante a um velocímetro para representar o risco calculado.

Essa representação reduz a dependência exclusiva de números e permite identificar visualmente a intensidade do risco.

Outro ponto positivo é a organização do aplicativo como uma ferramenta específica para avaliação cardiovascular, evitando funcionalidades sem relação com esse objetivo.

### 3.4. Pontos negativos

A presença de diversas calculadoras pode tornar a primeira etapa mais complexa para usuários que não conhecem os diferentes modelos.

É necessário compreender qual calculadora é adequada para determinada população antes de iniciar a avaliação.

Além disso, a aplicação é destinada principalmente a profissionais de saúde e está disponível em inglês, o que pode limitar seu uso direto por alguns usuários brasileiros.

Para um ACS que necessita realizar rapidamente uma avaliação durante uma visita, escolher entre diversos modelos antes de preencher os dados poderia adicionar uma etapa desnecessária.

### 3.5. Interface e experiência

Um aspecto bastante relevante para o CardioRisco é a utilização de um indicador visual para apresentar o resultado.

O formato de medidor aproxima um valor abstrato de risco de uma representação que pode ser identificada rapidamente pelo usuário.

A aplicação também organiza os dados do paciente antes de apresentar o resultado, mantendo uma separação clara entre coleta e avaliação.

### 3.6. O que pode ser aproveitado no CardioRisco

O principal elemento que pode ser aproveitado é a utilização de uma representação visual semelhante a um velocímetro.

Esse recurso possui relação direta com o requisito estabelecido no estudo de caso do CardioRisco.

Também pode ser aproveitada a ideia de apresentar uma classificação visual de risco sem eliminar o percentual numérico.

Por outro lado, o CardioRisco deve evitar exigir que o ACS escolha entre diferentes métodos de cálculo durante a utilização. O modelo adequado deve estar definido pela aplicação, reduzindo a quantidade de decisões necessárias.

---

## 4. Framingham Risk Score — MDCalc

### 4.1. Visão geral

O MDCalc é uma plataforma de calculadoras clínicas utilizada por profissionais de saúde.

Entre as ferramentas disponíveis está o Framingham Risk Score, que estima o risco de ocorrência de eventos coronarianos em um período de 10 anos.

O Framingham possui relação importante com o CardioRisco, pois aparece entre os conceitos apresentados no estudo de caso do projeto.

### 4.2. Principais funcionalidades

A calculadora analisada utiliza informações como:

- idade;
- sexo;
- tabagismo;
- colesterol total;
- HDL;
- pressão arterial sistólica;
- uso ou não de medicamento para pressão arterial.

Após o preenchimento dos campos, a ferramenta apresenta a estimativa de risco.

Além disso, a página apresenta orientações sobre interpretação do resultado, limitações do escore e possíveis condutas relacionadas às diferentes classificações.

### 4.3. Pontos positivos

O principal ponto positivo é a simplicidade do formulário.

Os campos necessários ficam diretamente relacionados ao cálculo e não existem muitas etapas intermediárias.

Essa característica permite que um profissional que já possui as informações do paciente obtenha o resultado rapidamente.

Outro ponto positivo é apresentar informações sobre como interpretar o resultado, deixando claro que o cálculo não deve substituir o julgamento clínico.

### 4.4. Pontos negativos

A ferramenta faz parte de uma plataforma com muitas outras calculadoras médicas e, portanto, não foi construída especificamente para a experiência de um ACS durante uma visita domiciliar.

A apresentação do resultado possui caráter mais clínico e técnico, sendo menos direcionada à explicação para pacientes leigos.

Além disso, o próprio MDCalc informa que esse modelo de Framingham foi amplamente utilizado historicamente, mas atualmente existem modelos mais recentes para avaliação cardiovascular.

### 4.5. Interface e experiência

A interface prioriza eficiência.

Os campos aparecem em uma sequência simples e possuem controles diretos, como opções de sim/não e entradas numéricas.

Esse formato reduz o número de ações necessárias para realizar o cálculo.

Por outro lado, a experiência é mais adequada para um profissional que já conhece os conceitos médicos apresentados. Termos como HDL, pressão sistólica e tratamento anti-hipertensivo podem não ser facilmente compreendidos por pacientes.

### 4.6. O que pode ser aproveitado no CardioRisco

O CardioRisco pode aproveitar principalmente a simplicidade da entrada de dados.

Campos objetivos e escolhas diretas podem contribuir para que a avaliação seja realizada rapidamente.

Entretanto, a apresentação do resultado deverá ser mais visual e didática do que a encontrada em uma calculadora clínica tradicional.

---

## 5. O que o CardioRisco poderá fazer de diferente ou melhor?

A análise mostra que já existem boas ferramentas para cálculo de risco cardiovascular. Portanto, o diferencial do CardioRisco não deve ser simplesmente realizar um cálculo que outras soluções também realizam.

O principal diferencial está em adaptar a experiência ao contexto específico dos profissionais da atenção básica, principalmente dos Agentes Comunitários de Saúde durante visitas domiciliares.

Enquanto algumas ferramentas analisadas oferecem grande quantidade de recursos e diferentes modelos clínicos, o CardioRisco deverá priorizar um fluxo curto e direcionado.

O profissional não deverá precisar decidir qual calculadora utilizar, navegar por diversas opções ou interpretar uma grande quantidade de informações antes de chegar ao resultado.

O CardioRisco poderá combinar os melhores elementos identificados no benchmark:

- a classificação e as recomendações do CVD Risk Estimator Plus;
- a comunicação visual por meio de medidor observada na solução da ESC;
- a simplicidade de preenchimento encontrada no MDCalc.

Ao mesmo tempo, o aplicativo acrescentará características específicas do estudo de caso que não representam o foco principal das soluções analisadas, como funcionamento offline, armazenamento temporário, anonimização, alto contraste para utilização em ambientes externos, poucas perguntas e um fluxo de utilização reduzido.

Dessa forma, o principal diferencial do CardioRisco será transformar a avaliação cardiovascular em uma experiência rápida, visual e adequada à realidade de uma visita domiciliar, permitindo que o ACS utilize o próprio smartphone como ferramenta de avaliação e também de comunicação do risco ao paciente.

---

## 6. Fontes consultadas

1. American College of Cardiology. CVD Risk Estimator Plus. 2026.
2. European Society of Cardiology. ESC CVD Risk Calculation App.
3. European Society of Cardiology. SCORE2 and SCORE2-OP Calculators.
4. MDCalc. Framingham Risk Score for Hard Coronary Heart Disease.