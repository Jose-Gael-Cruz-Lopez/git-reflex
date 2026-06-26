// Flat ESLint config (structure-first baseline).
export default [
  {
    ignores: ["**/dist/**", "**/node_modules/**", "**/.wrangler/**"],
  },
  {
    files: ["**/*.{ts,tsx}"],
    rules: {
      // TODO(#41): tighten lint rules in the functional pass
    },
  },
];
