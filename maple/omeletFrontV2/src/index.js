import React from 'react';
import ReactDOM from 'react-dom';
import {BrowserRouter as Router, Route, Routes} from 'react-router-dom';
import Login from "./pages/Login";
import reportWebVitals from './reportWebVitals';


ReactDOM.render(
    <Router>
        <Routes>
            <Route path="/" element={<Login />}/>
        </Routes>
    </Router>,
    document.getElementById('root')
);
reportWebVitals();
