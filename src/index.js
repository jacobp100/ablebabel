const path = require('path');
const fs = require('fs');
const peg = require('pegjs');

const grammar = fs.readFileSync(path.join(__dirname, 'grammar.pegjs'), 'utf-8');
const parser = peg.generate(grammar);

module.exports.parse = code => parser.parse(code);
