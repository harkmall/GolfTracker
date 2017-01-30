var express = require('express');
var session = require('express-session')
var app = express();
var bodyParser = require('body-parser');
var port = process.env.PORT || 3000
var _ = require('underscore')
var passport = require('passport')
db = require('mongoose');
var ObjectID = require('mongodb').ObjectID
app.use(bodyParser.json())

const expressJwt = require('express-jwt');
const serverSecret = 'server secret';
const authenticate = expressJwt({
    secret: serverSecret
});

const jwt = require('jsonwebtoken');
const SECRET = 'server secret';
const TOKENTIME = 1200000000000; // in seconds


db.connect('mongodb://harkmall:titleist1@ds145158.mlab.com:45158/golftracker', function(err, db) {
    if (err) throw err;
    console.log("Connected to Database");
    _db = db
})
require('./db/courseSchema.js')
require('./db/userSchema.js')
require('./db/statsSchema.js')
Course = db.model('Course', courseSchema)
User = db.model('User', userSchema)
Stats = db.model('Stats', statsSchema)

var initPassport = require('./config/init');
initPassport(passport);
app.use(session({
    secret: 'anything',
    saveUninitialized: true,
    resave: true
}));
app.use(passport.initialize());
app.use(passport.session());

function validateYards(yards, tees) {
    var teesNames = []
    for (var i = 0; i < tees.length; i++) {
        teesNames.push(tees[i].name)
    }

    for (var i = 0; i < yards.length; i++) {
        if (teesNames.indexOf(yards[i].name) <= -1) {
            return false
        }
    }
    var yardsNames = []
    for (var i = 0; i < yards.length; i++) {
        yardsNames.push(yards[i].name)
    }

    return _.isEqual(yardsNames, teesNames)
}

app.post('/saveCourse', function(req, res) {
    var tees = req.body.tees
    var holesArray = req.body.holes

    for (var i = 0; i < holesArray.length; i++) {
        var yards = holesArray[i].yards
        if (!validateYards(yards, tees)) {
            res.status(400).json({
                error: "invalid course object"
            })
            return
        }
    }

    var courseObject = new Course({
        name: req.body.name,
        tees: tees,
        holes: holesArray,
        slope: req.body.slope,
        rating: req.body.rating,
        location: req.body.location
    })

    courseObject.save(function(err, course) {
        if (err)
            res.send(err)
        else {
            res.send(course)
        }
    })
})

app.post('/queryCourseWithName', function(req, res) {
    var nameQuery = req.body.name
    var regex = '^' + nameQuery + '(\\w|\\s)*'
    Course.find({
        name: {
            $regex: regex,
            $options: 'i'
        }
    }, function(err, items) {
        res.send(items)
        if (err) {
            console.log(err);
        }
    })
})

var isAuthenticated = function(req, res, next) {
    if (req.isAuthenticated()) {
        console.log('User is authenticated')
        return next();
    }
    console.log('Sorry a user is not logged in')
    res.status(400).json({
        error: "User not authenticated"
    })
}

//CREATE USER ROUTES==============

app.post('/createuser', passport.authenticate('signup', {
    successRedirect: '/createuser', // redirect to the secure profile section
    failureRedirect: '/createuser/fail', // redirect back to the signup page if there is an error
}));

app.get('/createuser', isAuthenticated, function(req, res, next) {
    req.token = jwt.sign({
        id: req.user._id,
    }, SECRET, {
        expiresIn: TOKENTIME
    });
    console.log('user: ' + req.user + ', token: ' + req.token);
    res.status(200).json({
        user: req.user,
        token: req.token
    });
})

app.get('/createuser/fail', function(req, res, next) {
    var fail = 'Sign-up failed'
    console.log(fail)
    res.status(400).json({
        error: fail
    })
})


// LOGIN ROUTES==========================

app.post('/login', passport.authenticate('login', {
    successRedirect: '/home', // redirect to the secure profile section
    failureRedirect: '/login/fail', // redirect back to the signup page if there is an error
    failureFlash: true // allow flash messages
}));

app.get('/login/fail', function(req, res) {
    var fail = 'Incorrect Email/Password'
    console.log(fail)
    res.status(400).send({
        error: fail
    })
})

