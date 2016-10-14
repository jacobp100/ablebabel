# TL;DR

Experiment with to replace the Babel parser (Babylon) with a PegJS version in the hope of making the parser extensible (i.e. add custom syntax before Babel does).

The idea is that you'll have the core syntax, and you'll be able to define syntaxes to be merged in. For example, in the core grammar, we have,

```
NumericLiteralValue
  = NumericLiteralHexValue
  / NumericLiteralDecimalValue

...
```

You would then be able to define your own syntax,

```
NumericLiteralValue
  = NumericLiteralRomanValue

NumericLiteralRomanValue
  = "0r" value:([LXIVCM]+) { return parseRoman(value); }
```

Which can then be combined to give,

```
NumericLiteralValue
  = NumericLiteralRomanValue
  / NumericLiteralHexValue
  / NumericLiteralDecimalValue

NumericLiteralRomanValue
  = "0r" value:([LXIVCM]+) { return parseRoman(value); }

...
```

Uses `babel-types`, so should be compatible with babel plugins.
