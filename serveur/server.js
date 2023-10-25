const express = require('express');
const app = express();
const PORT = 3000;
const cors = require('cors');

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
    res.send('Bonjour depuis le serveur Express!');
});

app.post('/login', (req, res) => {
    res.send('Login endpoint');
});

app.listen(PORT, () => {
    console.log(`Serveur en écoute sur http://localhost:${PORT}`);
});