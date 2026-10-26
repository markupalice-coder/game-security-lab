const express = require("express");

const app = express();
const port = process.env.PORT || 3000;

app.get("/health", (req, res) => {
  res.json({
    status: "ok",
    service: "game-security-api",
    lab: "lab02"
  });
});

app.listen(port, () => {
  console.log(`game-security-api listening on port ${port}`);
});
