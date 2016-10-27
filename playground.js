const { parse } = require('./src');

const code = `
/* Are top-level comments allowed? */
function test() {
  return null;
}
`;

const ast = parse(code);

console.log(JSON.stringify(ast));
