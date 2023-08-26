import React from 'react'
import {Menu ,Form,Container} from 'semantic-ui-react';

function Signin(){
    const [activeItem,setActiveItem] = React.useState('register');
    return(
        <Container>
            <Menu widths = "2">
                <Menu.Item active = {activeItem ==='Sign in'} onClick={()=>setActiveItem("register")}>Sign in</Menu.Item>
                <Menu.Item active = {activeItem === 'register'} onClick={()=>setActiveItem("Signin")}>Log in</Menu.Item>
            </Menu>
            <Form></Form>
        </Container>
    );
}

export default Signin;