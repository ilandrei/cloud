const http = require('http')
const url = require('url');
const mongoose = require("mongoose");


mongoose.connect('mongodb://localhost:27017/cars');
const connection = mongoose.connection

mongoose.connection.on("connected", (err, res) => {
    console.log("Connected to db");
});

const Schema = mongoose.Schema;

const carSchema = new Schema({
    brand: String,
    model: String,
    mpg: Number
});

const Car = mongoose.connection.model('cars', carSchema)


const server = http.createServer((req, res) => {
    try {
        var pathname = url.parse(req.url, true).pathname;
        var urlComponents = pathname.split("/");

        res.setHeader("Content-Type", "application/json");

        if (urlComponents[1] != 'cars') {
            res.statusCode = 400
            res.end('Bad request')
        }
        else {
            switch (req.method) {
                case 'GET':
                    if (urlComponents.length == 2) {
                        Car.find({}, '', (err, cars) => {
                            if (err) {
                                res.statusCode = 500
                                res.end(err)
                            }
                            else {
                                res.statusCode = 200
                                res.end(JSON.stringify(cars))
                            }
                        });
                    }
                    else if (urlComponents.length == 3) {
                        Car.findById(urlComponents[2], (err, car) => {
                            if (err) {
                                res.statusCode = 404
                                res.end(err)
                            }
                            else {
                                res.statusCode = 200
                                res.end(JSON.stringify(car))
                            }
                        })
                    }
                    break;
                case 'POST':
                    if (urlComponents.length == 2) {
                        let data = ''
                        req.on('data', chunk => {
                            data += chunk.toString();
                        })
                        req.on('end', () => {
                            try {
                                var body = JSON.parse(data);
                                const newCar = Car(body);
                                newCar.save((err, car) => {
                                    if (err) {
                                        res.statusCode = 400;
                                        res.end(err)
                                    }
                                    else {
                                        res.statusCode = 201
                                        res.end(car.id)
                                    }
                                });
                            }
                            catch (error) {
                                res.statusCode = 400
                                res.end(error)
                            }

                        })
                    }
                    else if (urlComponents.length == 3) {
                        if (!mongoose.Types.ObjectId.isValid(urlComponents[2])) {
                            res.statusCode = 400
                            res.end('Bad id')
                        } else {
                            Car.findById(urlComponents[2], (err, car) => {
                                if (err) {
                                    res.statusCode = 404;
                                    res.end(err)
                                }
                                else {
                                    res.statusCode = 409;
                                    res.end(JSON.stringify(car))
                                }
                            });
                        }
                    }
                    break;
                case 'PUT':
                    if (urlComponents.length == 2) {
                        let data = ''
                        req.on('data', chunk => {
                            data += chunk.toString();
                        })
                        req.on('end', () => {
                            try {
                                var body = JSON.parse(data);
                                const newCar = Car(body);
                                Car.find({}, (err, cars) => {
                                    if (err) {
                                        res.statusCode = 404;
                                        res.end(err)
                                    }
                                    else {
                                        cars.forEach((car) => {
                                            car.brand = newCar.brand
                                            car.model = newCar.model
                                            car.mpg = newCar.mpg
                                            car.save((err, car) => {
                                                if (err) {
                                                    res.statusCode = 500
                                                    res.end(err)
                                                }
                                            })
                                        })
                                    }
                                })
                                res.statusCode = 200
                                res.end("Updated")
                            }
                            catch (error) {
                                res.statusCode = 400
                                res.end(error)
                            }

                        })
                    }
                    else if (urlComponents.length == 3) {
                        if (!mongoose.Types.ObjectId.isValid(urlComponents[2])) {
                            res.statusCode = 400
                            res.end('Bad id')
                        } else {
                            let data = ''
                            req.on('data', chunk => {
                                data += chunk.toString();
                            })
                            req.on('end', () => {
                                try {
                                    var body = JSON.parse(data);
                                    const newCar = Car(body);
                                    Car.findById(urlComponents[2], (err, car) => {
                                        if (err) {
                                            res.statusCode = 404;
                                            res.end(err)
                                        }
                                        else {
                                            car.brand = newCar.brand
                                            car.model = newCar.model
                                            car.mpg = newCar.mpg
                                            car.save((err, car) => {
                                                if (err) {
                                                    res.statusCode = 500
                                                    res.end(err)
                                                }
                                            })
                                        }
                                    });
                                    res.statusCode = 200
                                    res.end("Updated")
                                } catch (error) {
                                    res.statusCode = 400
                                    console.log(error.message);
                                    res.end(error.message)

                                }

                            });

                        }
                    }
                    break;
                case 'PATCH':
                    if (urlComponents.length == 2) {
                        let data = ''
                        req.on('data', chunk => {
                            data += chunk.toString();
                        })
                        req.on('end', () => {
                            try {
                                var body = JSON.parse(data);
                                Car.find({}, (err, cars) => {
                                    if (err) {
                                        res.statusCode = 404;
                                        res.end(err)
                                    }
                                    else {
                                        cars.forEach((car) => {
                                            if (body.hasOwnProperty('brand')) {
                                                car.brand = body.brand
                                            }
                                            if (body.hasOwnProperty('model')) {
                                                car.model = body.model
                                            }
                                            if (body.hasOwnProperty('mpg')) {
                                                car.mpg = body.mpg
                                            }
                                            car.save((err, car) => {
                                                if (err) {
                                                    res.statusCode = 500
                                                    res.end(err)
                                                }
                                            })
                                        })
                                    }
                                })
                                res.statusCode = 200
                                res.end("Updated")
                            }
                            catch (error) {
                                res.statusCode = 400
                                res.end(error)
                            }

                        })
                    }
                    else if (urlComponents.length == 3) {
                        if (!mongoose.Types.ObjectId.isValid(urlComponents[2])) {
                            res.statusCode = 400
                            res.end('Bad id')
                        } else {
                            let data = ''
                            req.on('data', chunk => {
                                data += chunk.toString();
                            })
                            req.on('end', () => {
                                try {
                                    var body = JSON.parse(data);
                                    const newCar = Car(body);
                                    Car.findById(urlComponents[2], (err, car) => {
                                        if (err) {
                                            res.statusCode = 404;
                                            res.end(err)
                                        }
                                        else {
                                            if (body.hasOwnProperty('brand')) {
                                                car.brand = body.brand
                                            }
                                            if (body.hasOwnProperty('model')) {
                                                car.model = body.model
                                            }
                                            if (body.hasOwnProperty('mpg')) {
                                                car.mpg = body.mpg
                                            }
                                            car.save((err, car) => {
                                                if (err) {
                                                    res.statusCode = 500
                                                    res.end(err)
                                                }
                                            })
                                        }
                                    });
                                    res.statusCode = 200
                                    res.end("Updated")
                                } catch (error) {
                                    res.statusCode = 400
                                    res.end(error.message)
                                }

                            });

                        }
                    }
                    break;
                case 'DELETE':
                    if (urlComponents.length == 2) {
                        Car.remove({}, (err) => {
                            if (err) {
                                res.statusCode = 500
                                res.end(err)
                            } else {
                                res.statusCode = 204
                                res.end("Success")
                            }
                        })
                    }
                    else if (urlComponents.length == 3) {
                        if (!mongoose.Types.ObjectId.isValid(urlComponents[2])) {
                            res.statusCode = 400
                            res.end('Bad id')
                        }
                        else {
                            Car.findByIdAndDelete(urlComponents[2], (err, succ) => {
                                if (err) {
                                    res.statusCode = 404;
                                    res.end(err);
                                } else {
                                    res.statusCode = 204;
                                    res.end(JSON.stringify(succ));
                                }
                            })
                        }

                    }
                    break;
                default:
                    res.statusCode = 405
                    res.end('Not supported')
            }
        }
    }
    catch (error) {
        res.statusCode = 500
        res.end(error.message)
    }
})

server.listen(9091)