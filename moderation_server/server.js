const express = require('express');
const axios = require('axios');

const app = express();
const port = 3000;

// Middleware to parse URL-encoded bodies (as sent by HTML forms)
app.use(express.urlencoded({ extended: true }));

// Middleware to parse JSON bodies (as sent by API clients)
app.use(express.json());

// GET route for moderation prediction
app.get('/api/moderation/predict', async (req, res) => {
    const { text, language } = req.query;
    try {
        const response = await axios.get('https://moderation.logora.fr/predict', {
            params: { text, language }
        });
        res.json(response.data);
    } catch (error) {
        res.status(500).json({ error: error.toString() });
    }
});

// GET route for obtaining a quality score
app.get('/api/moderation/score', async (req, res) => {
    const { text, language } = req.query;
    try {
        const response = await axios.get('https://moderation.logora.fr/score', {
            params: { text, language }
        });
        res.json(response.data);
    } catch (error) {
        res.status(500).json({ error: error.toString() });
    }
});

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});
