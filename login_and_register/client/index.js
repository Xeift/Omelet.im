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
                document.getElementById('hint-msg').innerHTML = '登入失敗，是否要<a href="/restore.html">找回密碼</a>';
                console.log(data.usernameType);
            }
        } else {
            alert('Server error: ' + response.status);
        }
    } catch (err) {
        alert('Error: ' + err.message);
    }
});



// let signupButton = document.getElementById('signup-btn');
// loginButton.addEventListener('click', async function(event) {
//     let username = document.getElementById('username').value;
//     let password = document.getElementById('password').value;
//     let data = {
//         username: username,
//         password: password
//     };

//     try {
//         let response = await fetch('/api/auth/login', {
//             method: 'POST',
//             headers: {
//                 'Content-Type': 'application/json'
//             },
//             body: JSON.stringify(data)
//         });

//         if (response.ok) {
//             let data = await response.json();

//             if (data.success) {
//                 let token = data.token;
//                 localStorage.setItem('token', token);
//                 document.getElementById('hint-msg').innerHTML = '登入成功';
//                 // window.location.href = '/msg.html';
//             } else {
//                 document.getElementById('hint-msg').innerHTML = '登入失敗，是否要<a href="/restore.html">找回密碼</a>'                ';
//             }
//         } else {
//             alert('Server error: ' + response.status);
//         }
//     } catch (err) {
//         alert('Error: ' + err.message);
//     }
// });
