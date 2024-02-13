const mongoose = require('./mongoose');

const PreKeyBundleSchema = new mongoose.Schema({
    uid: { type: String },
    deviceId: { type: Number },
    ipkPub: { type: String },
    spkPub: { type: mongoose.Schema.Types.Mixed },
    spkSig: { type: mongoose.Schema.Types.Mixed },
    opkPub: { type: mongoose.Schema.Types.Mixed },
    lastBatchMaxOpkId: { type: Number },
    lastBatchSpkUpdateTime: { type: Number },
    lastBatchSpkId: { type: Number },
});
const PreKeyBundleModel = mongoose.model('PreKeyBundle', PreKeyBundleSchema, 'pre_key_bundle');

module.exports = PreKeyBundleModel;