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
        let responseData = await response.json();
        let responseStatus = response.status
        console.log(responseStatus);

        if (responseStatus === 200) {
            let token = responseData.token;
            localStorage.setItem('token', token);
            hintMsg.innerHTML = '登入成功';
            // window.location.href = '/msg.html';
        }
        else if (responseStatus === 401) {
            let isUserExsists = data.isUserExsists;
            if (isUserExsists) {
                hintMsg.innerHTML = '帳號或密碼錯誤，請點擊按鈕註冊或找回密碼';
            }
            else if (isUserExsists === false) {
                hintMsg.innerHTML = '帳號不存在，請點擊按鈕註冊';
            }
        }
        else if (responseStatus === 500) {
            hintMsg.innerHTML = `伺服器錯誤 ${response.status}`;
        }
    }
    catch (err) {
        hintMsg.innerHTML = `發生錯誤: ${err.message}`;
    }
});


let restoreButton = document.getElementById('restore-btn');
restoreButton.addEventListener('click', async function(event) {
    let username = document.getElementById('username').value;
    if (username !== null && username !== undefined && username !== '' && isEmailFormatValid(username)) {
        localStorage.setItem('tempEmailForRestore', username);
    }
    window.location.href = '/restore.html';
})


function isEmailFormatValid(input) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(input);
}