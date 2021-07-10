const mongoose = require('mongoose')

const taskSchema = mongoose.Schema({
    id: String,
    creator:String,
    "project-name": String,
    "date-time": String,
    "date-start": String,
    "date-end": String,
    "people": Array,
    "project-body":Array,

})

module.exports = mongoose.model("TaskModel",taskSchema)
