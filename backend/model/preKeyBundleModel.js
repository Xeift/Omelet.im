const mongoose = require('./mongoose');

const PreKeyBundleSchema = new mongoose.Schema({
    uid: { type: String, unique: true },
    ipkPub: { type: String, unique: true },
    spkPub: { type: mongoose.Schema.Types.Mixed, unique: true },
    spkSig: { type: mongoose.Schema.Types.Mixed, unique: true },
    opkPub: { type: mongoose.Schema.Types.Mixed, unique: true },
    lastBatchMaxOpkId: { type: Number },
    lastBatchSpkUpdateTime: { type: Number },
    lastBatchSpkId: { type: Number },
});
const PreKeyBundleModel = mongoose.model('PreKeyBundle', PreKeyBundleSchema, 'pre_key_bundle');

module.exports = PreKeyBundleModel;