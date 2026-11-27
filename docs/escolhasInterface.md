# Escolhas de Interface — CardioRisco

## 1. Objetivo

Este documento apresenta as principais decisões de interface adotadas no protótipo do CardioRisco.

As escolhas foram realizadas considerando o estudo de caso, a pesquisa, o benchmark, as personas e os requisitos definidos nas atividades anteriores.

O principal objetivo da interface é permitir que o Agente Comunitário de Saúde realize uma avaliação cardiovascular de forma rápida e simples durante uma visita domiciliar e consiga apresentar o resultado ao paciente de maneira clara e visual.

---

## 2. Identidade visual

A identidade visual do CardioRisco foi desenvolvida para transmitir uma combinação de:

- saúde;
- prevenção;
- confiança;
- seriedade;
- clareza;
- facilidade de utilização.

O aplicativo não deve possuir aparência excessivamente informal, pois trabalha com informações relacionadas à saúde.

Ao mesmo tempo, a interface também não deve ser excessivamente técnica, já que parte das informações será apresentada a pacientes que podem não possuir conhecimento sobre conceitos cardiovasculares.

Por esse motivo, foi adotada uma interface com aparência profissional, utilizando elementos visuais simples e informações organizadas de maneira direta.

---

## 3. Escolha das cores

A interface utiliza predominantemente um fundo escuro com textos claros.

Essa decisão foi tomada principalmente devido ao contexto de utilização do aplicativo.

O CardioRisco poderá ser utilizado durante visitas domiciliares, inclusive em ambientes externos e sob forte iluminação solar. Por isso, o alto contraste entre o fundo e os elementos da interface busca facilitar a leitura das informações.

O estudo de caso também destaca a necessidade de uma interface de alto contraste para utilização em ambientes externos.

### Verde

O verde é utilizado principalmente em:

- botões de ação;
- elementos de progresso;
- opções selecionadas;
- informações associadas a risco baixo.

A cor foi escolhida por possuir associação visual com continuidade, confirmação e situações consideradas favoráveis.

### Amarelo e laranja

O amarelo e o laranja são utilizados para representar situações intermediárias e chamar a atenção do usuário sem utilizar o mesmo nível de alerta associado ao vermelho.

Na tela de resultado, essas cores auxiliam na identificação visual de uma classificação de risco intermediário.

### Vermelho

O vermelho é utilizado para representar condições de maior atenção e risco elevado.

Também está presente na identidade do CardioRisco, principalmente no símbolo relacionado ao coração.

### Uso das cores e acessibilidade

As cores não são utilizadas como único meio de transmitir informações.

Por exemplo, uma classificação de risco é apresentada por meio de:

- cor;
- percentual;
- texto com a classificação;
- representação no velocímetro.

Dessa maneira, mesmo que o usuário tenha dificuldade para distinguir determinadas cores, a informação continuará compreensível.

---

## 4. Tipografia

Foi utilizada uma tipografia sem serifa, com aparência simples e moderna.

Esse tipo de fonte favorece a leitura em telas pequenas e combina com a proposta de uma aplicação mobile voltada para utilização rápida.

Foram utilizados diferentes pesos e tamanhos de texto para estabelecer hierarquia entre as informações.

Os principais níveis utilizados são:

- título da tela;
- título das seções;
- identificação dos campos;
- valores informados;
- textos explicativos;
- botões e ações.

Informações importantes, como o percentual de risco e sua classificação, recebem maior destaque visual.

Textos secundários possuem menor destaque para evitar competição visual com as informações principais.

---

## 5. Organização das informações

A organização do CardioRisco foi planejada para reduzir a quantidade de informação apresentada simultaneamente.

O formulário foi dividido em duas etapas.

### Tela 1 — Dados demográficos e comportamentais

A primeira tela reúne informações como:

- idade;
- sexo;
- tabagismo;
- diabetes.

Essas perguntas possuem respostas rápidas e não exigem a inserção de muitos valores numéricos.

### Tela 2 — Dados clínicos medidos

A segunda tela reúne:

- pressão arterial sistólica;
- colesterol total;
- HDL.

Esses dados foram separados dos dados demográficos porque normalmente estão relacionados a medições ou exames do paciente.

Essa divisão reduz a quantidade de elementos apresentados de uma única vez e permite que o usuário compreenda melhor em qual etapa da avaliação está.

---

## 6. Indicador de progresso

Nas telas de preenchimento foi utilizado um indicador de progresso.

