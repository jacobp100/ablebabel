const { parse } = require('./src');

const code = `#!/usr/bin/env babel-node

import {spawn} from 'foobar';
`;

const ast = parse(code);

console.log(JSON.stringify(ast));