app.get('/home', isAuthenticated, function(req, res) {
    console.log("here");
    req.token = jwt.sign({
        id: req.user._id,
    }, SECRET, {
        expiresIn: TOKENTIME
    });
    console.log('user: ' + req.user + ', token: ' + req.token);

    res.status(200).json({
        user: req.user,
        token: req.token
    });
})

app.get('/logout', function(req, res) {
    console.log('user is about to be logged out');
    req.logout();
    console.log('user is logged out');
    res.status(200).send({
        error: 'user successfully logged out'
    });
});


app.post('/saveStats', authenticate, function(req, res) {
    User.findOne({
        'Email': req.query.Email
    }, function(err, user) {
        if (err) {
            console.log(err);
            res.send(err);
        } else if (user) {
            console.log('found user');
            Course.findOne({
                _id: new ObjectID(req.body.courseID)
            }, function(err, course) {
                if (err) {
                    res.status(404).send({
                        error: err
                    })
                } else if (course) {
                    var statsArray = req.body.stats
                    var statsObjects = []
                    for (var i = 0; i < statsArray.length; i++) {
                        statsObjects.push(statsArray[i])
                    }
                    var stats = new Stats({
                        course: course,
                        stats: statsObjects,
                        score: req.body.score
                    })
                    stats.save(function(err, stats) {
                        if (err) {
                            res.status(400).json({
                                error: "Couldn't save stats"
                            })
                        } else {
                            user.Stats.push(stats)
                            user.save(function(err, stats) {
                                if (err) {
                                    res.status(400).json({
                                        error: "Error on saving user with stats"
                                    })
                                } else {
                                    res.send(user)
                                }
                            })
                        }
                    })
                } else {
                    res.status(404).json({
                        error: "Couldn't find course"
                    })
                }
            })
        } else {
            res.sendStatus(404)
        }
    })
})

app.post('/overallStats', authenticate, function(req, res) {
    var drivingObject = {
        "left": 0,
        "right": 0,
        "hit": 0
    }
    var girObject = {
        "hit": 0,
        "miss": 0
    }
    var averageScore = 0
    var totalPutts = 0
    var totalHoles = 0
    console.log("+++++++++++"+req.body.Email);
    User.findOne({
        'Email': req.body.Email
    }, function(err, user) {
        if (err) {
            console.log(err);
            res.send(err);
        } else if (user) {
            console.log('found user');
            Stats.find({
                _id: {
                    $in: user.Stats
                }
            }, function(err, stats) {
                if (err) {
                    res.status(400).json({
                        error: err
                    })
                } else if (stats) {
                    for (var m = 0; m < stats.length; m++) {
                        var statsArray = stats[m].stats
                        totalHoles += stats[m].stats.length
                        for (var y = 0; y < statsArray.length; y++) {
                            var statsObj = statsArray[y]

                            //Fairway hit
                            if (statsObj.fwHit == "Y") {
                                var amount = drivingObject.hit
                                amount += 1
                                drivingObject.hit = amount
                            } else if (statsObj.fwHit == "L") {
                                var amount = drivingObject.left
                                amount += 1
                                drivingObject.left = amount
                            } else if (statsObj.fwHit == "R") {
                                var amount = drivingObject.right
                                amount += 1
                                drivingObject.right = amount
                            }

                            //GIR
                            if (statsObj.GIR) {
                                var amount = girObject.hit
                                amount += 1
                                girObject.hit = amount
                            } else {
                                var amount = girObject.miss
                                amount += 1
                                girObject.miss = amount
                            }

                            //putts
                            totalPutts += statsObj.putts
                        }
                        averageScore += stats[m].score
                    }
                    res.send({
                        "driving": drivingObject,
                        "GIR": girObject,
                        "score": averageScore / stats.length,
                        "puttsPerRound": totalPutts / stats.length,
                        "puttsPerHole": totalPutts / totalHoles
                    })
                } else {
                    res.status(400).json({
                        error: "Couldn't find stats"
                    })
                }
            })
        } else {
            res.sendStatus(404)
        }
    })
})



app.listen(port)

console.log('Magic happens on port ' + port);

exports = module.exports = app;
