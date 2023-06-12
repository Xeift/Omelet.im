
const { MongoClient, ServerApiVersion } = require('mongodb');
const uri = "mongodb+srv://xeift:M9Tuj4iOYjzM09Ns@omelet-cluster-1.svzxu5e.mongodb.net/?retryWrites=true&w=majority";

// Create a MongoClient with a MongoClientOptions object to set the Stable API version
const client = new MongoClient(uri, {
  serverApi: {
    version: ServerApiVersion.v1,
    strict: true,
    deprecationErrors: true,
  }
});

async function run() {
  try {
    // Connect the client to the server	(optional starting in v4.7)
    await client.connect();
    // Send a ping to confirm a successful connection
    await client.db("admin").command({ ping: 1 });
    console.log("Pinged your deployment. You successfully connected to MongoDB!");





    // 獲取一個數據庫對象，這裡我們選擇abc這個數據庫
    const database = await client.db('sample_restaurants');

    // 獲取一個集合對象，這裡我們選擇def這個集合
    const collection = await database.collection('restaurants');

    try {
        // 使用await關鍵字來等待findOne()方法的返回值，並賦值給doc變量
        const doc = await collection.findOne({});
        // 打印找到的文檔
        console.log('Found the following document:');
        console.log(doc);
      } catch (err) {
        // 捕獲並打印錯誤
        console.error(err);
      }






  } finally {
    // Ensures that the client will close when you finish/error
    await client.close();
  }
}
run().catch(console.dir);
