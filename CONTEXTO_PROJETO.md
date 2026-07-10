# Contexto do Projeto — Desafio dos Depósitos

> Este arquivo existe para dar contexto completo a uma nova sessão de chat que vai continuar este projeto. **Leia tudo antes de sugerir qualquer código.**
>
> Última atualização: após a conclusão do Item 6 (tela de criação de desafio 100% desenhada). Próximo: Item 7 — tela de detalhe.

---

## 1. O que é o projeto

App em Flutter chamado **"Desafio dos Depósitos"**. O usuário cria desafios de metas financeiras (ex: juntar R$ 10.000, comprar um Macbook) e acompanha o progresso marcando **quadrados** — cada quadrado marcado representa um depósito feito. A home mostra o total acumulado somando todos os desafios.

O projeto foi **inspirado** em um app de referência ("Junte Dinheiro com Propósito", tela escura), mas o usuário decidiu deliberadamente **divergir** dele para não ser uma cópia:

| Referência original                             | Nosso app                                                   |
| ----------------------------------------------- | ----------------------------------------------------------- |
| Tema escuro                                     | **Tema claro** (dark mode fica pra depois, como toggle)     |
| Badge "✨ Desafio Financeiro"                   | Badge "💰 Desafio dos Depósitos"                            |
| Título "Junte Dinheiro com Propósito"           | Título "Junte dinheiro **brincando**"                       |
| Subtítulo "Transforme suas metas em conquistas" | Subtítulo "quadrado marcado = depósito feito"               |
| Card "Total Acumulado" (verde chapado)          | Card "Você já juntou" (**gradiente** verde)                 |
| Rodapé "Meta total: R$ X"                       | Rodapé "4% da sua meta de R$ 32.000,00"                     |
| Botão tracejado "+ Criar Novo Desafio"          | Botão **"+" circular verde** no topo, ao lado da engrenagem |
| "X/200 quadradinhos"                            | "X/200 **quadrados marcados**"                              |

**Princípio de design:** manter a mesma _ideia_, mas com identidade própria. Ao adaptar qualquer coisa da referência, traduzir para o tema claro e buscar uma variação intencional.

---

## 2. Ambiente e forma de trabalho

- **Stack:** Flutter (stable), rodando em VSCode no Windows 11
- **Dispositivo de teste:** celular Android físico (Samsung SM-A536E), via USB — não usamos emulador
- **Caminho do projeto:** `D:\PESSOAL_AndroidStudio\desafio_dos_depositos`
- **Controle de versão:** Git + GitHub, configurado. O repositório é conectado ao "Project Knowledge" do Claude.

### Regras de trabalho (IMPORTANTE — seguir à risca)

1. **Passo a passo, item por item.** Nunca avançar múltiplos itens de uma vez. Cada "item" é uma unidade pequena e testável.
2. **Sempre mostrar o plano antes de codar**, quando iniciar uma tela nova ou etapa maior.
3. **Telas primeiro, com dados mockados.** Lógica de negócio (persistência, cálculos reais, CRUD) só depois que as telas estiverem desenhadas e aprovadas.
4. **Esperar confirmação explícita do usuário** ("feito", "concluído", "ok") antes de propor o próximo item.
5. **Depois de cada item aprovado, o usuário commita e faz push.** O assistente sugere a mensagem de commit; quem executa é o usuário.
6. **Gerenciamento de estado:** por enquanto **apenas `setState`**. Nada de Provider/Riverpod/Bloc ainda.
7. O usuário quer **entender cada parte do código**, não só copiar e colar. Explicar as decisões (por que `Stack` e não `Row`, por que tal cor), mas sem se alongar.
8. **Consultar o repositório real no Project Knowledge antes de propor alterações.** Nunca assumir o estado do código.
9. **Atenção:** o Project Knowledge **frequentemente fica dessincronizado** do repositório (já aconteceu duas vezes). Se o código parecer defasado, perguntar ao usuário antes de concluir qualquer coisa.
10. Quando o usuário pedir "o arquivo completo", entregar o arquivo inteiro **no chat** — é mais fácil de substituir do que caçar trechos.

---

## 3. Decisões técnicas já tomadas

- **Nome do pacote:** `desafio_dos_depositos` (snake_case, sem acento). Nome de exibição será configurado depois.
- **Tema** (`lib/main.dart`):
  - `useMaterial3: true`, `Brightness.light`
  - Fundo: `Color(0xFFF5F6FA)` (cinza bem claro, não branco puro)
  - Seed color: `Color(0xFF00C896)` (verde da marca)
  - Fonte: `Roboto`
