var LocalStrategy   = require('passport-local').Strategy;
var bCrypt = require('bcrypt-nodejs');

module.exports = function(passport){

    passport.use('signup', new LocalStrategy({
            usernameField : 'Email',
            passwordField : 'Password',
            passReqToCallback : true // allows us to pass back the entire request to the callback
        },
        function(req, Email, Password, done) {
            findOrCreateUser = function(){
                //console.log('about to find or create the user!');
                // find a user in Mongo with provided username
                User.findOne({ 'Email' :  Email }, function(err, user) {
                    // In case of any error, return using the done method
                    if (err){
                        console.log('Error in SignUp: '+err);
                        return done(null, false);
                    }
                    // already exists

                    if (user) {
                        console.log(user)
                        console.log('User already exists with this email: '+Email);
                        return done(null, false);
                    } else {
                        // if there is no user with that email
                        // create the user
                        var newUser = new User();

                        // set the user's local credentials
                        newUser.Email       = Email;
                        newUser.Password    = createHash(Password);

                        // save the user
                        newUser.save(function(err, user) {
                            if (err){
                                console.log('Error in Saving user: '+err);
                                throw err;
                            }
                            if(user){
                                console.log('User Registration successful');
                                console.log(user);
                                return done(null, user);
                            }
                        });

                    }
                });
            };
            // Delay the execution of findOrCreateUser and execute the method
            // in the next tick of the event loop
            process.nextTick(findOrCreateUser);
        })
    );

    // Generates hash using bCrypt
    var createHash = function(password){
        return bCrypt.hashSync(password, bCrypt.genSaltSync(10), null);
    }

}
