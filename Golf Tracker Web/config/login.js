var LocalStrategy   = require('passport-local').Strategy;
var bCrypt = require('bcrypt-nodejs');

module.exports = function(passport){

    passport.use('login', new LocalStrategy({
            usernameField : 'Email',
            passwordField : 'Password',
            passReqToCallback : true
        },
        function(req, Email, Password, done) {
            // check in mongo if a user with username exists or not
            User.findOne({ 'Email' :  Email },
                function(err, user) {
                    // Username does not exist, log the error and redirect back
                    if (!user){
                        console.log('User Not Found with email:  ' + Email);
                        return done(null, false)
                        //return done(null, false, { message: 'Username Not Found' })
                    } else if (!isValidPassword(user, Password)){
                        // User exists but wrong password, log the error
                        console.log('Invalid Password');
                        return done(null, false)
                        //return done(null, false, { message: 'Invalid Password' })
                    } else if (err) {
                        // In case of any error, return using the done method
                        console.log('error logging in:'+err);
                        return done(err);
                    }
                    return done(null, user);
                }
            );

        })
    );

    var isValidPassword = function(user, password){
        return bCrypt.compareSync(password, user.Password);
    }

}
