import { defineConfig } from "vite";
import glsl from "vite-plugin-glsl";
export default defineConfig({
  server: {
    host: true,
    strictPort: true,
    port: 5173,
  },
  base: "/waving-pattern/",
  plugins: [glsl()],
});
