import React from 'react';
import Ex from './Ex';
import { useState } from 'react';

function Memo(){
    const [ParentData,SetParantData] = useState(0)
    const func = (type) =>{
        if(type === 'add'){
            SetParantData(ParentData+1)
            console.log(ParentData)
        }else{
            SetParantData(ParentData-1)
            console.log(ParentData)
        }
    }
    return (
        <div>
            <p>ParantData:{ParentData}</p>
            <button onClick={()=>func('add')}>+</button>
            {ParentData}
            <button onClick={()=>func('x')}>+</button>
            <Ex data = {ParentData}/>
        </div>
    );

}

export default Memo