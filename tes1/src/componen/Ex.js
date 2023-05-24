import React from 'react';
import { useState } from 'react';
const Ex = (props) =>{
    console.log(props)
    return(
        <div>
            <p>subcomponent:{props.data}</p>
        </div>


    );
}

export default Ex
