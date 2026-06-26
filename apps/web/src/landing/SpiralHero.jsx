import React from "react";
import SpiralSlider from "./SpiralSlider.js";
import { DEFAULT_IMAGES } from "./default-images.js";

// Landing-page hero (#33 landing page, #34 interactive hero).
// Reuses the spiral-slider art; each square links into the app.
const slides = DEFAULT_IMAGES.map((image) => ({
  image,
  link: "/white.html",
}));

export function SpiralHero() {
  return (
    <div style={{ width: "100vw", height: "100vh" }}>
      <SpiralSlider slides={slides} />
    </div>
  );
}

export default SpiralHero;
