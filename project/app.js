const express = require('express');
const multer = require('multer');
const path = require('path');
const app = express();

const upload = multer({ 
  dest: 'uploads/',
  limits: { fileSize: 100 * 1024 * 1024 } // Limite de 100 Mo
});

app.use(express.static('public'));

app.post('/upload', upload.single('file'), (req, res) => {
  if (!req.file) {
    return res.status(400).send('No file uploaded.');
  }
  res.send(req.file.filename);
});

app.listen(3000, () => {
  console.log('Server is running on http://localhost:3000');
});
