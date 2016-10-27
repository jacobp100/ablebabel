const { parse } = require('./src');

const code = `
  <n:a n:v />
`;

const ast = parse(code, { plugins: ['jsx'] });

console.log(JSON.stringify(ast));
