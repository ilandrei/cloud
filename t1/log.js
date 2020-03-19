const fs = require('fs');

const log= (request,response)=>{
    
    var d = new Date().toISOString()
    const message = `[${d}] ${request.ip} accesses:${request.url} status:${response.statusCode} \n `
    console.log(message)
    fs.appendFileSync('logs.log', message);

}


exports.log = log
