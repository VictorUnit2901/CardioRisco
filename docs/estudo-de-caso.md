# Análise do Estudo de Caso — CardioRisco

## 1. Visão geral do projeto

O **CardioRisco** é um aplicativo voltado para auxiliar profissionais da atenção básica na avaliação do risco de desenvolvimento de doenças cardiovasculares.

A proposta é permitir que informações clínicas e comportamentais do paciente sejam inseridas de maneira rápida durante um atendimento ou visita domiciliar, possibilitando o cálculo do risco percentual de ocorrência de um evento cardiovascular nos próximos 10 anos.

Mais do que apenas apresentar um número, o aplicativo deve funcionar como uma ferramenta de apoio ao profissional de saúde e também como um recurso educativo para o paciente, tornando o risco cardiovascular mais fácil de visualizar e compreender.

---

## 2.1. Problema

O principal problema que o aplicativo pretende ajudar a solucionar é a dificuldade de **avaliar e comunicar de maneira rápida e compreensível o risco cardiovascular de um paciente**, principalmente durante atendimentos realizados fora de ambientes hospitalares ou de consultórios.

Doenças cardiovasculares podem estar relacionadas a diversos fatores, como idade, pressão arterial, colesterol, tabagismo e diabetes. Durante uma visita domiciliar, o profissional precisa considerar várias dessas informações para compreender a situação do paciente.

O CardioRisco busca simplificar esse processo ao reunir os principais dados necessários em um formulário e apresentar uma classificação do risco cardiovascular.

Esse problema é relevante porque a identificação de fatores de risco pode contribuir para a **prevenção primária**, permitindo que o profissional oriente o paciente antes da ocorrência de eventos mais graves, como infartos ou derrames.

Além disso, simplesmente informar ao paciente um percentual pode não ser suficiente. Muitos pacientes são leigos em relação aos conceitos médicos utilizados no cálculo. Por isso, existe também a necessidade de **transformar o resultado do cálculo em uma informação visual e fácil de compreender**.

Assim, a principal necessidade que a solução deverá atender é:

> Permitir que o profissional de saúde avalie rapidamente o risco cardiovascular e consiga explicar esse risco de maneira simples ao paciente, apoiando decisões de prevenção ou encaminhamento.

---

## 2.2. Público e usuários

### Agentes Comunitários de Saúde — ACS

Os Agentes Comunitários de Saúde representam um dos principais usuários do aplicativo.

Eles possuem contato direto com a população e realizam frequentemente visitas domiciliares, inclusive em regiões periféricas ou rurais.

Para esse público, o aplicativo precisa principalmente proporcionar:

* rapidez no preenchimento das informações;
* facilidade de utilização;
* tolerância a erros de digitação;
* funcionamento mesmo sem conexão com a internet;
* boa visualização em ambientes externos;
* resultado fácil de apresentar e explicar ao paciente.

O ACS poderá utilizar o CardioRisco durante uma visita domiciliar, inserindo os dados do paciente e realizando a avaliação diretamente pelo smartphone.

Nesse contexto, o aplicativo não deve aumentar significativamente o tempo da visita. Por isso, o processo de avaliação precisa possuir poucas etapas.

---

### Enfermeiros

Os enfermeiros também fazem parte do público-alvo e podem utilizar o aplicativo como ferramenta de apoio durante atendimentos de atenção básica.

A necessidade desse público está relacionada principalmente à organização das informações do paciente e à obtenção rápida de uma classificação de risco.

O aplicativo pode auxiliar na identificação de pessoas que necessitam de maior atenção, orientação preventiva ou encaminhamento.

---

### Médicos da atenção básica

Os médicos podem utilizar as informações apresentadas pelo CardioRisco como apoio durante a avaliação do paciente.

Para esse público, é importante que o aplicativo apresente as informações de maneira clara e que o resultado esteja relacionado aos dados clínicos coletados.

A aplicação não pretende substituir a avaliação médica. Ela funciona como uma ferramenta de apoio à avaliação de risco e à comunicação com o paciente.

---

### Pacientes

Apesar de não serem apresentados como os principais operadores do aplicativo, os pacientes também possuem participação importante na experiência.

O estudo de caso indica que pacientes leigos poderão ter contato com a aplicação sob supervisão do agente de saúde.

Nesse caso, sua principal necessidade é **compreender o significado do resultado**.

Por isso, a tela de resultado deve evitar depender exclusivamente de números ou termos técnicos. Recursos visuais, principalmente o velocímetro de risco, deverão ajudar o profissional a explicar a situação ao paciente.

