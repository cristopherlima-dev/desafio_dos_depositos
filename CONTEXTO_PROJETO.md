# Contexto do Projeto — Desafio dos Depósitos

> Este arquivo existe para dar contexto completo a uma nova sessão de chat que vai continuar este projeto. **Leia tudo antes de sugerir qualquer código.**
>
> Última atualização: após a conclusão do Item 5 (HomeScreen 100% desenhada) e da definição das regras de negócio da tela de criação de desafio.

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
9. **Atenção:** o Project Knowledge pode estar dessincronizado do repositório. Se o código parecer defasado, perguntar ao usuário antes de concluir qualquer coisa.

---

## 3. Decisões técnicas já tomadas

- **Nome do pacote:** `desafio_dos_depositos` (snake_case, sem acento). Nome de exibição será configurado depois.
- **Tema** (`lib/main.dart`):
  - `useMaterial3: true`, `Brightness.light`
  - Fundo: `Color(0xFFF5F6FA)` (cinza bem claro, não branco puro)
  - Seed color: `Color(0xFF00C896)` (verde da marca)
  - Fonte: `Roboto`
- **Projeto é mobile-only.** As pastas `linux/`, `macos/`, `windows/` e `web/` foram **removidas**. Mantidas apenas `android/` e `ios/`.
- **Cores usadas na HomeScreen** (constantes em `_HomeScreenState`):
  - `_verde = Color(0xFF00C896)` — verde da marca
  - `_escuro = Color(0xFF1F2430)` — texto principal
  - `_borda = Color(0xFFE6E8EE)` — borda suave dos cards
  - `_trilho = Color(0xFFECEEF3)` — fundo da barra de progresso
  - Badge: `Color(0x1F00C896)` — **usar valor ARGB direto, nunca `.withOpacity()`** (deprecated e não é `const`)

### Estrutura de pastas atual

```
lib/
├── main.dart              → MaterialApp, tema
└── screens/
    └── home_screen.dart   → tela principal (StatefulWidget)
```

Ainda **não** existem `widgets/` nem `models/`. Criar só quando houver necessidade real (não over-engenheirar cedo).

---

## 4. Estado atual do código

### `lib/main.dart`

`MyApp` (StatelessWidget) → `MaterialApp` com o tema claro e `home: const HomeScreen()`.

### `lib/screens/home_screen.dart`

`HomeScreen` como `StatefulWidget`. A tela está **100% desenhada com dados mockados**, contendo:

1. **Corpo rolável:** `SafeArea > SingleChildScrollView > Column` (padding horizontal 20).
2. **Header:** `Row` com badge "💰 Desafio dos Depósitos" (`Expanded` + `Center`), botão "+" circular verde e engrenagem cinza. Ambos os ícones usam `tapTargetSize: shrinkWrap` para não empurrar o badge. Sem ação real (`debugPrint`).
3. **Título bicolor** com `Text.rich` + dois `TextSpan`: "Junte dinheiro" (escuro) / "brincando" (verde).
4. **Subtítulo:** "quadrado marcado = depósito feito".
5. **Card de destaque** com gradiente verde (`0xFF00C896` → `0xFF00A382`): rótulo "Você já juntou", valor grande, barra de progresso e rodapé "X% da sua meta de R$ Y".
6. **Lista de 4 cards de desafio** mockados, renderizados via `..._desafios.map(_buildCardDesafio)`.

**Padrões estabelecidos (reutilizar):**

- **Barra de progresso custom:** `ClipRRect > SizedBox(height: 8) > Stack` com um `Container` de trilho e um `FractionallySizedBox(alignment: centerLeft, widthFactor: progresso)` de preenchimento. Escolhida em vez de `LinearProgressIndicator` para ter controle total dos cantos arredondados.
- **Lista com `.map()`, não `ListView.builder`:** estamos dentro de um `SingleChildScrollView`; aninhar um `ListView` rolável causaria conflito de scroll. Com poucos itens, o spread `...lista.map(fn)` é o correto. Quando a lista for dinâmica e longa, migrar a tela para `CustomScrollView`.
- **Dados mockados como `List<Map<String, dynamic>>`**, propositalmente. A falta de autocomplete e de checagem em tempo de compilação é a dor que vai **justificar** a criação do model `Desafio` na fase de lógica.