Exemplos:

- Etapa 1 de 2;
- Etapa 2 de 2.

Esse componente permite que o ACS saiba rapidamente:

- em qual etapa está;
- quanto falta para concluir o preenchimento;
- que o processo de avaliação é curto.

Essa escolha busca reduzir a sensação de um formulário longo ou complexo.

---

## 7. Navegação

A navegação principal foi planejada para ser linear e simples.

O fluxo principal é:

**Tela 1 → Tela 2 → Tela 3 → Tela 4**

### Tela 1

O usuário preenche os dados demográficos e comportamentais e seleciona:

**Continuar**

### Tela 2

O usuário informa os dados clínicos e seleciona:

**Avaliar Risco**

Também existe a opção:

**Voltar**

caso seja necessário corrigir alguma informação da etapa anterior.

### Tela 3

O resultado cardiovascular é apresentado.

O usuário pode selecionar:

**Ver Orientações**

para acessar informações relacionadas ao resultado.

Também é possível iniciar uma:

**Nova Avaliação**

### Tela 4

São apresentadas recomendações relacionadas ao resultado.

Ao final, o usuário poderá iniciar uma nova avaliação.

Essa estrutura busca evitar menus complexos e reduzir a quantidade de decisões necessárias durante a utilização.

---

## 8. Quantidade de telas

O fluxo principal foi organizado em quatro telas:

1. dados demográficos e comportamentais;
2. dados clínicos medidos;
3. resultado do risco cardiovascular;
4. recomendações e orientações.

Essa decisão está diretamente relacionada à restrição definida no estudo de caso, que estabelece até quatro telas principais para o protótipo.

Caso seja mantida uma tela de histórico de avaliações, ela será considerada uma funcionalidade secundária e não fará parte do fluxo principal da avaliação.

---

## 9. Componentes de entrada

Foram utilizados componentes diferentes de acordo com o tipo de informação necessária.

### Campos numéricos

São utilizados para informações como:

- idade;
- pressão arterial;
- colesterol total;
- HDL.

As unidades são apresentadas próximas ao campo quando necessário, como:

- anos;
- mmHg;
- mg/dL.

Isso ajuda o usuário a compreender qual valor deve ser informado.

### Botões de seleção

Informações com poucas possibilidades de resposta utilizam botões de seleção.

Exemplos:

**Sexo**
- Masculino
- Feminino

**Tabagismo**
- Sim
- Não

**Diabetes**
- Sim
- Não

Esse formato reduz a necessidade de digitação e permite respostas rápidas durante a visita.

---

## 10. Botões

Os principais botões possuem tamanho grande e destaque visual.

Exemplos:

- Continuar;
- Avaliar Risco;
- Ver Orientações;
- Nova Avaliação.

Essa decisão considera que o aplicativo poderá ser utilizado durante uma visita domiciliar, quando o usuário poderá estar segurando o aparelho com apenas uma das mãos ou dividindo sua atenção entre o celular e o paciente.

Botões maiores reduzem a possibilidade de toques incorretos e facilitam a utilização.

---

## 11. Validação dos campos

A interface deverá informar quando algum campo obrigatório estiver vazio ou possuir um valor inválido.

As mensagens de erro devem ser curtas e específicas.

Exemplo:

**Informe um valor válido.**

O estado de erro não deverá depender exclusivamente da cor vermelha.

Além da mudança visual no campo, deverá existir uma mensagem textual indicando o problema.

Essa decisão busca tornar o preenchimento mais tolerante a erros, característica importante durante visitas domiciliares.

---

## 12. Tela de resultado

A tela de resultado recebeu maior destaque visual porque representa o principal objetivo da aplicação.

Nessa tela são apresentados:

- título da avaliação;
- velocímetro;
- percentual;
- classificação do risco;
- pequena explicação;
- botão para acessar orientações.

O percentual recebe grande destaque porque representa o resultado da avaliação.

Entretanto, o percentual não é apresentado isoladamente.

Ele é acompanhado de uma classificação textual, permitindo que o resultado seja compreendido com maior facilidade.

---

## 13. Velocímetro

O velocímetro é o principal componente visual da tela de resultado.

Ele foi utilizado porque transforma um percentual abstrato em uma representação visual semelhante a indicadores já conhecidos pelo usuário.

O estudo de caso estabelece que o velocímetro deve estar presente na tela de resultado justamente por facilitar a comunicação do risco cardiovascular para pacientes leigos.

