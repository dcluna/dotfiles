// ESLint rule: require error handler when calling generated mutations
//
// Detects two anti-patterns:
// 1. File imports a generated mutation but never imports useForm
// 2. Individual mutation call's options object lacks an `error` property
//
// Generated mutations wrap executeMutation() which accepts an optional
// `error: ErrorHandlerInfoOrHandlers` that routes errors to form fields.
// Without it, errors fall through to modalErrorHandler (a popup), and
// inline form validation is silently lost.
//
// Import pattern: components import from './gql' (barrel) which
// re-exports from './generated'. Mutations are plain functions,
// queries are useXxxQuery hooks. We track non-hook, non-type imports.

module.exports = {
  meta: {
    type: 'problem',
    docs: {
      description: 'Require error option in generated mutation calls',
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
      missingError:
        'Mutation call missing { error } option. Pass `error: form` for inline form errors, or an explicit handler.',
      missingUseForm:
        'File imports a generated mutation but does not import useForm.',
    },
  },
  create(context) {
    const options = context.options[0] || {};
    const importPatterns = (options.importPatterns || ['/generated/', '/gql$', '/gql/']).map(
      (p) => new RegExp(p)
    );

    const mutationFunctions = new Set();
    let hasUseForm = false;

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

        // Track useForm import from any source
        if (
          node.specifiers.some(
            (s) => s.imported && s.imported.name === 'useForm'
          )
        ) {
          hasUseForm = true;
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

        const hasError = optionsArg.properties.some(
          (prop) =>
            (prop.type === 'Property' &&
              prop.key.type === 'Identifier' &&
              prop.key.name === 'error') ||
            // Spread might contain error — give benefit of doubt
            prop.type === 'SpreadElement'
        );

        if (!hasError) {
          context.report({ node, messageId: 'missingError' });
        }
      },

      // File-level: warn if mutations imported but useForm never imported
      'Program:exit'() {
        if (mutationFunctions.size > 0 && !hasUseForm) {
          context.report({
            node: context.sourceCode.ast,
            messageId: 'missingUseForm',
          });
        }
      },
    };
  },
};
