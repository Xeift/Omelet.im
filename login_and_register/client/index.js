let loginButton = document.getElementById('login-btn');
loginButton.addEventListener('click', async function(event) {
    let username = document.getElementById('username').value;
    let password = document.getElementById('password').value;
    let data = {
        username: username,
        password: password
    };

    try {
        let response = await fetch('/api/auth/login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
        });

        if (response.ok) {
            let data = await response.json();

            if (data.success) {
                let token = data.token;
                localStorage.setItem('token', token);
                document.getElementById('hint-msg').innerHTML = '登入成功';
                // window.location.href = '/msg.html';
            }
            else {
                let isUserExsists = data.isUserExsists;
                if (isUserExsists) {
                    document.getElementById('hint-msg').innerHTML = '帳號或密碼錯誤，請點擊按鈕註冊或找回密碼';
                }
                else if (isUserExsists === false) {
                    document.getElementById('hint-msg').innerHTML = '帳號不存在，請點擊按鈕註冊';
                }
                
            }
        }
        else {
            alert('Server error: ' + response.status);
        }
    }
    catch (err) {
        alert('Error: ' + err.message);
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