O velocímetro também permite que o ACS utilize a tela do smartphone como apoio durante a explicação do resultado ao paciente.

---

## 14. Classificação do risco

O resultado é apresentado por meio das classificações:

- Risco Baixo;
- Risco Intermediário;
- Risco Alto.

A classificação aparece juntamente com o percentual calculado.

Não se utiliza apenas uma cor para indicar o nível de risco.

Sempre haverá uma identificação textual correspondente.

Os limites percentuais específicos entre cada categoria somente deverão ser aplicados após definição da regra clínica que será utilizada no desenvolvimento do aplicativo.

---

## 15. Recomendações e orientações

Após visualizar o resultado, o usuário pode acessar uma tela com orientações.

As recomendações são apresentadas em pequenos blocos acompanhados por ícones.

Exemplos incluem:

- prática de atividade física;
- alimentação saudável;
- evitar tabagismo;
- acompanhamento da pressão arterial e colesterol;
- procura por uma unidade de saúde quando necessário.

O objetivo dessa tela não é substituir a orientação de um profissional.

Ela funciona como apoio para que o ACS converse com o paciente sobre prevenção e acompanhamento da saúde.

Por isso, as recomendações devem utilizar linguagem simples e objetiva.

---

## 16. Ícones

Ícones são utilizados para complementar textos e facilitar a identificação rápida de algumas informações.

Entre os elementos representados visualmente estão:

- coração;
- atividade física;
- alimentação;
- tabagismo;
- acompanhamento da saúde;
- retorno;
- sincronização;
- privacidade.

Os ícones não substituem completamente o texto.

Sempre que a função puder gerar dúvida, existe também uma descrição textual.

---

## 17. Funcionamento offline

O aplicativo foi pensado para funcionar em locais onde não exista conexão com a internet.

Essa condição possui grande importância porque o ACS poderá realizar visitas em áreas rurais ou periféricas.

O estudo de caso determina que os dados possam ser coletados sem conexão e sincronizados posteriormente quando houver acesso à internet.

Por isso, a interface apresenta informações relacionadas ao estado de conectividade.

Exemplos:

- Offline;
- Dados salvos no dispositivo;
- Aguardando sincronização;
- Sincronizado.

O objetivo é informar ao usuário que a ausência de internet não impede a realização da avaliação.

---

## 18. Privacidade

A interface procura comunicar de forma simples que os registros não devem conter informações diretamente identificáveis do paciente.

A mensagem apresentada poderá indicar:

**Registros sem nome ou CPF.**

Essa escolha está diretamente relacionada ao requisito de anonimização definido no projeto.

O estudo de caso estabelece que o histórico salvo não deve conter CPF ou nome do paciente.

Também será necessário considerar a exclusão dos registros armazenados conforme as regras de privacidade definidas para o projeto.

---

## 19. Acessibilidade

Algumas decisões foram adotadas para tornar a interface mais acessível.

### Alto contraste

O fundo escuro e os textos claros aumentam a diferença visual entre os elementos.

### Texto junto das cores

Informações importantes não dependem exclusivamente de verde, amarelo ou vermelho.

### Botões grandes

As principais áreas de interação possuem tamanho suficiente para facilitar o toque.

### Linguagem objetiva

Os textos procuram evitar termos desnecessariamente técnicos quando a informação também será apresentada ao paciente.

### Hierarquia visual

Títulos, resultados e ações principais possuem maior destaque do que informações secundárias.

### Mensagens de erro textuais

Erros de preenchimento devem possuir mensagem escrita, e não apenas alteração de cor.

---

## 20. Contexto de uso

As decisões da interface foram influenciadas principalmente pelo contexto de utilização do ACS.

Durante uma visita domiciliar, o profissional poderá:

- estar em ambiente externo;
- utilizar o celular sob forte iluminação;
- estar sem internet;
- conversar com o paciente enquanto utiliza o aplicativo;
- possuir pouco tempo para preencher as informações;
- utilizar um smartphone com hardware básico.

Por isso, a interface prioriza:

- poucas telas;
- poucos campos;
- botões grandes;
- formulários curtos;
- alto contraste;
- funcionamento offline;
- textos objetivos;
- baixo número de interações.

---

## 21. Relação com a persona prioritária

A persona prioritária definida anteriormente foi Mariana Souza, uma Agente Comunitária de Saúde.

Suas principais necessidades incluem:

- rapidez;
- simplicidade;
- funcionamento offline;
- poucos campos;
- facilidade de leitura;
- apoio para explicar o resultado ao paciente.

