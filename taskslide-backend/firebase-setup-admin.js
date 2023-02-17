// Firebase firestore setup
const admin = require("firebase-admin")
const serviceAccount = require("./taskslide-service-account.json")
admin.initializeApp({
  credential:admin.credential.cert(serviceAccount),
  // storageBucket:"mirrortalk-780ce.appspot.com"
})


module.exports.admin = admin