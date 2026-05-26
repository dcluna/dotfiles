/**
 * ESLint rule: prefer-function-declaration
 *
 * Prefer function declarations over assigning arrow functions or
 * useCallback-wrapped functions to variables inside React components.
 *
 * Use `function onSave() {}` instead of `const onSave = () => {}` or
 * `const onSave = useCallback(() => {}, [])`.
 */

module.exports = {
  meta: {
    type: "suggestion",
    docs: {
      description:
        "Prefer function declarations over arrow function expressions assigned to variables in components",
    },
    messages: {
      preferDeclaration:
        "Use a function declaration instead of assigning a {{ kind }} to '{{ name }}'. " +
        "Prefer `function {{ name }}() {}` — function declarations are easier to read in components.",
    },
    schema: [],
  },

  create(context) {
    return {
      VariableDeclaration(node) {
        for (const decl of node.declarations) {
          if (!decl.init || !decl.id || decl.id.type !== "Identifier") continue;

          const init = decl.init;
          let kind = null;

          if (init.type === "ArrowFunctionExpression") {
            kind = "arrow function";
          } else if (
            init.type === "CallExpression" &&
            ((init.callee.type === "Identifier" && init.callee.name === "useCallback") ||
             (init.callee.type === "MemberExpression" &&
              init.callee.property.name === "useCallback"))
          ) {
            kind = "useCallback";
          }

          if (kind) {
            context.report({
              node: decl,
              messageId: "preferDeclaration",
              data: { kind, name: decl.id.name },
            });
          }
        }
      },
    };
  },
};
