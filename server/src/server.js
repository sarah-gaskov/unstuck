const express = require('express');
const pool = require('./config/db');
require('dotenv').config();

const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

// Checking if the server runs
app.get('/', (req, res) => {
	res.send('Backend server is running!');
});

// Retreive users upon call from frontend (will not work until db is set up)
app.get('/users', async (req, res) => {
	try {
		const [rows, fields] = await pool.query('SELECT * FROM users');
    
		res.json(rows);
	} catch (error) {
		console.error(error);
		res.status(500).json({ message: 'Database error' });
	}
});

// Start the server
app.listen(port, () => {
	console.log(`Server is running on http://localhost:${port}`);
});