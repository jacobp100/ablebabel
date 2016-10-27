PrimaryExpression
  = JSXElement

JSXElement
  = openingElement:JSXOpeningElement __ "/>" {
      return t.jSXElement(openingElement, null, [], true);
    }
  / openingElement:JSXOpeningElement __ ">" __
    children:(JSXElement / JSXText)+ __
    closingElement:JSXClosingElement {
      return t.jSXElement(openingElement, closingElement, children, false);
    }

JSXText
  = value:$([^<>]+) { return t.jSXText(value); }

JSXOpeningElement
  = "<" __
    name:JSXIdentifier __
    attributes:(JSXAttribute __)* {
      return t.jSXOpeningElement(name, attributes);
    }

JSXClosingElement
  = "</" __ name:JSXIdentifier __ ">" {
      return t.jSXClosingElement(name);
    }

JSXIdentifier
  = name:$Identifier { return t.jSXIdentifier(name); }

JSXAttribute
  = name:(JSXIdentifier) __ "=" __ value:StringLiteral {
      return t.jSXAttribute(name, value);
    }
  / name:(JSXIdentifier) __ "=" __ "{" __ value:JSXExpressionContainer __ "}" {
      return t.jSXAttribute(name, value);
    }
  / name:(JSXIdentifier) __ "=" __ "{" __ "}" {
      return t.jSXAttribute(name, t.jSXEmptyExpression());
    }
  / name:(JSXIdentifier) {
      return t.jSXAttribute(name, t.jSXExpressionContainer(t.booleanLiteral(true)));
    }
  / "{" __ "..." __ argument:Expression __ "}"  {
      return t.jSXSpreadAttribute(argument);
    }

JSXExpressionContainer
  = expression:Expression { return t.jSXExpressionContainer(expression); }
