PrimaryExpression
  = JSXElement

JSXElement
  = openingElement:JSXOpeningElement __ "/>" {
      openingElement.selfClosing = true;
      return t.jSXElement(openingElement, null, [], true);
    }
  / openingElement:JSXOpeningElement __ ">"
    children:(JSXChild)* __
    closingElement:JSXClosingElement {
      return t.jSXElement(openingElement, closingElement, children, false);
    }

JSXChild
  // Be careful to include leading and trailling space for JSXText
  = __ element:JSXElement { return element; }
  / __ "{" __ expression:Expression? __ "}" {
      return t.jSXExpressionContainer(expression || t.jSXEmptyExpression());
    }
  / JSXText

JSXText
  // FIXME: Handle &amp; codes
  = value:$([^<{]+) { return t.jSXText(value); }

JSXOpeningElement
  = "<" __
    name:(JSXNamespacedName / JSXIdentifier) __
    attributes:(JSXAttribute __)* {
      const element = t.jSXOpeningElement(t.jSXIdentifier('dummy'), extractList(attributes, 0));
      element.name = name;
      return element;
    }

JSXClosingElement
  = "</" __ name:(JSXNamespacedName / JSXIdentifier) __ ">" {
      const element = t.jSXClosingElement(t.jSXIdentifier('dummy'));
      element.name = name;
      return element;
    }

JSXNamespacedName
  = ns:JSXIdentifier __ ":" __ name:JSXIdentifier {
      return t.jSXNamespacedName(ns, name);
    }

JSXIdentifier
  = head:$Identifier tail:(__ "." __ $Identifier)*
    {
      return extractList(tail, 3).reduce((memberExpression, identifier) => (
        t.jSXMemberExpression(memberExpression, t.jSXIdentifier(identifier))
      ), t.jSXIdentifier(head));
    }

JSXAttribute
  = name:(JSXNamespacedName / JSXIdentifier) __ "=" __ value:(StringLiteral / JSXElement) {
      return t.jSXAttribute(name, value);
    }
  / name:(JSXNamespacedName / JSXIdentifier) __ "=" __ "{" __ value:JSXExpressionContainer? __ "}" {
      return t.jSXAttribute(name, value || t.jSXEmptyExpression());
    }
  / name:(JSXNamespacedName / JSXIdentifier) {
      return t.jSXAttribute(name);
    }
  / "{" __ "..." __ argument:Expression __ "}"  {
      return t.jSXSpreadAttribute(argument);
    }

JSXExpressionContainer
  = expression:Expression { return t.jSXExpressionContainer(expression); }