Essas necessidades influenciaram diretamente a organização do protótipo.

A divisão do formulário em duas etapas, o uso de botões grandes, o funcionamento offline e a apresentação visual do resultado foram decisões realizadas principalmente pensando nessa persona.

---

## 22. Relação com o paciente

A segunda persona representa o paciente que acompanha a avaliação junto ao profissional.

Como esse usuário pode não compreender conceitos técnicos ou percentuais isolados, o resultado utiliza:

- percentual;
- classificação textual;
- cores;
- velocímetro;
- explicação;
- recomendações.

Dessa maneira, o aplicativo também funciona como ferramenta de comunicação e educação em saúde.

---

## 23. Compatibilidade e desempenho

A interface foi planejada considerando smartphones básicos.

O estudo de caso determina funcionamento em dispositivos com aproximadamente 2 GB a 4 GB de RAM e resolução HD de 720p.

Por isso, o protótipo evita:

- excesso de animações;
- efeitos gráficos complexos;
- grande quantidade de elementos simultâneos;
- componentes visuais sem necessidade funcional.

O objetivo é permitir que a futura implementação mantenha boa fluidez mesmo em dispositivos com menor capacidade.

---

## 24. Evolução da baixa para a alta fidelidade

O protótipo de baixa fidelidade tem como objetivo definir principalmente:

- estrutura das telas;
- disposição das informações;
- fluxo de navegação;
- posição dos campos;
- posição das principais ações.

Na versão de alta fidelidade foram acrescentados e refinados:

- identidade visual do CardioRisco;
- cores;
- tipografia;
- ícones;
- componentes;
- classificação visual de risco;
- velocímetro;
- indicador de progresso;
- estados de conectividade;
- mensagens relacionadas à privacidade;
- recomendações;
- estados de validação;
- hierarquia visual.

A evolução procurou manter a estrutura validada inicialmente, acrescentando elementos visuais e de experiência necessários para representar como o aplicativo deverá ser desenvolvido na Unidade II.

---

## 25. Decisões de interface da Unidade II

Na Unidade II, o protótipo foi refeito em alta fidelidade (`docs/prototipoAltaFidelidadeUnidade2.pdf`) e implementado em Flutter. As decisões abaixo complementam as seções anteriores. Quando uma decisão da Unidade I mudou, isso está indicado na seção 25.8.

### 25.1. Tema escuro como padrão

- Fundo `#0F141A`, superfícies `#1A222C` e `#24303D`, texto principal `#F4F6F8` e texto secundário `#A0AEC0`.
- Verde `#2ECC71` para a ação principal e o risco baixo, amarelo `#F1C40F` para o risco intermediário e vermelho `#E74C3C` para o risco alto e a marca.
- Motivo: alto contraste para leitura sob o sol, como pede o estudo de caso, e menor consumo de bateria em telas OLED.
- As cores ficam definidas uma única vez no tema do app (`AppTheme`) e são usadas por todas as telas. Assim, as telas feitas por integrantes diferentes ficam com a mesma aparência.

### 25.2. Cabeçalho e ícone do app

- As telas da avaliação têm o mesmo cabeçalho do protótipo: um coração com a linha de pulso, "Cardio" em branco e "Risco" em vermelho, e o subtítulo "AVALIAÇÃO CARDIOVASCULAR".
- O ícone do app usa o mesmo coração com a linha de pulso sobre o fundo escuro. A versão adaptativa do Android deixa uma margem em volta do desenho, para ele não ser cortado nos formatos de ícone de cada fabricante (círculo, quadrado arredondado etc.).
- O nome abaixo do ícone passou a ser "CardioRisco".

### 25.3. Formulário em duas etapas (Telas 1 e 2)