---

## 2.3. Contexto de uso

O contexto de utilização possui grande influência sobre o desenvolvimento do CardioRisco.

### Visitas domiciliares

Um dos principais cenários de utilização será durante visitas realizadas pelos Agentes Comunitários de Saúde.

Isso significa que o aplicativo poderá ser utilizado:

* dentro da residência do paciente;
* em quintais;
* em calçadas;
* em regiões periféricas;
* em áreas rurais;
* em outros locais fora de uma unidade de saúde.

Por esse motivo, a aplicação precisa ser simples e permitir que a avaliação seja realizada rapidamente.

---

### Conectividade limitada ou inexistente

Nem todas as regiões visitadas pelo ACS possuem conexão estável com a internet.

Consequentemente, o funcionamento principal do aplicativo **não pode depender de conexão permanente**.

Os dados deverão poder ser registrados localmente no dispositivo. Posteriormente, quando o profissional retornar a um local com conexão, como a UBS, os registros anônimos poderão ser sincronizados com o Firebase.

Essa característica evita que a ausência de internet impeça a realização da avaliação.

---

### Uso em ambientes externos

O aplicativo poderá ser utilizado sob forte iluminação solar.

Esse contexto afeta diretamente as decisões de interface, pois telas com baixo contraste podem dificultar a leitura.

Por esse motivo, a interface deve priorizar:

* alto contraste;
* textos de fácil leitura;
* elementos visuais claramente identificáveis;
* cores que continuem visíveis em ambientes iluminados.

O estudo de caso sugere inclusive a utilização de uma interface escura com textos claros ou cores de destaque.

Além da legibilidade, essa escolha pode evitar que o ACS precise manter o brilho máximo da tela durante todo o atendimento, contribuindo para a economia de bateria.

---

### Nível de atenção do usuário

Durante uma visita domiciliar, o profissional pode estar conversando com o paciente enquanto consulta informações e utiliza o smartphone.

Portanto, sua atenção não estará exclusivamente concentrada no aplicativo.

A interface deverá reduzir a carga de atenção necessária, evitando:

* excesso de informações simultâneas;
* formulários muito extensos;
* textos desnecessariamente longos;
* etapas confusas;
* navegação complexa.

O preenchimento deve ser simples, rápido e guiado.

---

### Dispositivo

O aplicativo deverá funcionar em smartphones básicos, inclusive aparelhos com aproximadamente 2 GB a 4 GB de memória RAM e resolução HD de 720p.

Isso significa que o projeto deverá evitar animações, gráficos ou bibliotecas excessivamente pesadas que possam prejudicar o desempenho.

A experiência deve permanecer fluida mesmo em dispositivos de menor capacidade.

---

### Situação de utilização

O CardioRisco está relacionado principalmente à **prevenção e avaliação de risco**, e não ao atendimento emergencial de um evento cardiovascular em andamento.

Por isso, a prioridade é permitir a identificação do risco futuro e apoiar orientações preventivas ou encaminhamentos adequados.

---

## 2.4. Objetivo e proposta de valor

O objetivo do CardioRisco é transformar diferentes informações clínicas e comportamentais do paciente em uma avaliação simples do risco de ocorrência de um evento cardiovascular nos próximos 10 anos.

Sua proposta de valor está na combinação de três elementos:

**agilidade, prevenção e compreensão.**

O aplicativo deverá permitir que um profissional realize a avaliação rapidamente durante um atendimento e consiga mostrar o resultado de forma visual para o paciente.

Dessa maneira, o sistema não funciona apenas como uma calculadora. Ele também se torna uma ferramenta educativa.

O benefício para o profissional é possuir uma ferramenta rápida e acessível para apoiar a avaliação.

Para o paciente, o benefício está em compreender melhor seu próprio risco e perceber a importância de mudanças de hábitos ou da procura por acompanhamento profissional quando necessário.

---

## 2.5. Personalidade, identidade e experiência

### Palavras conceituais

O estudo de caso apresenta conceitos diretamente relacionados à proposta do aplicativo, como:

* Prevenção Primária;
* Hipertensão Arterial Sistêmica — HAS;
* Dislipidemia;
* Escore de Risco;
* Framingham;
* LDL;
* HDL.

Esses conceitos demonstram que a identidade do aplicativo está relacionada à prevenção e à avaliação cardiovascular.

Entretanto, como parte da experiência envolve pacientes leigos, esses termos não devem tornar a interface difícil de compreender.

