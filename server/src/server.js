require('dotenv').config();
const express = require('express');
const pool = require('./config/db');

const app = express();
const port = process.env.PORT || 8080;
app.use(express.json());

const resources = ['inquiries', 'answers'];

get_resources()

// Start the server
app.get('/', (req, res) => { res.send('Backend server is running!'); });
app.listen(port, "0.0.0.0", () => { console.log(`Server is running on http://0.0.0.0:${port}`); });



// == Server Functions ==

// Database -> frontend
function get_resources() {
	resources.forEach((resource) => {
		app.get(`/${resource}`, async (req, res) => {
			try {
				const { rows } = await pool.query(`SELECT * FROM ${resource}`);
				res.json(rows);
			} catch (error) {
				console.error(`Error fetching ${resource}:`, error);
				res.status(500).json({ message: 'Database error' });
			}
		});
	});
}