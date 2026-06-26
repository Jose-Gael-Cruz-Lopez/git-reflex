// Minimal stand-in for the parts of the `framer` runtime that the
// SpiralSlider module touches at import time. Outside the Framer editor we
// only need ControlType keys to exist and addPropertyControls to be a no-op.

export const ControlType = new Proxy(
  {},
  {
    get: (_target, prop) => String(prop),
  }
);

export function addPropertyControls() {
  // no-op: property controls only matter inside the Framer canvas
}