- **Projeto é mobile-only.** As pastas `linux/`, `macos/`, `windows/` e `web/` foram **removidas**. Mantidas apenas `android/` e `ios/`.
- **Paleta de cores** (constantes duplicadas em cada tela; centralizar em `lib/theme/cores.dart` quando surgir a 3ª tela):
  - `_verde = Color(0xFF00C896)` — verde da marca
  - `_escuro = Color(0xFF1F2430)` — texto principal
  - `_borda = Color(0xFFE6E8EE)` — borda suave dos cards
  - `_trilho = Color(0xFFECEEF3)` — fundo da barra de progresso
  - Badge da Home: `Color(0x1F00C896)` · Card de modo selecionado: `Color(0x1400C896)`
  - **Usar valor ARGB direto, nunca `.withOpacity()`** (deprecated e não é `const`)

### Estrutura de pastas atual

```
lib/
├── main.dart                       → MaterialApp, tema
└── screens/
    ├── home_screen.dart            → tela principal (StatefulWidget)
    └── novo_desafio_screen.dart    → criação de desafio (StatefulWidget)
```

Ainda **não** existem `widgets/`, `models/` nem `theme/`. Criar só quando houver necessidade real (não over-engenheirar cedo).

---

## 4. Estado atual do código

### `lib/main.dart`

`MyApp` (StatelessWidget) → `MaterialApp` com o tema claro e `home: const HomeScreen()`.

### `lib/screens/home_screen.dart`

`HomeScreen` como `StatefulWidget`. Tela **100% desenhada com dados mockados**:

1. **Corpo rolável:** `SafeArea > SingleChildScrollView > Column` (padding horizontal 20).
2. **Header:** `Row` com badge "💰 Desafio dos Depósitos" (`Expanded` + `Center`), botão "+" circular verde (abre a tela de novo desafio via `Navigator.push`) e engrenagem cinza (sem ação). Ambos os ícones usam `tapTargetSize: shrinkWrap` para não empurrar o badge.
3. **Título bicolor** com `Text.rich` + dois `TextSpan`: "Junte dinheiro" (escuro) / "brincando" (verde).
4. **Subtítulo:** "quadrado marcado = depósito feito".
5. **Card de destaque** com gradiente verde (`0xFF00C896` → `0xFF00A382`): rótulo "Você já juntou", valor grande, barra de progresso e rodapé "X% da sua meta de R$ Y".
6. **Lista de 4 cards de desafio** mockados, via `..._desafios.map(_buildCardDesafio)`. Ícones editar/excluir sem ação real.

### `lib/screens/novo_desafio_screen.dart`

`NovoDesafioScreen` como `StatefulWidget`. Tela **100% desenhada, sem validação e sem persistência**:

1. `AppBar` transparente (com `surfaceTintColor: transparent`, senão o M3 tinge de verde ao rolar). Seta de voltar automática do `Navigator`.
2. **Nome:** `TextField` com `maxLength: 30`, controller próprio.
3. **Ícone:** grade de 12 emojis num `Wrap`, seleção única.
4. **Valor total:** `TextField` com `_MilharInputFormatter` (digita `3000` → vira `3.000`). O `"R$ "` é `prefixText`, não faz parte do texto editável.
5. **Quadrados:** dois botões `Expanded` (100 / 200).
6. **Modo:** três cards com bolinha de rádio desenhada à mão, gerados de `ModoDistribuicao.values`.
7. **Botão "Criar desafio":** `ElevatedButton` full-width. Só faz `debugPrint` dos 5 campos e `Navigator.pop`. O `disabledBackgroundColor` já está configurado para quando a validação chegar.

### Padrões estabelecidos (reutilizar)

