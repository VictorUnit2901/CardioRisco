# Pesquisa — CardioRisco

## 1. Objetivo da pesquisa

Esta pesquisa tem como objetivo aprofundar a compreensão do problema abordado pelo CardioRisco e do contexto de seus principais usuários.

Foram pesquisadas informações relacionadas à relevância das doenças cardiovasculares, fatores de risco, prevenção, atuação dos profissionais da Atenção Primária à Saúde, condições de conectividade em áreas rurais e formas de comunicar o risco cardiovascular aos pacientes.

As informações encontradas serão utilizadas para orientar decisões relacionadas às funcionalidades, interface, funcionamento offline e apresentação dos resultados do aplicativo.

---

## 2. Informações relevantes sobre o problema

### 2.1. Relevância das doenças cardiovasculares

As doenças cardiovasculares representam um importante problema de saúde pública.

Segundo a Organização Mundial da Saúde (OMS), as doenças cardiovasculares são a principal causa de morte no mundo. Em 2022, aproximadamente 19,8 milhões de pessoas morreram em decorrência dessas doenças, correspondendo a cerca de 32% das mortes globais. Aproximadamente 85% dessas mortes foram causadas por infarto ou acidente vascular cerebral (AVC).

A OMS também destaca que grande parte das doenças cardiovasculares pode ser prevenida por meio do controle de fatores de risco comportamentais e clínicos. Entre eles estão tabagismo, alimentação inadequada, sedentarismo, pressão arterial elevada, glicemia elevada e alterações nos níveis de lipídios.

Dessa forma, identificar fatores de risco antes da ocorrência de um evento cardiovascular possui grande importância para a prevenção.

### 2.2. Avaliação do risco cardiovascular

A avaliação do risco cardiovascular não depende de apenas uma característica do paciente. Diferentes fatores precisam ser analisados em conjunto.

A Atualização da Diretriz de Prevenção Cardiovascular da Sociedade Brasileira de Cardiologia de 2019 destaca fatores de risco clássicos como hipertensão arterial, dislipidemia, obesidade, sedentarismo, tabagismo, diabetes e histórico familiar.

Essa característica reforça a necessidade de o aplicativo coletar informações clínicas e comportamentais de maneira organizada antes de apresentar um resultado.

O Escore de Risco Global utilizado no Brasil considera diferentes informações para estimar a probabilidade de ocorrência de eventos cardiovasculares. Estudos baseados no modelo de Framingham consideram informações como sexo, idade, colesterol total, HDL, pressão arterial, tabagismo e diabetes.

Portanto, um aplicativo de avaliação cardiovascular precisa apresentar os campos de forma clara e reduzir a possibilidade de preenchimento incorreto, pois os dados informados interferem diretamente no resultado calculado.

### 2.3. Atualização das diretrizes cardiovasculares

Durante a pesquisa foi identificada uma atualização que merece atenção durante o desenvolvimento.

O estudo de caso do CardioRisco apresenta o Escore de Risco Global e o modelo de Framingham como referências para o cálculo cardiovascular. Entretanto, a Diretriz Brasileira de Dislipidemias e Prevenção da Aterosclerose de 2025, publicada pela Sociedade Brasileira de Cardiologia, apresenta o escore PREVENT como ferramenta preferencial para estratificação de risco em adultos sem doença cardiovascular aterosclerótica conhecida.

Essa diferença não significa que o grupo deverá modificar automaticamente a regra definida pelo estudo de caso. Porém, demonstra a importância de validar qual diretriz e qual versão do modelo de cálculo serão adotadas antes da implementação definitiva do algoritmo.

Para o projeto acadêmico, a especificação fornecida no estudo de caso deverá ser respeitada, mas a existência de diretrizes mais recentes deve ser registrada como um ponto de atenção.

---

## 3. Necessidades e dificuldades dos usuários

### 3.1. Agentes Comunitários de Saúde

Os Agentes Comunitários de Saúde (ACS) são usuários especialmente importantes para o CardioRisco.

Segundo o Ministério da Saúde, fazem parte das responsabilidades do ACS realizar visitas domiciliares, identificar problemas de saúde na comunidade, promover ações educativas e de prevenção e atuar como ligação entre a população e a equipe de saúde.

Essas atribuições mostram que o aplicativo precisa funcionar como uma ferramenta de apoio durante uma atividade que já envolve diversas responsabilidades.

O ACS não estará utilizando o smartphone em um ambiente controlado e com atenção exclusiva ao aplicativo. Durante uma visita domiciliar, ele poderá precisar conversar com o paciente, coletar informações, realizar orientações e registrar dados.

Por isso, algumas necessidades importantes são:

- preenchimento rápido;
- poucos campos e etapas;
- linguagem objetiva;
- prevenção de erros de preenchimento;
- resultado fácil de interpretar;
- possibilidade de utilizar a tela como apoio na explicação ao paciente.

Uma interface muito complexa ou um formulário excessivamente longo poderia prejudicar a utilização durante a rotina de trabalho.

### 3.2. Profissionais da atenção básica

Enfermeiros e médicos da atenção básica também fazem parte do público do CardioRisco.

Para esses profissionais, uma necessidade importante é que as informações apresentadas sejam confiáveis e tenham relação clara com os dados clínicos utilizados no cálculo.

A aplicação deve funcionar como ferramenta de apoio à avaliação e à prevenção, e não como substituição da decisão clínica do profissional.

Também é importante que o resultado seja apresentado de maneira rápida, pois a ferramenta poderá fazer parte de um atendimento que envolve outras avaliações e procedimentos.

### 3.3. Pacientes

Embora o paciente não seja o principal operador do aplicativo, ele é um usuário indireto muito importante.

