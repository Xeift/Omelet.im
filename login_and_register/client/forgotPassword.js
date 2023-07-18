window.onload = function() {
    let tempEmailForRestore = localStorage.getItem('tempEmailForRestore');
    console.log(tempEmailForRestore);
    if ( !(tempEmailForRestore === null || tempEmailForRestore === undefined) ) {
        document.getElementById('email').value = tempEmailForRestore;
    }
    localStorage.removeItem('tempEmailForRestore');
}


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

        if (response.ok) {
            let data = await response.json();

            if (data.success) {
                document.getElementById('hint-msg').innerHTML = '已寄出';
                // window.location.href = '/msg.html';
            }
            else {
                document.getElementById('hint-msg').innerHTML = '不存在';
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