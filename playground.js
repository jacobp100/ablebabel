const { parse } = require('./src');

const code = `
  function test() {
    const x = <JSXElement />;
  }
`;

const ast = parse(code);

console.log(JSON.stringify(ast));
