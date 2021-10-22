const express = require('express');
const {MongoClient} = require("mongodb");

const uri = 'mongodb://localhost:27017/?readPreference=primary&appname=MongoDB%20Compass&directConnection=true&ssl=false';
const database = "test"
const collection = "grapfosimple";

const port = process.env.PORT || 8081;
const app = express();

app.use(express.static(__dirname));
app.use(express.static("public"));

app.get('/filter', (req, res) => {
    const agg = [
        {
            '$unwind': {
                'path': '$followed_by',
                'preserveNullAndEmptyArrays': false
            }
        }, {
            '$addFields': {
                'from': '$name',
                'to': '$followed_by'
            }
        }, {
            '$project': {
                'from': 1,
                'to': 1,
                '_id': 0
            }
        }
    ];

    MongoClient.connect(uri, (err, db) => {
        if (err) res.send({error: err.message});
        let aggCursor = db.db(database).collection(collection).aggregate(agg);
        aggCursor.toArray((err, resp) => {
            if (err) res.send({error: err.message});
            res.json(JSON.stringify(resp));
        });
    });
})

app.listen(port);