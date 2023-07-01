let form = document.getElementById('login-form');
form.addEventListener('submit', async function(event) {
    event.preventDefault(); // prevent default submit

    let username = document.getElementById('username').value;
    let password = document.getElementById('password').value;
    let data = 'username=' + username + '&password=' + password;
    try {
        let response = await fetch('/api/auth/login', { // send async requests (submit form)
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: data
        });

        if (response.ok) {
            let data = await response.json();

            if (data.success) { // login success
                let token = data.token;
                localStorage.setItem('token', token); // save jwt to localStorge
                window.location.href = '/msg.html'; // redirect to msg.html
            }
            else { // login failed
                alert(data.message);
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