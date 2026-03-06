require('dotenv').config();
const express = require('express');
const pool = require('./config/db');

const app = express();
const port = process.env.PORT || 8080;

app.use(express.json());

// Checking if the server runs
app.get('/', (req, res) => {
	res.send('Backend server is running!');
});

// Retreive inquiries upon call from frontend
app.get('/inquiries', async (req, res) => {
	try {
		const { rows } = await pool.query('SELECT * FROM Inquiries');
		res.json(rows);
	} catch (error) {
		console.error(error);
		res.status(500).json({ message: 'Database error' });
	}
});

// Start the server
app.listen(port, "0.0.0.0", () => {
	console.log(`Server is running on http://0.0.0.0:${port}`);
});