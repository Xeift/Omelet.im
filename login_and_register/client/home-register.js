let registerButton = document.getElementById('register-btn');
registerButton.addEventListener('click', async function(event) {
    let hintMsg = document.getElementById('hint-msg');
    let email = document.getElementById('username').value;
    let password = document.getElementById('password').value;
    let data = {
        email: email
    };

    try {
        let response = await fetch('/api/auth/verify-email', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
        });
        let responseStatus = response.status
        let responseData = await response.json();

        if (responseStatus === 200) {
            hintMsg.innerHTML = 'email 已成功寄出';
        }
        else if (responseStatus === 401) {
            hintMsg.innerHTML = 'email 不存在';
        }
        else if (responseStatus === 500) {
            hintMsg.innerHTML = responseData.message;
        }
    }
    catch (err) {
        hintMsg.innerHTML = `前端發生例外錯誤： ${err.message}`;
    }

})