const MongoClient = require('mongodb').MongoClient;


module.exports = {
    get_nodes: function () {
        const agg_nodes = [
            {
                '$project': {
                    '_id': 1,
                    'name': 1
                }
            }
        ];
        return get_db_data(agg_nodes);
    },

    get_links: function () {
        const agg_links = [
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
        return get_db_data(agg_links);
    }
};

async function get_db_data(agg) {

}