- **Barra de progresso custom:** `ClipRRect > SizedBox(height: 8) > Stack` com `Container` de trilho + `FractionallySizedBox(alignment: centerLeft, widthFactor: progresso)`. Escolhida em vez de `LinearProgressIndicator` para controlar os cantos arredondados.
- **Listas curtas com `.map()` + spread, não `ListView.builder`:** dentro de um `SingleChildScrollView`, aninhar um `ListView`/`GridView` rolável causa conflito de scroll e altura infinita. Com poucos itens, `...lista.map(fn)` é o correto. **Para listas longas (ex.: 200 quadrados), a tela inteira precisa virar `CustomScrollView` — ver Item 7.**
- **`Wrap` em vez de `GridView`** para grades curtas dentro de scroll: não rola, ocupa só a altura necessária e se adapta à largura da tela.
- **Seleção única com uma variável só** (`_emojiSelecionado`, `_quadrados`, `_modo`), nunca `List<bool>`. Torna a exclusividade estrutural: é impossível dois estarem marcados ao mesmo tempo.
- **`AnimatedContainer` + `duration: 150ms`** no lugar de `Container` em elementos selecionáveis. Transição suave de graça, zero código extra.
- **`enum` com dados embutidos:** `ModoDistribuicao` carrega `titulo` e `descricao` no próprio valor. `ModoDistribuicao.values` + spread gera as opções da tela — adicionar um modo novo atualiza a UI sozinho, sem lista paralela para esquecer.
- **`_MilharInputFormatter`:** a máscara **descarta toda a formatação e reconstrói do zero** a cada tecla (`replaceAll` tira os pontos → reinsere). Não tenta inserir pontos incrementalmente. Robusto contra colar, apagar e editar no meio. O cursor é forçado pro fim com `TextSelection.collapsed`.
- **Compensação de teclado:** `SizedBox(height: 24 + MediaQuery.viewInsetsOf(context).bottom)` no fim do scroll, senão o teclado cobre o botão de ação.
- **`setState` só quando o que mudou aparece na tela.** O `_valorEmReais` é atribuído sem `setState` no `onChanged`, porque nenhum widget o lê ainda. Quando a validação em tempo real chegar, vira `setState`.
- **Todo controller criado precisa de `dispose()`.** Senão vaza memória.

**Dados mockados como `List<Map<String, dynamic>>`**, propositalmente. A falta de autocomplete e de checagem em tempo de compilação é a dor que vai **justificar** a criação do model `Desafio`. Contraste proposital com o `enum` da tela de criação, que é type-safe.

### Pendência conhecida (não urgente)

`test/widget_test.dart` ainda é o teste padrão do `flutter create` (contador). `flutter test` falha. Não afeta o `flutter run`. Corrigir na fase de testes.

---

## 5. Histórico de itens concluídos

- ✅ **Setup:** `flutter doctor`, `flutter create`, Git + GitHub configurados.
- ✅ **Item 1:** Base do projeto — tema claro, `HomeScreen` placeholder.
- ✅ **Item 2:** Header — badge, engrenagem, título bicolor, subtítulo.
- ✅ **Item 3:** Card de destaque "Você já juntou" com gradiente e barra de progresso.
- ✅ **Item 4:** Botão "+" no topo (ao lado da engrenagem) + corpo tornado rolável (`SingleChildScrollView`). _O `Stack` do header virou `Row` aqui — com dois ícones, o `Stack` faria os botões se sobreporem ao texto do badge._
- ✅ **Item 5:** Lista de cards de desafio mockados. **A `HomeScreen` está concluída.**
- ✅ **Limpeza:** removidas as pastas de plataforma desktop e web.
- ✅ **Item 6:** Tela de criação de desafio, **100% desenhada**:
  - **6a** — Navegação (`Navigator.push`) + esqueleto com `AppBar`. _Primeira ação real do app._
  - **6b** — Campo de nome + grade de ícones com seleção única.
  - **6c** — Campo de valor com máscara de milhar em tempo real.
  - **6d** — Quantidade (100/200) + os três modos de distribuição.
  - **6e** — Botão "Criar desafio" (só `debugPrint` + `pop`; nada é salvo).

---

## 6. REGRAS DE NEGÓCIO (definidas, ainda não implementadas)

> Esta seção é a mais importante do arquivo. São decisões densas, discutidas e aprovadas pelo usuário. Não reinventar.

### 6.1. Dinheiro é `int` em centavos — NUNCA `double`

**Regra crítica.** Ponto flutuante não representa dinheiro corretamente (`0.1 + 0.2 == 0.30000000000000004` em Dart). Somando 200 quadrados, o erro acumula e o total não bate.

- Armazenar sempre `valorEmCentavos` como `int`. R$ 40,01 → `4001`.
- Formatar apenas na exibição.
- Os mocks atuais usam `double` — **isso muda na fase de lógica.**

### 6.2. Campos do desafio

- **Nome** (obrigatório, aplicar `trim()`, rejeitar só-espaços, limitar caracteres)
- **Ícone/emoji** (seleção única, sempre com um default selecionado)
- **Valor total** (inteiro em reais, sem centavos — a máscara só usa separador de milhar)
- **Quantidade de quadrados:** `100` ou `200`
- **Modo de distribuição:** `iguais` | `progressivo` | `aleatorio`

