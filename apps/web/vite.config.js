import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import { fileURLToPath } from "node:url";

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      // The Framer hero module imports the bare `framer` runtime; map it to a stub.
      framer: fileURLToPath(new URL("./src/landing/framer-stub.js", import.meta.url)),
    },
  },
});
