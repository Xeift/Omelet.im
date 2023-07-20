let registerButton = document.getElementById('register-button');
registerButton.addEventListener('click', async function() {
    let username = document.getElementById('username').value;
    let password = document.getElementById('password').value;
    let data = JSON.stringify({ username: username, password: password });

    try {
        let response = await fetch('/api/auth/register', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: data
        });

        if (response.ok) {
            let message = await response.text();
            alert(message);
        } else {
            let errorMessage = await response.text();
            alert('註冊失敗: ' + errorMessage);
        }
    } catch (err) {
        alert('錯誤: ' + err.message);
    }
});