### 6.3. Piso por quadrado

**Todo quadrado vale no mínimo R$ 1,00** (100 centavos). Esta é a restrição fundamental da qual todos os mínimos derivam.

### 6.4. Valor mínimo do total — é DINÂMICO

O mínimo depende de **quantidade de quadrados × modo**. Não existe um número fixo. A tela deve recalcular sempre que qualquer um dos dois mudar.

| Modo            | 100 quadrados | 200 quadrados | Origem                                                     |
| --------------- | ------------- | ------------- | ---------------------------------------------------------- |
| **Iguais**      | R$ 100,00     | R$ 200,00     | `quadrados × R$ 1,00`                                      |
| **Progressivo** | ~R$ 149,50    | ~R$ 399,00    | soma da PA com 1º termo = R$ 1,00 e passo = 1 centavo      |
| **Aleatório**   | > R$ 100,00   | > R$ 200,00   | precisa de folga acima do piso, senão não há o que sortear |

**Por que o progressivo é mais caro:** se os valores sobem e o _primeiro_ precisa ser ≥ R$ 1,00, todos os outros são maiores. A soma mínima de uma PA de 100 termos começando em 100 centavos com passo 1 é `100×100 + (99×100/2) = 14.950` centavos = R$ 149,50. Para 200 termos: `200×100 + (199×200/2) = 39.900` = R$ 399,00.

**Por que o aleatório precisa de folga:** se o total for exatamente o mínimo, todos os quadrados são forçados a R$ 1,00 e não sobra aleatoriedade nenhuma.

_(O usuário chegou a propor um mínimo fixo de R$ 1.000 e depois R$ 100. Ambos foram descartados: um número fixo colide com o piso por quadrado — R$ 100 ÷ 200 quadrados daria R$ 0,50 cada. O mínimo dinâmico faz o R$ 100 aparecer naturalmente quando se escolhe 100 quadrados.)_

### 6.5. Divisibilidade — SÓ vale no modo "iguais"

Esta é a correção mais importante. A divisibilidade existe porque `total ÷ quadrados` precisa dar um valor limpo. Nos modos progressivo e aleatório **não se divide igualmente** — só é preciso que a _soma_ bata com o total.

Raciocinando **em centavos** (`total × 100`):

| Quadrados | Regra (modo iguais)          | Exemplo                                     |
| --------- | ---------------------------- | ------------------------------------------- |
| **100**   | Qualquer total inteiro serve | R$ 4.001 → R$ 40,01 por quadrado ✅         |
| **200**   | Total precisa ser **par**    | R$ 3.000 ✅ · R$ 3.001 ❌ (daria R$ 15,005) |

**Progressivo e aleatório:** sem restrição de divisibilidade. Qualquer total ≥ mínimo do modo.

### 6.6. Sobra de arredondamento — "o centavo órfão"

Nos modos progressivo e aleatório a soma quase nunca fecha exata. Regra explícita:

> **O que sobrar (ou faltar) vai para o ÚLTIMO quadrado.**

Sem isso, o desafio termina em R$ 999,97 e o usuário nunca vê 100%.

### 6.7. Fórmula do progressivo

Progressão aritmética: `valor(i) = base + (i - 1) × passo`.

- O **passo é automático** (não perguntar ao usuário, para não sobrecarregar a tela).
- Garantir `base ≥ R$ 1,00` e que a soma feche no total (com a sobra indo pro último quadrado, ver 6.6).

### 6.8. Aleatório é sorteado UMA vez, na criação, e persistido

Se os valores forem sorteados a cada abertura da tela, o desafio muda de valor toda hora. **Sortear na criação e salvar a lista de valores.** (Alternativa: salvar a seed do gerador — mas salvar a lista é mais simples e robusto.)

### 6.9. Validação: alertar, sugerir e bloquear

- Validação **inline e em tempo real**, abaixo do campo — não popup no final.
- O botão "Criar desafio" fica **desabilitado** enquanto houver pendência (`onPressed: null`). O usuário nunca chega a apertar e tomar "não".
- Quando o erro for de divisibilidade, **sugerir os vizinhos válidos**:
  > ⚠️ Com 200 quadrados, o valor precisa ser par. Que tal **R$ 3.000** ou **R$ 3.002**?