---

### Personalidade da identidade

A personalidade proposta é **preventiva e educacional**.

Ao mesmo tempo, o aplicativo deve transmitir a seriedade associada a uma avaliação médica.

Isso significa que a interface não deve parecer excessivamente informal ou semelhante a um aplicativo de entretenimento.

Por outro lado, seriedade não significa apresentar apenas números, tabelas ou textos técnicos.

Elementos gráficos deverão facilitar a compreensão dos resultados.

---

### Tom da interface

O tom da interface deve ser:

* claro;
* objetivo;
* confiável;
* profissional;
* educativo;
* visualmente didático.

A interface deve transmitir segurança ao profissional sem tornar o processo de utilização complexo.

---

### Tom da experiência do usuário

A experiência deverá ser guiada passo a passo.

Como existem diferentes dados necessários para realizar o cálculo, apresentar todas as informações de maneira desorganizada poderia causar sensação de complexidade.

Por isso, a organização progressiva do formulário deve orientar o usuário durante o processo.

O usuário deverá perceber claramente:

1. quais informações precisa fornecer;
2. em qual etapa está;
3. quando poderá realizar o cálculo;
4. qual foi o resultado;
5. o que aquele resultado significa.

---

### Como o aplicativo deseja ser lembrado

O conceito apresentado pelo projeto é:

**“A régua digital que mede o futuro do coração do paciente.”**

Essa ideia reforça que o CardioRisco deve ser lembrado principalmente como uma ferramenta simples de avaliação preventiva.

O velocímetro possui papel importante nessa identidade porque transforma uma probabilidade abstrata em algo visualmente comparável a um indicador de alerta.

---

## 2.6. Funcionalidades e características já definidas

### Funcionalidade: Formulário de dados demográficos e comportamentais

Deverá permitir o preenchimento de informações como idade, sexo, tabagismo e diabetes.

**Necessidade atendida:** reunir fatores necessários para realizar a avaliação cardiovascular.

---

### Funcionalidade: Formulário de dados clínicos

Deverá permitir o registro de informações como pressão arterial, colesterol total e HDL.

**Necessidade atendida:** incluir dados clínicos necessários para o cálculo do risco.

---

### Funcionalidade: Avaliação do risco cardiovascular

Após o preenchimento, o usuário deverá tocar em **“Avaliar Risco”**.

**Necessidade atendida:** transformar os dados informados em uma avaliação compreensível para o profissional.

---

### Funcionalidade: Classificação do risco

O resultado deverá ser classificado como:

* risco baixo;
* risco intermediário;
* risco alto.

**Necessidade atendida:** permitir uma interpretação mais rápida do resultado, evitando que o usuário precise analisar somente um percentual.

---

### Funcionalidade: Velocímetro de risco

A tela de resultado deverá obrigatoriamente possuir um velocímetro com ponteiro indicando o risco calculado.

**Necessidade atendida:** tornar o resultado mais visual e facilitar a explicação do risco para pacientes leigos.

---

### Funcionalidade: Recomendações

Após apresentar a classificação, o aplicativo deverá fornecer orientações relacionadas ao resultado, como mudanças no estilo de vida ou indicação de encaminhamento.

**Necessidade atendida:** mostrar ao profissional e ao paciente quais ações podem estar relacionadas ao nível de risco identificado.

---

### Funcionalidade: Funcionamento offline

O aplicativo deverá permitir a coleta de informações mesmo sem acesso à internet.

**Necessidade atendida:** possibilitar a utilização em regiões rurais, periferias ou locais com conectividade limitada.

---

### Funcionalidade: Armazenamento temporário local

Quando estiver offline, os dados deverão permanecer armazenados em uma fila local.

**Necessidade atendida:** evitar a perda das avaliações realizadas durante períodos sem conexão.

---

### Funcionalidade: Sincronização em segundo plano

Quando o dispositivo voltar a possuir acesso à internet, como no retorno do ACS à UBS, os registros anônimos deverão ser enviados ao Firebase.

**Necessidade atendida:** permitir que a coleta de informações não dependa de conectividade contínua.

---

### Funcionalidade: Anonimização dos dados

Os registros armazenados não deverão conter CPF ou nome do paciente.

**Necessidade atendida:** reduzir a exposição de informações pessoais e respeitar o compromisso de privacidade estabelecido pelo projeto.

---

## 2.7. Restrições e condições

O estudo de caso estabelece diversas restrições que deverão ser consideradas durante o desenvolvimento.

### Quantidade de telas

