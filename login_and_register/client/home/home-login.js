let loginButton = document.getElementById('login-btn');
loginButton.addEventListener('click', async function(event) {
    let username = document.getElementById('username').value;
    let password = document.getElementById('password').value;
    let hintMsg = document.getElementById('hint-msg');
    

    if (isInputEmpty(username) && isInputEmpty(password)) {
        hintMsg.innerText = '請填寫 帳號/email 及 密碼 欄位'; 
    }
    else if (isInputEmpty(password)) {
        hintMsg.innerText = '請填寫 密碼 欄位'; 
    }
    else if (isInputEmpty(username)) {
        hintMsg.innerText = '請填寫 帳號/email 欄位'; 
    }
    else {
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
            let responseStatus = response.status;
            let responseData = await response.json();
    
    
            if (responseStatus === 200) {
                let token = responseData.token;
                localStorage.setItem('token', token);
                hintMsg.innerHTML = '登入成功';
                window.location.href = '/msg';
            }
            else if (responseStatus === 401) {
                let isUserExsists = responseData.data.isUserExsists;
                hintMsg.innerHTML = isUserExsists ? '帳號或密碼錯誤，可重置密碼' : '帳號不存在，可註冊';
            }
            else if (responseStatus === 500) {
                hintMsg.innerHTML = responseData.message;
            }
        }
        catch (err) {
            hintMsg.innerHTML = `前端發生例外錯誤： ${err.message}`;
        }
    }
});