- **Ordem importa:** o usuário costuma digitar o valor _antes_ de escolher quadrados/modo. A validação deve rodar sempre que **qualquer um dos três** mudar — não só no `onChanged` do campo de valor.

### 6.10. Edição de desafio já iniciado

| Momento                           | O que pode editar           |
| --------------------------------- | --------------------------- |
| **Antes do 1º quadrado marcado**  | Tudo (recalibrar à vontade) |
| **Depois do 1º quadrado marcado** | **Só nome e ícone**         |

Racional: o usuário pode trocar de "sonho" mantendo o valor — caso de uso legítimo. Mas mexer em total/quadrados/modo depois de marcar quebra os cálculos e torna o progresso uma ficção.

### 6.11. Válvula de escape: "Reiniciar desafio"

Ação separada, **com diálogo de confirmação** ("isso vai desmarcar seus 41 quadrados, tem certeza?"). Desmarca tudo e **destrava** os campos de valor novamente.

Sem essa saída, quem errou o total e já marcou um quadrado fica preso para sempre — a única alternativa seria excluir e recriar, perdendo o histórico. **Regra sem escape vira armadilha.**

### 6.12. Ideias registradas para o futuro (não implementar agora)

- **Concluir/arquivar** um desafio ao chegar em 100%, em vez de excluir.
- Ao marcar um quadrado, **guardar a data** — abre espaço para estatísticas ("você depositou 12 vezes em julho") sem custo nenhum agora.
- **Dark mode** como toggle via `ThemeMode`.

---

## 7. Próximo passo: Item 7 — Tela de detalhe do desafio

Nova tela em `lib/screens/detalhe_desafio_screen.dart`. Ainda com **dados mockados** e `setState`. É a **última tela da fase visual**.

### Decisão de design já tomada pelo usuário

> **O valor aparece dentro do quadrado**, não apenas o número de ordem.
>
> Consequência aceita conscientemente: a grade tem **menos colunas e rola mais**. Um quadrado precisa caber "R$ 40,01" de forma legível, então algo em torno de **4 colunas** (→ 50 linhas com 200 quadrados). A alternativa descartada era mostrar só o número (1, 2, 3...) e revelar o valor ao tocar.

### Ponto técnico importante (diverge das telas anteriores)

Aqui **não** dá pra usar o padrão `SingleChildScrollView + .map()`. Com 200 quadrados, construir todos de uma vez é desperdício. A grade precisa ser **virtualizada** — só constrói o que está visível.

Como a tela também tem um cabeçalho (emoji, nome, progresso, valores), a estrutura provável é:

```
CustomScrollView
├── SliverToBoxAdapter  → cabeçalho do desafio
└── SliverGrid          → os 100/200 quadrados (delegate com builder)
```

Isso mantém **um único scroll** para a tela toda, sem aninhar áreas roláveis. Confirmar o plano com o usuário antes de codar.

### Sub-itens sugeridos (a confirmar)

- **7a** — Navegação: tocar num card da Home abre a tela de detalhe. Esqueleto com `AppBar`.
- **7b** — Cabeçalho: emoji, nome, "X/200 quadrados marcados", % e barra de progresso.
- **7c** — A grade de quadrados (mockada, valores fixos), com estados marcado/desmarcado.
- **7d** — Marcar/desmarcar ao tocar (`setState`), atualizando o cabeçalho.

---

## 8. Fases seguintes (a confirmar com o usuário — não assumir)

Depois do Item 7, **encerra a fase visual** e começa a fase de lógica:

- Introdução do model `Desafio` (tipado, com `int` centavos) — substituindo os `Map<String, dynamic>`
- Lógica real: cálculo das três distribuições, validações da seção 6
- **Testes automatizados** — o usuário quer isso na fase de cálculo. As regras da seção 6 são ideais para testar (entrada → saída, sem UI). **O teste mais importante do app: a soma dos quadrados SEMPRE bate com o total.**
- Persistência local (SharedPreferences ou banco local)
- Ações reais de editar / excluir / reiniciar desafio
- Tela de configurações (a engrenagem ainda não faz nada)
- Dark mode como toggle

---

## 9. Observação final para quem assumir o chat

Não pule etapas nem tente "adiantar" código de itens futuros. Confirme sempre o plano antes de escrever código de uma tela/item novo. Consulte os arquivos reais do repositório no Project Knowledge antes de propor alterações — e, se o que estiver lá não bater com este documento, **pergunte ao usuário** em vez de assumir. O Project Knowledge já apareceu defasado mais de uma vez neste projeto.
