const express = require('express');
const path = require('path');
const app = express();
app.use(express.json());

const PORT = process.env.PORT || 3000;
const testFolder = './tests/';
const fs = require('fs');

const crypto = require('crypto');
const multer = require('multer') // v1.0.5 
// const storage = multer.diskStorage({
//   destination: function (req, file, cb) {
//     cb(null, "./");
//   },
//   filename: function (req, file, cb) {
//     // const uniqueSuffix = Date.now() + "-" + Math.round(Math.random() * 1e9);
//     let originalName = file.originalname;
//     // let extension = originalName.split(".")[1];
//     cb(null, 'telo.db' );
//   },
// });

const upload = multer({ storage: multer.memoryStorage() });

let jsondbfileread = fs.readFileSync('./db.json', { encoding: 'utf-8' });

function jsondbfilewrite(map) {
  const stringdata = JSON.stringify(map);
  return fs.writeFileSync('./db.json', stringdata);
}

const getHash = path => new Promise((resolve, reject) => {
  const hash = crypto.createHash('sha256');
  const rs = fs.createReadStream(path);
  rs.on('error', reject);
  rs.on('data', chunk => hash.update(chunk));
  rs.on('end', () => resolve(hash.digest('hex')));
})

app.listen(PORT, () => {
  console.log("Server Listening on PORT:", PORT);

});
app.get("/checkfile", (request, response) => {
  const status = {
    'Status': ' Running'
  };
  console.log(status);
  console.log(fs.existsSync('db.json'));
  response.send(status);
});

app.post("/checkfile", upload.single(), (request, response, next) => {
  console.log(fs.existsSync('db.json'));
  let dbdata = JSON.parse(jsondbfileread);
  let uploadedfiledate = new Date(request.body.last_modified)
  let storagefiledate = new Date(dbdata.last_modified)
  if (request.body.hash == dbdata.hash) {
    if (uploadedfiledate > storagefiledate) {
      response.send('same data,old data');
      return;
    }
    response.send('same data');
    return;
  } else {
    response.send('diff data');
    return;
  }
});

app.post("/backupapi", upload.single('file'), async (request, response, next) => {
  let dbdata = JSON.parse(jsondbfileread);
  dbdata.last_modified = request.body.last_modified;
  dbdata.hash = request.body.hash;
  jsondbfilewrite(dbdata);
  fs.writeFileSync('/telo.db', request.file.buffer);
  console.log(jsondbfileread);
  response.send('data updated')
});

app.get("/restoreapi", upload.single('file'), async (request, response, next) => {
  let dbdata = JSON.parse(jsondbfileread);
  console.log((dbdata.filename));
  response.sendFile(dbdata.filename, { root: __dirname })
}); 