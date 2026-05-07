// Standalone ESLint flat config for the mutation-needs-shield rule.
// Usage: npx eslint --config <path-to-this-file> <files...>
//
// Requires: project has @typescript-eslint/parser or @babel/eslint-parser.

const { createRequire } = require("module");
const mutationNeedsShield = require("./mutation-needs-shield.cjs");

// Resolve parsers from the project's node_modules (cwd), not from this file's location
const projectRequire = createRequire(require("path").join(process.cwd(), "package.json"));

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
    "local": { rules: { "mutation-needs-shield": mutationNeedsShield } },
  },
  rules: {
    "local/mutation-needs-shield": "error",
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
