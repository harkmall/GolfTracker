userSchema = new db.Schema({
        Email: String,
        Password: String,
        Stats: [{type: db.Schema.Types.ObjectId, ref: 'Stats'}],

})
