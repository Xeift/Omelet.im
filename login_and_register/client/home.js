let loginButton = document.getElementById('login-btn');
let hintMsg = document.getElementById('hint-msg');
loginButton.addEventListener('click', async function(event) {
    let username = document.getElementById('username').value;
    let password = document.getElementById('password').value;

    
    try {
        let response = await fetch('/api/auth/login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                username: username,
                password: password
            })
        });
        let responseStatus = response.status
        let responseData = await response.json();

        if (responseStatus === 200) {
            let token = responseData.token;
            localStorage.setItem('token', token);
            hintMsg.innerHTML = '登入成功';
            window.location.href = '/msg';
        }
        else if (responseStatus === 401) {
            let isUserExsists = responseData.data.isUserExsists;
            console.log(isUserExsists);
            hintMsg.innerHTML = isUserExsists ? '帳號或密碼錯誤，可重置密碼' : '帳號不存在，可註冊';
        }
        else if (responseStatus === 500) {
            hintMsg.innerHTML = responseData.message;
        }
    }
    catch (err) {
        hintMsg.innerHTML = `前端發生例外錯誤： ${err.message}`;
    }
});


let isThirdBoxVisible = false;
let isEmailCodeBoxVisible = false;
let registerButton = document.getElementById('register-btn');
registerButton.addEventListener('click', async function(event) {
    let username = document.getElementById('username').value;
    let usernamePost;
    let emailPost;
    let password = document.getElementById('password').value;

    
    if (isEmailFormatValid(username)) { // id:username = email, id:username2 = username
        document.getElementById('usernameLabel').innerText = 'email';
        addThirdInputBox('使用者名稱');
        hintMsg.innerText = '請輸入使用者名稱';
        
        usernamePost = document.getElementById('username2').value;
        emailPost = document.getElementById('username').value;
        console.log(`email username:${usernamePost} email:${emailPost}`);
    }
    else { // id:username = username, id:username2 = email
        document.getElementById('usernameLabel').innerText = '使用者名稱';
        addThirdInputBox('email');
        hintMsg.innerText = '請輸入email';

        usernamePost = document.getElementById('username').value;
        emailPost = document.getElementById('username2').value;
        console.log(`username username:${usernamePost} email:${emailPost}`);
    }


    
    function addThirdInputBox(content) {
        if (isThirdBoxVisible === false) {
            isThirdBoxVisible = true;
            let passwordDiv = ` 
                <div>
                    <label id="usernameLabel2" for="username2">${content}</label>
                    <input type="text" id="username2" name="username2" required>
                </div>
            `;
            document.getElementById('username').insertAdjacentHTML('afterend', passwordDiv); // insert another input box
        }
    }

    try {
        if (isThirdBoxVisible) {
            if (isEmailFormatValid(username)) {
                let response = await fetch('/api/auth/register', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        username: username,
                        password: password
                    })
                });
                let responseStatus = response.status
                let responseData = await response.json();
        
                if (responseStatus === 200) {
                    let token = responseData.token;
                    localStorage.setItem('token', token);
                    hintMsg.innerHTML = '登入成功';
                    window.location.href = '/msg';
                }
                else if (responseStatus === 401) {
                    let isUserExsists = responseData.data.isUserExsists;
                    console.log(isUserExsists);
                    hintMsg.innerHTML = isUserExsists ? '帳號或密碼錯誤，可重置密碼' : '帳號不存在，可註冊';
                }
                else if (responseStatus === 500) {
                    hintMsg.innerHTML = responseData.message;
                }
            }
            else {
                hintMsg.innerHTML = '';
            }
        }



    }
    catch (err) {
        hintMsg.innerHTML = `前端發生例外錯誤： ${err.message}`;
    }
})


let forgotPasswordButton = document.getElementById('forgot-password-btn');
forgotPasswordButton.addEventListener('click', async function(event) {
    let username = document.getElementById('username').value;
    if (username !== null && username !== undefined && username !== '' && isEmailFormatValid(username)) {
        localStorage.setItem('tempEmailForRestore', username);
    }
    window.location.href = '/forgot-password';
})


