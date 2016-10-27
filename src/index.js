const path = require('path');
const fs = require('fs');
const peg = require('pegjs');
const {
  map, first, tail, set, memoize, reduce, keyBy, union, keys, over, propertyOf, flow, compact,
  unset, concat, curry, update, get,
} = require('lodash/fp');


const reduceFirst = curry((iteratee, array) => reduce(iteratee, first(array), tail(array)));

const mergeExpression = (left, right) => update('expression', flow(
  unset('expression'),
  set('type', 'choice'),
  set('alternatives', concat(
    left.alternatives || left.expression,
    right.alternatives || right.expression
  ))
), left);

const getAst = memoize(grammar => (
  peg.parser.parse(fs.readFileSync(path.join(__dirname, `${grammar}.pegjs`), 'utf8'))
));

const getParserForPlugins = (plugins) => {
  const convertPasses = (passes) => {
    const converted = {};

    Object.keys(passes).forEach(stage => {
      converted[stage] = Object.keys(passes[stage])
        .map(name => passes[stage][name]);
    });

    return converted;
  };

  const astLocations = ['grammar'].concat(plugins || []);
  const asts = map(getAst, astLocations);

  const grammar = reduceFirst((grammar, ast) => {
    const grammarRules = keyBy('name', grammar.rules);
    const astRules = keyBy('name', ast.rules);

    const allRules = union(keys(grammarRules), keys(astRules));

    const newRules = map(flow(
      over([propertyOf(grammarRules), propertyOf(astRules)]),
      compact,
      reduceFirst(mergeExpression)
    ), allRules);

    return set('rules', newRules, grammar);
  }, asts);

  return peg.compiler.compile(grammar, convertPasses(peg.compiler.passes), {
    allowedStartRules: ['Start'],
  });
};

let parserPluginCache = {};
const parserForPlugins = (plugins) => {
  const path = concat(plugins, ['_parser']);
  const existing = get(path, parserPluginCache);
  if (existing) return existing;
  const parser = getParserForPlugins(plugins);
  parserPluginCache = set(path, parser, parserPluginCache);
  return parser;
};

const parse = (code) => {
  const options = {
    plugins: ['jsx'],
  };

  try {
    return parserForPlugins(options.plugins || []).parse(code);
  } catch (e) {
    if ('location' in e) {
      const { start } = e.location;
      const { line, column } = start;
      throw new SyntaxError(`${e.message} (At ${line}:${column})`);
    }
    throw e;
  }
};


module.exports.parse = parse;
