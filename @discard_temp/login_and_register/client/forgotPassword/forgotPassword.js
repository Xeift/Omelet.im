window.onload = function() {
    let tempEmailForRestore = localStorage.getItem('tempEmailForRestore');
    if ( !(tempEmailForRestore === null || tempEmailForRestore === undefined) ) {
        document.getElementById('email').value = tempEmailForRestore;
    }
    localStorage.removeItem('tempEmailForRestore');
};


let hintMsg = document.getElementById('hint-msg');
let resetPasswordButton = document.getElementById('reset-password-btn');
resetPasswordButton.addEventListener('click', async function(event) {
    let email = document.getElementById('email').value;
    let data = {
        email: email
    };

    try {
        let response = await fetch('/api/auth/reset-password', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
        });
        let responseStatus = response.status;
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
});