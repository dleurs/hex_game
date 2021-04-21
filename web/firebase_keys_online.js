// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
//
// firebase functions:config:set keys.api_key="" keys.auth_domain="" keys.project_id="" keys.storage_bucket="" keys.messaging_sender_id="" keys.app_id="" keys.measurement_id=""
// firebase functions:config:get
const functions = require('firebase-functions');

var firebaseConfig = {
    apiKey: functions.config().keys.api_key,
    authDomain: functions.config().keys.auth_domain,
    projectId: functions.config().keys.project_id,
    storageBucket: functions.config().keys.storage_bucket,
    messagingSenderId: functions.config().keys.messaging_sender_id,
    appId: functions.config().keys.app_id,
    measurementId: functions.config().keys.measurement_id
};
// Initialize Firebase
firebase.initializeApp(firebaseConfig);
firebase.analytics();