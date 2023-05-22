import Header from './header';
import { BrowserRouter,Switch,Route } from 'react-router-dom';
import Singin from './pages/Signin'

const test = (prop) => {
    console.log(prop);
    return <h1>Hello</h1>
}

function App(){

    return (<BrowserRouter>
        <Header>
            
        </Header>
        <Switch>
                
                <Route path ='/' exact><Singin/></Route>
        </Switch>
    </BrowserRouter>);
}


export default App;