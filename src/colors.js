const darkColors = require("@primer/primitives/dist/json/colors/dark_colorblind.json");

const custom = {
  accentFg: "#cccccc",
};

function getColors(theme) {
  switch (theme) {
    case "dark":
      darkColors.primer.border.active = custom.accentFg;
      darkColors.canvas.inset = "#181818";
      darkColors.canvas.default = "#111111";
      darkColors.border.default = "#333333";
      return darkColors;
    default:
      throw new Error(`Colors are missing for value: ${theme}`);
  }
}

module.exports = {
  getColors,
};
