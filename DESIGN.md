# Design System

## Philosophy

CopyVault usa uma única paleta de cores fixa, escura, aplicada globalmente via `ThemeData`. Não há troca de tema pelo usuário (light/dark toggle) — isso está fora de escopo, conforme a seção "Excluded Features" do `PRD.md` ("Themes"). Esta paleta é um token de design fixo do produto, não uma feature configurável.

## Palette

Estilo slate/dark UI, com um único accent para a ação primária (copiar/salvar), refletindo o princípio do PRD de que copiar é a ação central do app.

| Token | Hex | Uso |
|---|---|---|
| `background` | `#111827` | Fundo do `Scaffold` |
| `surface` | `#1F2937` | Cards, AppBar, dialogs |
| `surfaceVariant` | `#374151` | Bordas, dividers, campos de texto |
| `textPrimary` | `#F9FAFB` | Título, conteúdo principal |
| `textSecondary` | `#9CA3AF` | Preview de conteúdo, timestamps, hints |
| `accent` | `#6366F1` | FAB, botão copiar, botão salvar, ações primárias |
| `accentPressed` | `#4F46E5` | Estado pressed/hover do accent |
| `danger` | `#EF4444` | Botão/ação de delete, texto do dialog de confirmação |

## Implementation

- `lib/theme/app_colors.dart` — classe `AppColors` com os tokens acima como `static const Color`.
- `lib/theme/app_theme.dart` — `AppTheme.dark`, um `ThemeData` que mapeia os tokens para `colorScheme`, `appBarTheme`, `cardTheme`, `dialogTheme`, `floatingActionButtonTheme`, `filledButtonTheme`, `inputDecorationTheme` e `textTheme`.
- `lib/main.dart` — `MaterialApp(theme: AppTheme.dark, ...)`.

Novas telas ou widgets devem usar `Theme.of(context)` (cores derivadas do tema) ou `AppColors` diretamente — nunca `Colors.xxx` ou `Color(0xFF...)` hardcoded fora de `app_colors.dart`.
