let loginButton = document.getElementById('login-button');
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
                window.location.href = '/msg.html';
            } else {
                alert(data.message);
            }
        } else {
            alert('Server error: ' + response.status);
        }
    } catch (err) {
        alert('Error: ' + err.message);
    }
});
