/**
 * ESLint rule: react-func-sort-comp
 *
 * Enforces ordering of local functions inside React function components:
 *   1. render* functions (rendering)
 *   2. on* / handle* functions (callbacks)
 *
 * "Order code from how it executes: rendering first, callbacks second."
 */

const RENDER_PATTERN = /^render/;
const CALLBACK_PATTERN = /^(on[A-Z]|handle[A-Z])/;

const CATEGORY_RENDER = "rendering";
const CATEGORY_CALLBACK = "callback";

function categorize(name) {
  if (RENDER_PATTERN.test(name)) return CATEGORY_RENDER;
  if (CALLBACK_PATTERN.test(name)) return CATEGORY_CALLBACK;
  return null;
}

// Higher number = must appear later
const ORDER = {
  [CATEGORY_RENDER]: 0,
  [CATEGORY_CALLBACK]: 1,
};

function getFunctionName(node) {
  // function declaration: function renderFoo() {}
  if (node.type === "FunctionDeclaration" && node.id) {
    return node.id.name;
  }
  // variable declarator: const renderFoo = () => {} or const renderFoo = function() {}
  if (
    node.type === "VariableDeclaration" &&
    node.declarations.length === 1 &&
    node.declarations[0].init
  ) {
    const init = node.declarations[0].init;
    if (
      init.type === "ArrowFunctionExpression" ||
      init.type === "FunctionExpression"
    ) {
      return node.declarations[0].id && node.declarations[0].id.name;
    }
    // useCallback: const onFoo = useCallback(...)
    if (
      init.type === "CallExpression" &&
      init.callee.name === "useCallback"
    ) {
      return node.declarations[0].id && node.declarations[0].id.name;
    }
  }
  return null;
}

function isReactComponent(node) {
  // Heuristic: function that contains a ReturnStatement with JSXElement/JSXFragment
  const body =
    node.type === "FunctionDeclaration" || node.type === "FunctionExpression"
      ? node.body
      : node.type === "ArrowFunctionExpression"
        ? node.body
        : null;

  if (!body) return false;
  if (body.type !== "BlockStatement") return false;

  return body.body.some(
    (stmt) =>
      stmt.type === "ReturnStatement" &&
      stmt.argument &&
      (stmt.argument.type === "JSXElement" ||
        stmt.argument.type === "JSXFragment" ||
        // return render() — calling a local render function
        (stmt.argument.type === "CallExpression" &&
          stmt.argument.callee.type === "Identifier" &&
          RENDER_PATTERN.test(stmt.argument.callee.name)))
  );
}

function getComponentFunction(node) {
  // export default function Foo() {}
  // function Foo() {}
  if (node.type === "FunctionDeclaration") return node;
  // const Foo = () => {} or const Foo = function() {}
  if (
    node.type === "VariableDeclaration" &&
    node.declarations.length === 1 &&
    node.declarations[0].init
  ) {
    const init = node.declarations[0].init;
    if (
      init.type === "ArrowFunctionExpression" ||
      init.type === "FunctionExpression"
    ) {
      return init;
    }
  }
  // export default function() {}
  if (node.type === "ExportDefaultDeclaration" && node.declaration) {
    if (
      node.declaration.type === "FunctionDeclaration" ||
      node.declaration.type === "ArrowFunctionExpression" ||
      node.declaration.type === "FunctionExpression"
    ) {
      return node.declaration;
    }
  }
  return null;
}

module.exports = {
  meta: {
    type: "suggestion",
    docs: {
      description:
        "Enforce render* functions before on*/handle* callbacks in React function components",
    },
    messages: {
      wrongOrder:
        "'{{current}}' ({{currentCategory}}) should be placed before '{{previous}}' ({{previousCategory}}). Rendering functions should come before callbacks.",
    },
    schema: [],
  },

  create(context) {
    function checkBody(body) {
      const categorized = [];

      for (const stmt of body) {
        const name = getFunctionName(stmt);
        if (!name) continue;
        const category = categorize(name);
        if (!category) continue;
        categorized.push({ name, category, order: ORDER[category], node: stmt });
      }

      // Check pairwise: each item should have order >= all previous items
      for (let i = 1; i < categorized.length; i++) {
        const current = categorized[i];
        for (let j = 0; j < i; j++) {
          const previous = categorized[j];
          if (current.order < previous.order) {
            context.report({
              node: current.node,
              messageId: "wrongOrder",
              data: {
                current: current.name,
                currentCategory: current.category,
                previous: previous.name,
                previousCategory: previous.category,
              },
            });
            break; // one report per misplaced function is enough
          }
        }
      }
    }

    return {
      "Program > FunctionDeclaration"(node) {
        if (isReactComponent(node) && node.body.type === "BlockStatement") {
          checkBody(node.body.body);
        }
      },
      "Program > VariableDeclaration"(node) {
        const fn = getComponentFunction(node);
        if (fn && isReactComponent(fn) && fn.body && fn.body.type === "BlockStatement") {
          checkBody(fn.body.body);
        }
      },
      "Program > ExportDefaultDeclaration"(node) {
        const fn = getComponentFunction(node);
        if (fn && isReactComponent(fn) && fn.body && fn.body.type === "BlockStatement") {
          checkBody(fn.body.body);
        }
      },
      "Program > ExportNamedDeclaration"(node) {
        if (node.declaration) {
          const fn = getComponentFunction(node.declaration);
          const target = fn || (node.declaration.type === "FunctionDeclaration" ? node.declaration : null);
          if (target && isReactComponent(target) && target.body && target.body.type === "BlockStatement") {
            checkBody(target.body.body);
          }
        }
      },
    };
  },
};
