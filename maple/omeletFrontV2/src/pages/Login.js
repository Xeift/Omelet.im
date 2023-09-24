import "../layoutCss/Login.css"

function Login (){
    return(
        <div className = "parent">
     
      <div className = "loginMain">
        <h1 className="tracking-in-expand logo">OMLETE</h1>
        
          <div className = "logninRegister">
            <div className = "loginTable">
              <form className = "loginForm">
                <div className = "loginfield">
                  <span className="animate__animated animate__bounce">Email：</span>
                  <input type = 'text' name = "name" placeholder="Enter Your E-mail" />
                </div>
                <div className = "signupfield">
                  <span>Password：</span>
                  <input type = 'password' name = "msg" id = "msg" placeholder="Enter Your Password" />
                </div>
              </form>
          </div>
          <div className = "loginButton">
              <button id="login-btn" class = "btn"><span>  LOGIN  </span></button>
              <button className = "btn"><span>SIGN UP</span></button>
          </div>
          <div id="forgetField">
            <a id = "forgetPasswordButton" href="forget.html">忘記密碼</a>
          </div>
        </div>
    </div>
    </div>
    ); 
}
export default Login;