// Standalone ESLint flat config for component method/function ordering.
// Enforces: rendering first, callbacks second.
// Covers both class components (react/sort-comp) and function components (custom rule).
// Usage: npx eslint --no-warn-ignored --config <path-to-this-file> <files...>

const { createRequire } = require("module");
const projectRequire = createRequire(require("path").join(process.cwd(), "package.json"));

const react = projectRequire("eslint-plugin-react");
const reactFuncSortComp = require("./react-func-sort-comp.cjs");

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
    react,
    "local": { rules: { "react-func-sort-comp": reactFuncSortComp } },
  },
  settings: {
    react: { version: "detect" },
  },
  rules: {
    "react/sort-comp": ["error", {
      order: [
        "static-methods",
        "static-variables",
        "instance-variables",
        "type-annotations",
        "rendering",
        "lifecycle",
        "/^on.+$/",
        "/^handle.+$/",
        "everything-else",
      ],
      groups: {
        rendering: [
          "/^render.+$/",
          "render",
        ],
      },
    }],
    "local/react-func-sort-comp": "error",
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
