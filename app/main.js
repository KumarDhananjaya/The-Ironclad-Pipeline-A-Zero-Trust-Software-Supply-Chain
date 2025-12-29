const express = require('express');
const app = express();
const port = 3000;

// FIXED: Fetch secret from environment (injected via Vault/K8s)
const AWS_SECRET = process.env.AWS_SECRET;

app.get('/', (req, res) => {
  res.send('<h1>The Ironclad Pipeline - Secure App</h1><p>Status: Running</p>');
});

// INTENTIONAL VULNERABILITY: Potential XSS 
app.get('/hello', (req, res) => {
  const name = req.query.name || 'World';
  res.send(`Hello, ${name}!`);
});

app.listen(port, () => {
  console.log(`App listening at http://localhost:${port}`);
});
