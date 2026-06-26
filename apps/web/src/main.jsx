import React from "react";
import { createRoot } from "react-dom/client";
import { SpiralHero } from "./landing/SpiralHero.jsx";

function App() {
  return <SpiralHero />;
}

createRoot(document.getElementById("root")).render(<App />);
