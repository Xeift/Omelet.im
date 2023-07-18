let loginButton = document.getElementById('login-btn');
loginButton.addEventListener('click', async function(event) {
    let username = document.getElementById('username').value;
    let password = document.getElementById('password').value;
    let hintMsg = document.getElementById('hint-msg');
    
    let requestData = {
        username: username,
        password: password
    };
    
    try {
        let response = await fetch('/api/auth/login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(requestData)
        });
        let responseStatus = response.status
        let responseData = await response.json();

        if (responseStatus === 200) {
            let token = responseData.token;
            localStorage.setItem('token', token);
            hintMsg.innerHTML = '登入成功';
            // window.location.href = '/msg.html';
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


let forgotPasswordButton = document.getElementById('forgot-password-btn');
forgotPasswordButton.addEventListener('click', async function(event) {
    let username = document.getElementById('username').value;
    if (username !== null && username !== undefined && username !== '' && isEmailFormatValid(username)) {
        localStorage.setItem('tempEmailForRestore', username);
    }
    window.location.href = '/forgot-password';
})


function isEmailFormatValid(input) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(input);
}