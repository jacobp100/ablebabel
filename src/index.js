const path = require('path');
const fs = require('fs');
const peg = require('pegjs');

const grammar = fs.readFileSync(path.join(__dirname, 'grammar.pegjs'), 'utf-8');
const parser = peg.generate(grammar);

const demo = `
import { a } from 'test';
(w, {x:[a]}, [y], ...z) => 5;
function* gen(x) { 5; }
async function async(x) { 5; }
async function* asyncGen(x) { 5; }
`;

const ast = parser.parse(demo);

console.log(JSON.stringify(ast));
