const resetDatabase = require('../utils/reset-database')
const databaseSeed = require('./seed.json')

resetDatabase(databaseSeed)
