courseSchema = new db.Schema({
    name: String,
    tees: [{
        name: String,
        slope: Number,
        rating: Number
    }],
    holes: [{
        hole: Number,
        yardages: [{
            name: String,
            distance: Number
        }],
        par: Number
    }],
    location: {
        latitude: Number,
        longitude: Number
    },
})
