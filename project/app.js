const express = require('express');
const multer = require('multer');
const path = require('path');

const app = express();
const port = 3000;

// Configurer le dossier de téléchargement
const uploadDir = path.join(__dirname, 'uploads');
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, uploadDir);
    },
    filename: (req, file, cb) => {
        cb(null, file.originalname);
    }
});
const upload = multer({ storage: storage });

app.use(express.static(path.join(__dirname, 'public')));

// Route pour télécharger les fichiers
app.post('/upload', upload.single('file'), (req, res) => {
    if (!req.file) {
        return res.status(400).json({ success: false, message: 'No file uploaded.' });
    }

    // Retourner l'URL du fichier téléchargé
    res.json({ success: true, fileUrl: `/uploads/${req.file.filename}` });
});

// Démarrer le serveur
app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