- As 7 perguntas ficaram divididas em duas etapas: dados pessoais (idade, sexo, tabagismo e diabetes) e dados clínicos (pressão sistólica, uso de remédio para pressão, colesterol total e HDL). A pergunta do remédio fica junto da pressão porque ela muda a forma de calcular a pressão no escore.
- O indicador de etapas usa duas bolinhas numeradas ligadas por uma linha. A etapa concluída ganha um "✓".
- As respostas de duas opções (Sim/Não, Masculino/Feminino) usam dois botões grandes lado a lado, com 52 px de altura, fáceis de tocar com uma mão durante a visita.
- Os campos numéricos abrem o teclado de números, ignoram letras, vírgulas e espaços e aceitam no máximo 3 dígitos. A unidade (anos, mmHg, mg/dL) aparece dentro do campo.
- Dicas embaixo dos campos evitam erros comuns: a faixa de idade aceita (30 a 74 anos) e o lembrete de que a pressão "14 por 9" deve ser digitada como 140.
- Os erros aparecem numa caixa vermelha com texto explicando o problema ("O HDL deve ser menor que o colesterol total."), e não só pela cor.
- O código do paciente aparece com o símbolo "#" e o aviso "(sem nome ou CPF)", deixando a privacidade visível para o profissional e para o paciente.
- Um aviso discreto informa que o rascunho está salvo no aparelho. Isso dá segurança de que nada se perde se o app fechar no meio da visita.

### 25.4. Velocímetro (Tela 3)

- O velocímetro é desenhado pelo próprio app, com um arco de 3 faixas (verde, amarela e vermelha), uma para cada nível de risco.
- Cada faixa ocupa um terço do arco, e as divisões seguem os limites da SBC para o sexo do paciente: 5% e 20% para homens, 5% e 10% para mulheres. Com isso, o ponteiro sempre cai na cor do nível escrito embaixo. Numa escala de 0 a 100%, quase todos os pacientes ficariam no começo do arco e a diferença entre os níveis quase não apareceria.
- O protótipo tinha uma quarta cor (verde-claro), que não correspondia a nenhum nível. Ela foi retirada.
- O ponteiro sai do zero e vai até o valor com uma animação curta, chamando a atenção do paciente para o resultado.
- O percentual aparece grande, na cor do nível, acompanhado do selo "RISCO BAIXO", "RISCO INTERMEDIÁRIO" ou "RISCO ALTO" com um ícone. A cor nunca aparece sozinha.

### 25.5. Explicação do resultado

- Uma frase em linguagem simples explica o que o nível significa.
- A lista "O que influencia seu risco?" mostra só os fatores alterados nas respostas, cada um com um ícone. Ao tocar em um fator, aparece uma explicação curta que ajuda o profissional a conversar com o paciente.
- O painel "Saiba mais sobre o cálculo" mostra o modelo usado, as faixas da SBC para o sexo do paciente e o aviso de que o resultado não substitui a avaliação de um profissional de saúde.
- O cartão "Pela tabela de pontos da SBC" mostra o resultado do segundo modelo de cálculo, com um texto explicando por que os dois números podem ser um pouco diferentes.

### 25.6. Recomendações (Tela 4)

- O cartão do topo mostra o nível, o percentual e o encaminhamento sugerido, na cor do nível de risco.
- As recomendações aparecem em cartões com uma faixa colorida à esquerda e um ícone por assunto. Só aparecem as que fazem sentido para o paciente: "Parar de fumar" só para fumantes e "Controle do diabetes" só para quem tem diabetes.
- Ao tocar em um cartão, aparece uma explicação mais completa.
- O botão "Concluir e voltar ao início" fica no fim da tela, com o aviso de que a avaliação fica salva no aparelho e é enviada quando houver Wi-Fi.

### 25.7. Telas novas da Unidade II

As telas de login e cadastro, home, histórico, comparação, evolução, dashboard e relatórios usam o mesmo tema, os mesmos cartões escuros, os mesmos botões verdes e as mesmas cores de risco das telas da avaliação, para o app parecer um produto só.

### 25.8. Mudanças em relação à Unidade I

| Item | Unidade I | Unidade II | Motivo |
|---|---|---|---|
| Indicador de progresso | Texto "Etapa 1 de 2" (seção 6) | Bolinhas numeradas ligadas por uma linha | Igual ao protótipo de alta fidelidade e mais visual |
| Velocímetro | 4 cores no protótipo, sem relação definida com os níveis | 3 faixas, uma por nível, com divisões nos limites da SBC | O ponteiro sempre cai na cor do nível mostrado |
| Classificação do risco | Limites a definir (seção 14) | Baixo < 5%; intermediário de 5% a 20% (homens) ou de 5% a 10% (mulheres); alto acima disso | Escore de Risco Global da SBC |
| Quantidade de telas | Até quatro telas principais (seção 8) | Quatro telas no fluxo da avaliação, mais as telas de acompanhamento | Novas exigências do aditivo da Unidade II |
| Pressão arterial | Só o valor da pressão | Valor da pressão e "Usa remédio para controlar a pressão?" | O escore calcula a pressão tratada de forma diferente |
