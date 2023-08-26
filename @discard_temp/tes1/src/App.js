import Memo from "./componen/Memo"
const test1 = () =>{
  console.log('test1Text')
}
const test2 = (e) =>{
  console.log(e)
}
function test(){
  return( console.log('you press the test function'));
 
}
function App() {
  
  return (
    <div>
      <h1>adfas</h1>
      <button onClick={test1}>press me</button>
      <button onClick={() => test2('2')}>press me1</button>
      <test />
      <Memo />
    </div>
    
  );
}


export default App;