O protótipo deverá possuir no máximo **4 telas principais**:

1. dados demográficos e comportamentais;
2. dados clínicos;
3. resultado do risco cardiovascular;
4. explicação e recomendações.

Essa limitação exige uma navegação simples e evita que o processo fique excessivamente fragmentado.

---

### Número de perguntas

O formulário não deverá possuir mais de **7 perguntas**.

Essa restrição busca evitar abandono da avaliação durante uma visita.

Portanto, somente informações realmente necessárias devem ocupar espaço no fluxo principal.

---

### Quantidade de interações

A funcionalidade principal deverá ser realizada em até **3 interações principais**:

1. abrir o aplicativo;
2. preencher os dados;
3. tocar em “Avaliar Risco”.

O resultado deverá aparecer imediatamente na tela seguinte.

Isso reforça a necessidade de reduzir etapas intermediárias.

---

### Funcionamento offline

A ausência de conexão não poderá impedir a realização da avaliação.

Por isso, o aplicativo deverá possuir armazenamento local e sincronização posterior.

---

### Privacidade

Existe um compromisso de anonimização dos registros armazenados.

O sistema não deverá utilizar nome ou CPF no histórico salvo, utilizando somente apelidos ou códigos internos quando necessário.

Também deverá existir uma política clara de privacidade relacionada à exclusão definitiva das informações armazenadas no Firebase.

---

### Dispositivos

A aplicação deverá funcionar em smartphones básicos, com aproximadamente:

* 2 GB a 4 GB de RAM;
* resolução HD de 720p.

Portanto, desempenho e consumo de recursos precisam ser considerados durante o desenvolvimento.

---

### Tamanho e desempenho

O aplicativo desenvolvido em Flutter deverá possuir um APK enxuto.

Bibliotecas gráficas muito pesadas devem ser evitadas, principalmente porque poderiam causar travamentos durante a rolagem do formulário em aparelhos básicos.

---

### Ambiente de utilização

A utilização sob luz solar forte exige uma interface com alto contraste.

Elementos importantes não podem depender de diferenças muito sutis de tonalidade para serem identificados.

---

### Visualização obrigatória

A terceira tela deverá possuir um **velocímetro com ponteiro**.

Essa não é apenas uma decisão estética, mas uma característica funcional definida pelo estudo de caso.

---

## 2.8. Pontos de atenção

Após analisar o estudo de caso, consideramos três aspectos especialmente importantes para o sucesso do CardioRisco.

### 1. Agilidade e simplicidade durante a avaliação

Esse é um dos aspectos mais importantes porque o principal usuário poderá utilizar o aplicativo durante visitas domiciliares.

O ACS não pode gastar grande parte do atendimento navegando por várias telas ou preenchendo formulários muito extensos.

As limitações de até sete perguntas, quatro telas e poucas interações demonstram que a velocidade de utilização é uma prioridade do projeto.

Se o aplicativo for demorado ou complicado, existe o risco de o profissional deixar de utilizá-lo durante as visitas.

Por isso, a experiência precisa priorizar campos simples, respostas rápidas, poucos passos e navegação intuitiva.

---

### 2. Comunicação visual do risco ao paciente

O aplicativo não deverá apenas calcular corretamente o risco. Ele também precisa fazer com que esse resultado seja compreendido.

Essa necessidade é especialmente importante porque o paciente pode não possuir conhecimento sobre termos médicos ou interpretação de percentuais.

O velocímetro obrigatório contribui diretamente para essa finalidade.

Ao associar o risco a um indicador visual semelhante a um painel de alerta, o profissional pode utilizar a própria tela do celular para explicar a situação do paciente.

Portanto, o sucesso do aplicativo também depende de transformar informações clínicas em uma comunicação visual simples, objetiva e educativa.

---

### 3. Funcionamento confiável mesmo em condições desfavoráveis

O CardioRisco poderá ser utilizado em regiões sem internet, sob luz solar forte e em smartphones de menor desempenho.

Essas condições fazem com que aspectos técnicos que poderiam ser considerados secundários em outros aplicativos se tornem fundamentais neste projeto.

O funcionamento offline permite que o ACS continue realizando avaliações mesmo sem conectividade.

O alto contraste garante que as informações continuem legíveis em ambientes externos.

O baixo consumo de recursos permite que o aplicativo funcione adequadamente em dispositivos mais simples.

Portanto, o aplicativo precisa ser desenvolvido considerando o ambiente real de utilização, e não apenas condições ideais de laboratório.
