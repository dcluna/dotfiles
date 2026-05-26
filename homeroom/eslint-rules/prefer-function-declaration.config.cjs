// Standalone ESLint flat config for preferring function declarations.
// Flags arrow functions and useCallback assigned to variables.
// Usage: npx eslint --no-warn-ignored --config <path-to-this-file> <files...>

const { createRequire } = require("module");
const projectRequire = createRequire(require("path").join(process.cwd(), "package.json"));

const preferFunctionDeclaration = require("./prefer-function-declaration.cjs");

let parser;
for (const name of ["@typescript-eslint/parser", "@babel/eslint-parser"]) {
  try {
    parser = projectRequire(name);
    break;
  } catch {
    // try next
  }
}

const config = {
  files: ["**/*.{ts,tsx,js,jsx}"],
  plugins: {
    "local": { rules: { "prefer-function-declaration": preferFunctionDeclaration } },
  },
  rules: {
    "func-style": ["error", "declaration"],
    "local/prefer-function-declaration": "error",
  },
  languageOptions: {
    ecmaVersion: "latest",
    sourceType: "module",
    parserOptions: {
      ecmaFeatures: { jsx: true },
    },
  },
};

if (parser) {
  config.languageOptions.parser = parser;
}

module.exports = [config];
