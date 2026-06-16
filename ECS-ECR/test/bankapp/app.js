const express = require("express");

const app = express();
const port = process.env.PORT || 3000;
const environment = process.env.APP_ENV || "local";

app.get("/", (req, res) => {
  res.send(`Hello From ECS - Bank App - ${environment}`);
});

app.get("/health", (req, res) => {
  res.status(200).json({
    status: "healthy",
    service: "bankapp",
    environment
  });
});

app.listen(port, () => {
  console.log(`Bank app running on port ${port}`);
});
