// app.js
const express = require('express');
const bodyParser = require('body-parser');
const db = require('./bd');

const app = express();
app.use(bodyParser.json());

// rutas para obtener los valores 

app.get('/entrada', (req, res) => {
  // obtener todos los registros de entrada
  db.query('SELECT * FROM entrada', (err, results) => {
    if (err) {
      console.error('Error al obtener las entradas:', err);
      res.status(500).json({ error: 'Error al obtener las entradas' });
    } else {
      res.status(200).json(results);
    }
  });
});

app.post('/entrada', (req, res) => {
  // crear un registro de entrada
  const { producto_id, cantidad, proveedor } = req.body;
  const query = 'INSERT INTO entrada (producto_id, cantidad, proveedor) VALUES (?, ?, ?)';
  const values = [producto_id, cantidad, proveedor];

  db.query(query, values, (err, result) => {
    if (err) {
      console.error('Error al crear una entrada:', err);
      res.status(500).json({ error: 'Error al crear una entrada' });
    } else {
      res.status(201).json({ message: 'Entrada creada con éxito', id: result.insertId });
    }
  });
});

app.put('/entrada/:id', (req, res) => {
  // actualizar un registro de entrada
  const entradaId = req.params.id;
  const { producto_id, cantidad, proveedor } = req.body;

  const query = 'UPDATE entrada SET producto_id = ?, cantidad = ?, proveedor = ? WHERE id = ?';
  const values = [producto_id, cantidad, proveedor, entradaId];

  db.query(query, values, (err) => {
    if (err) {
      console.error('Error al actualizar la entrada:', err);
      res.status(500).json({ error: 'Error al actualizar la entrada' });
    } else {
      res.status(200).json({ message: 'Entrada actualizada con éxito' });
    }
  });
});

app.delete('/entrada/:id', (req, res) => {
  // eliminar un registro de entrada
  const entradaId = req.params.id;

  db.query('DELETE FROM entrada WHERE id = ?', [entradaId], (err) => {
    if (err) {
      console.error('Error al eliminar la entrada:', err);
      res.status(500).json({ error: 'Error al eliminar la entrada' });
    } else {
      res.status(200).json({ message: 'Entrada eliminada con éxito' });
    }
  });
});

// "salida"
app.get('/salida', (req, res) => {
  // obtener todos los registros de salida
  db.query('SELECT * FROM salida', (err, results) => {
    if (err) {
      console.error('Error al obtener las salidas:', err);
      res.status(500).json({ error: 'Error al obtener las salidas' });
    } else {
      res.status(200).json(results);
    }
  });
});

app.post('/salida', (req, res) => {
  // crear un registro de salida
  const { producto_id, cantidad } = req.body;
  const query = 'INSERT INTO salida (producto_id, cantidad) VALUES (?, ?)';
  const values = [producto_id, cantidad];

  db.query(query, values, (err, result) => {
    if (err) {
      console.error('Error al crear una salida:', err);
      res.status(500).json({ error: 'Error al crear una salida' });
    } else {
      res.status(201).json({ message: 'Salida creada con éxito', id: result.insertId });
    }
  });
});

app.put('/salida/:id', (req, res) => {
  //  actualizar un registro de salida
  const salidaId = req.params.id;
  const { producto_id, cantidad } = req.body;

  const query = 'UPDATE salida SET producto_id = ?, cantidad = ? WHERE id = ?';
  const values = [producto_id, cantidad, salidaId];

  db.query(query, values, (err) => {
    if (err) {
      console.error('Error al actualizar la salida:', err);
      res.status(500).json({ error: 'Error al actualizar la salida' });
    } else {
      res.status(200).json({ message: 'Salida actualizada con éxito' });
    }
  });
});

app.delete('/salida/:id', (req, res) => {
  //  eliminar un registro de salida
  const salidaId = req.params.id;

  db.query('DELETE FROM salida WHERE id = ?', [salidaId], (err) => {
    if (err) {
      console.error('Error al eliminar la salida:', err);
      res.status(500).json({ error: 'Error al eliminar la salida' });
    } else {
      res.status(200).json({ message: 'Salida eliminada con éxito' });
    }
  });
});

// Iniciar el servidor Express
const port = 3000;
app.listen(port, () => {
  console.log(`Servidor API CRUD escuchando en el puerto ${port}`);
});
