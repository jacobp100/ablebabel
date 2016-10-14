module.exports = {
  parser: 'babel-eslint',
  extends: 'airbnb-base',
  rules: {
    'no-shadow': [0],
    'arrow-parens': [0],
    'class-methods-use-this': [0],
    'import/no-extraneous-dependencies': [2, { 'devDependencies': true }],
  }
};