Durante a visita, o profissional poderá utilizar o resultado apresentado pelo CardioRisco para explicar a situação cardiovascular do paciente e incentivar ações preventivas.

Uma dificuldade é que probabilidades e percentuais de risco podem não ser facilmente compreendidos por pessoas sem conhecimento técnico.

Pesquisas sobre comunicação de risco cardiovascular indicam que pacientes podem apresentar dificuldade para interpretar escores de risco, especialmente quando não possuem uma referência para entender o significado daquele número.

Por isso, apresentar apenas um resultado como "17%" não é suficiente. O aplicativo deve complementar o percentual com uma classificação compreensível, representação visual e explicação em linguagem simples.

---

## 4. Dados que podem influenciar o desenvolvimento do aplicativo

### 4.1. Conectividade em áreas rurais

O funcionamento offline definido para o CardioRisco possui relação direta com o contexto real em que o aplicativo poderá ser utilizado.

Dados da pesquisa TIC Domicílios 2024 mostram diferenças importantes entre áreas urbanas e rurais quanto ao acesso à tecnologia.

Entre os domicílios localizados em áreas rurais, 25% não possuíam computador nem acesso à internet, enquanto nas áreas urbanas esse percentual era de 15%.

Além disso, mesmo entre domicílios conectados existem diferenças no tipo e na qualidade da conexão disponível.

Esses dados indicam que não é adequado assumir que uma visita domiciliar sempre ocorrerá em um local com internet disponível e estável.

Para o CardioRisco, isso reforça a necessidade de:

- realizar o cálculo sem depender de conexão;
- salvar temporariamente os registros no dispositivo;
- impedir perda das informações caso não haja internet;
- sincronizar posteriormente quando uma conexão estiver disponível.

### 4.2. Apresentação e comunicação do risco

A forma como o resultado é apresentado possui importância semelhante ao próprio cálculo.

Pesquisas sobre comunicação de risco cardiovascular mostram que diferentes formas de apresentação podem afetar a compreensão e a reação do paciente.

Representações visuais podem auxiliar na comunicação, principalmente quando combinadas com informações personalizadas e explicações claras.

Entretanto, simplesmente acrescentar um gráfico não garante que a informação será compreendida corretamente. O recurso visual deve estar acompanhado de contexto e linguagem simples.

No CardioRisco, isso significa que a tela de resultado pode combinar:

- percentual de risco;
- classificação como baixo, intermediário ou alto;
- velocímetro;
- explicação curta sobre o significado da classificação;
- recomendação correspondente ao resultado.

Essa combinação permite que o profissional utilize o aplicativo não apenas para calcular, mas também para explicar o risco ao paciente.

---

## 5. Três descobertas importantes para o projeto

### Descoberta 1 — A prevenção depende da identificação e comunicação dos fatores de risco

As doenças cardiovasculares continuam entre os principais problemas de saúde pública e muitos de seus fatores de risco são modificáveis.

Isso significa que o CardioRisco não deve funcionar apenas como uma calculadora que apresenta um número. Após identificar o risco, a aplicação precisa ajudar o profissional a comunicar o resultado e orientar o paciente sobre prevenção.

**Influência no projeto:** a tela final deverá apresentar, além do percentual, uma classificação compreensível e recomendações relacionadas à prevenção ou necessidade de encaminhamento.

---

### Descoberta 2 — O aplicativo não pode depender de internet durante a visita

A pesquisa de conectividade mostra que ainda existem diferenças relevantes no acesso à internet, principalmente em áreas rurais.

Como o ACS realiza visitas diretamente no território, depender de uma conexão constante poderia impedir a utilização da principal funcionalidade do aplicativo.

**Influência no projeto:** o cálculo deverá funcionar offline. Os dados poderão ser armazenados temporariamente no dispositivo e sincronizados posteriormente quando houver conexão.

---

### Descoberta 3 — Mostrar apenas um percentual não garante que o paciente compreenda o risco

Pesquisas sobre comunicação de risco cardiovascular mostram que pacientes podem ter dificuldade em compreender escores e probabilidades isolados.

Isso é especialmente importante para o CardioRisco porque uma das finalidades da aplicação é ajudar o profissional a explicar o risco ao paciente durante uma visita.

**Influência no projeto:** o percentual deverá ser acompanhado de classificação, representação visual por velocímetro e uma explicação curta em linguagem acessível. O objetivo é tornar o resultado mais compreensível sem eliminar a informação numérica.

---

## 6. Fontes utilizadas

1. ORGANIZAÇÃO MUNDIAL DA SAÚDE (WHO). Cardiovascular diseases (CVDs). 31 jul. 2025.

2. BRASIL. Ministério da Saúde. Qual é o papel do Agente Comunitário de Saúde (ACS)?. Secretaria de Atenção Primária à Saúde, 27 fev. 2025.

3. CETIC.BR / NIC.BR. TIC Domicílios 2024 — Pesquisa sobre o uso das tecnologias de informação e comunicação nos domicílios brasileiros. 2024.

4. PRÉCOMA, Dalton Bertolim et al. Atualização da Diretriz de Prevenção Cardiovascular da Sociedade Brasileira de Cardiologia — 2019. Arquivos Brasileiros de Cardiologia, v. 113, n. 4, p. 787-891, 2019. DOI: 10.5935/abc.20190204.

5. RACHED, Fabiana Hanna et al. Diretriz Brasileira de Dislipidemias e Prevenção da Aterosclerose — 2025. Arquivos Brasileiros de Cardiologia, v. 122, n. 9, e20250640, 2025. DOI: 10.36660/abc.20250640.

6. LORENC, Theo et al. Communicating cardiovascular risk: systematic review of qualitative evidence. Patient Education and Counseling, v. 123, 108231, 2024. DOI: 10.1016/j.pec.2024.108231.