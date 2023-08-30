/* eslint-disable no-undef */
let registerButton = document.getElementById('register-btn');
registerButton.addEventListener('click', async function(event) {
    let hintMsg = document.getElementById('hint-msg');
    let email = document.getElementById('username').value;
    let data = {
        email: email
    };

    try {
        if (isInputEmpty(email) === false) {
            let response = await fetch('/api/auth/verify-email', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            });
            let responseStatus = response.status;
            let responseData = await response.json();

            if (responseStatus === 200) {
                hintMsg.innerHTML = 'email 已成功寄出，請查看信箱並依照指示註冊';
            }
            else if (responseStatus === 401) {
                hintMsg.innerHTML = 'email 已存在';
            }
            else if (responseStatus === 500) {
                hintMsg.innerHTML = responseData.message;
            }
        }
        else {
            hintMsg.innerText = '請輸入 Email';
        }

    }
    catch (err) {
        hintMsg.innerHTML = `前端發生例外錯誤： ${err.message}`;
    }

});