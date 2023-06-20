
const { MongoClient, ServerApiVersion } = require('mongodb');
require('dotenv').config(); // 讀取 .env 檔案
const uri = process.env.MONGO_URI; // 使用 .env 中的 MONGO_URI
const client = new MongoClient(uri, { // mongo client
  serverApi: {
    version: ServerApiVersion.v1,
    strict: true,
    deprecationErrors: true,
  }
});

async function run() {
    try {
        await client.connect();
        await client.db("admin").command({ ping: 1 });
        console.log("Pinged your deployment. You successfully connected to MongoDB!"); // 開發用，確認已成功連接

        const database = await client.db('sample_restaurants'); // 連接名為 sample_restaurants 的 db
        const collection = await database.collection('restaurants'); // 連接 sample_restaurants 中名為 restaurants 的 collection

        try {
            const doc = await collection.findOne({}); // 第一筆資料
            console.log('Found the following document:');
            console.log(doc);
        }
        catch (err) {
            console.error(err);
        }


    } finally {
        await client.close(); // 確保 client 中斷連接
    }
}

run().catch(console.dir);