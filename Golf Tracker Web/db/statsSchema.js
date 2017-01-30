statsSchema = new db.Schema({
    course: {type: db.Schema.Types.ObjectId, ref: 'Course'},
    score: Number,
    date: { type: Date, default: Date.now },
    stats: [{
        tee: String,
        hole: Number,
        score: Number,
        fwHit: String,
        GIR: Boolean,
        putts: Number
    }]
})
