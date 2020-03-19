const express = require('express');
const calls = require('./calls')
const log = require('./log')
const app = express();
const path = require('path');

const port = 42069

app.use(express.static('static'))

app.get('/', function(req, res) {
    res.sendFile(path.join(__dirname, 'static', 'index.html'));
    log.log(req,res)
});

app.get('/api/:ip?', async function(req,res){

    var ip = req.query.ip
    if(ip != undefined){
        var url = await calls.getImageFromIp(ip)
        res.json(url)
    }

    log.log(req,res)
    console.log(req.url)
})

app.listen(port, () => console.log(`Listening on port ${port}!`))