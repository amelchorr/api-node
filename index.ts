// Declaración de Imports
import express from 'express';
import dotenv from 'dotenv';
import { MongoClient } from 'mongodb';

// Lectura de Variables de Entorno desde el Archivo .env
dotenv.config();

// Cadena de Conexión a MongoDB
const url = `mongodb://${process.env.MONGO_USER}:${process.env.MONGO_PASSWORD}@${process.env.MONGO_HOST}:27017/${process.env.MONGO_DATABASE}`;

// Use connect method to connect to the server
const client = new MongoClient(url);
(async () => {
    // Servidor Web
    const app = express();
    app.get('/', function (req, res) {
        res.status(200).json({ 
            "response": "Hello From DevSecOps ..." 
        });
    });
    app.get('/dc', (req, res) => {
        dc().then((dc: any) => {
            res.status(200).json({ 
                title: "Hello From DC Heroes ...",
                logo: "https://i.pinimg.com/originals/12/06/2d/12062d1e9c1fc847cf7520cc5a779c68.jpg",
                data: dc 
            });    
        })
        .catch((error: any) => {
            res.status(501).json({ 
                title: "Error From DC Heroes ...",
                data: error
            }); 
        })
        .finally(() => client.close())        
    });

    app.get('/marvel', (req, res) => {
        marvel().then((dc: any) => {
            res.status(200).json({ 
                title: "Hello From MARVEL Heroes ...",
                logo: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/Marvel_Logo.svg/1200px-Marvel_Logo.svg.png",
                data: dc 
            });    
        })
        .catch((error: any) => {
            res.status(501).json({ 
                title: "Error From MARVEL Heroes ...",
                data: error
            }); 
        })
        .finally(() => client.close())        
    });

    app.listen(process.env.API_PORT, () => {
        console.log(`Servidor Express iniciado correctamente en el puerto ${process.env.API_PORT} ...`);
    });

    const dc:any = async () => {
        await client.connect();
        const db = client.db(process.env.MONGO_DATABASE);
        return await db.collection('heroes').find({publisher: "DC Comics"}).toArray();
    }

    const marvel: any = async () => {
        await client.connect();
        const db = client.db(process.env.MONGO_DATABASE);
        return await db.collection('heroes').find({publisher: "Marvel Comics"}).toArray();
    }
})();