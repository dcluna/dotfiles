// Standalone ESLint flat config for react/sort-comp.
// Enforces: rendering first, callbacks second.
// Usage: npx eslint --no-warn-ignored --config <path-to-this-file> <files...>

const { createRequire } = require("module");
const projectRequire = createRequire(require("path").join(process.cwd(), "package.json"));

const react = projectRequire("eslint-plugin-react");

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