### Pendência conhecida (não urgente)

`test/widget_test.dart` ainda é o teste padrão do `flutter create` (contador). `flutter test` falha. Não afeta o `flutter run`. Corrigir na fase de testes.

---

## 5. Histórico de itens concluídos

- ✅ **Setup:** `flutter doctor`, `flutter create`, Git + GitHub configurados.
- ✅ **Item 1:** Base do projeto — tema claro, `HomeScreen` placeholder.
- ✅ **Item 2:** Header — badge, engrenagem, título bicolor, subtítulo.
- ✅ **Item 3:** Card de destaque "Você já juntou" com gradiente e barra de progresso.
- ✅ **Item 4:** Botão "+" no topo (ao lado da engrenagem) + corpo tornado rolável (`SingleChildScrollView`). _O `Stack` do header virou `Row` aqui — com dois ícones, o `Stack` faria os botões se sobreporem ao texto do badge._
- ✅ **Item 5:** Lista de cards de desafio mockados (emoji em quadrado verde, nome, "X/200 quadrados marcados", ícones editar/excluir, %, valores, barra de progresso).
- ✅ **Limpeza:** removidas as pastas de plataforma desktop e web.

**A `HomeScreen` está concluída.** Próxima fase: tela de criação de desafio.

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
- O botão "Criar desafio" fica **desabilitado** enquanto houver pendência. O usuário nunca chega a apertar e tomar "não".
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

## 7. Próximos passos planejados

### Item 6 — Tela de criação de desafio (quebrada em sub-itens)

Nova tela em `lib/screens/novo_desafio_screen.dart`. Tudo com `setState`, **sem validação real ainda** (as regras da seção 6 entram na fase de lógica). Aqui só desenhamos e guardamos o que o usuário escolheu.

- **6a — Navegação + esqueleto:** o botão "+" passa a abrir a tela de verdade (`Navigator.push`), com botão de voltar. _Primeira ação real do app._
- **6b — Nome + seleção de ícone:** `TextField` e uma grade de emojis com seleção única (destaque verde).
- **6c — Campo de valor com máscara:** digita `3000` → vira `R$ 3.000` em tempo real. Como o total é sempre inteiro, a máscara só precisa de separador de milhar (sem vírgula/centavos). Feito com `TextInputFormatter` customizado.
- **6d — Quantidade (100/200) + modo de distribuição:** botões de seleção e três opções com descrição curta.
- **6e — Botão "Criar desafio":** por enquanto só `debugPrint` e volta. Sem salvar.

### Fases seguintes (a confirmar com o usuário — não assumir)

- Tela de detalhe do desafio (o "quadro" de quadrados marcáveis)
- Introdução do model `Desafio` (tipado, com `int` centavos)
- Lógica real: cálculo das distribuições, validações da seção 6
- **Testes automatizados** — o usuário quer isso na fase de cálculo. As regras da seção 6 são ideais para testar (entrada → saída, sem UI). **O teste mais importante do app: a soma dos quadrados SEMPRE bate com o total.**
- Persistência local (SharedPreferences ou banco local)
- Dark mode como toggle

---

## 8. Observação final para quem assumir o chat

Não pule etapas nem tente "adiantar" código de itens futuros. Confirme sempre o plano antes de escrever código de uma tela/item novo. Consulte os arquivos reais do repositório no Project Knowledge antes de propor alterações — e, se o que estiver lá não bater com este documento, **pergunte ao usuário** em vez de assumir.
