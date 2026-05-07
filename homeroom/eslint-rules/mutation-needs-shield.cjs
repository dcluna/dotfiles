// ESLint rule: require useShield when calling generated mutations
//
// Detects two anti-patterns:
// 1. File imports a generated mutation but never imports useShield
// 2. Individual mutation call's options object lacks a `shield` property
//
// Generated mutations wrap executeMutation() which accepts an optional
// `shield: ShieldConsumer` that handles loader on/off automatically.
// Without it, no loading indicator is shown during the mutation.
//
// Import pattern: components import from './gql' (barrel) which
// re-exports from './generated'. Mutations are plain functions,
// queries are useXxxQuery hooks. We track non-hook, non-type imports.

module.exports = {
  meta: {
    type: 'problem',
    docs: {
      description: 'Require shield option in generated mutation calls',
    },
    schema: [{
      type: 'object',
      properties: {
        // Regex patterns for import sources that re-export generated mutations
        importPatterns: {
          type: 'array',
          items: { type: 'string' },
          default: ['/generated/', '/gql$', '/gql/'],
        },
      },
      additionalProperties: false,
    }],
    messages: {
      missingShield:
        'Mutation call missing { shield } option. Use useShield() and pass it.',
      missingUseShield:
        'File imports a generated mutation but does not import useShield.',
    },
  },
  create(context) {
    const options = context.options[0] || {};
    const importPatterns = (options.importPatterns || ['/generated/', '/gql$', '/gql/']).map(
      (p) => new RegExp(p)
    );

    const mutationFunctions = new Set();
    let hasUseShield = false;

    function isMutationImportSource(source) {
      return importPatterns.some((re) => re.test(source));
    }

    // Heuristic: mutation functions are plain lowercase-starting names
    // that don't look like hooks (useXxx) or type names (Uppercase).
    function looksLikeMutationFunction(name) {
      return /^[a-z]/.test(name) && !name.startsWith('use');
    }

    return {
      ImportDeclaration(node) {
        const source = node.source.value;

        if (isMutationImportSource(source)) {
          for (const spec of node.specifiers) {
            if (spec.imported) {
              const name = spec.local.name;
              if (looksLikeMutationFunction(name)) {
                mutationFunctions.add(name);
              }
            }
          }
        }

        // Track useShield import from any source
        if (
          node.specifiers.some(
            (s) => s.imported && s.imported.name === 'useShield'
          )
        ) {
          hasUseShield = true;
        }
      },

      // Check each call to a tracked mutation function
      CallExpression(node) {
        if (
          node.callee.type !== 'Identifier' ||
          !mutationFunctions.has(node.callee.name)
        ) {
          return;
        }

        // Generated mutation wrappers take a single options object arg
        const optionsArg = node.arguments[0];
        if (!optionsArg || optionsArg.type !== 'ObjectExpression') {
          // Options passed via variable — can't statically check, skip
          return;
        }

        const hasShield = optionsArg.properties.some(
          (prop) =>
            (prop.type === 'Property' &&
              prop.key.type === 'Identifier' &&
              prop.key.name === 'shield') ||
            // Spread might contain shield — give benefit of doubt
            prop.type === 'SpreadElement'
        );

        if (!hasShield) {
          context.report({ node, messageId: 'missingShield' });
        }
      },

      // File-level: warn if mutations imported but useShield never imported
      'Program:exit'() {
        if (mutationFunctions.size > 0 && !hasUseShield) {
          context.report({
            node: context.sourceCode.ast,
            messageId: 'missingUseShield',
          });
        }
      },
    };
  },
};
