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
                let usernameType = data.usernameType;
                if (usernameType) {
                    document.getElementById('hint-msg').innerHTML = '帳號或密碼錯誤，請點擊按鈕註冊或找回密碼？';
                }
                else if (usernameType === false) {
                    document.getElementById('hint-msg').innerHTML = '帳號不存在，請點擊按鈕註冊';
                }
                
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

let restoreButton = document.getElementById('restore-btn');
restoreButton.addEventListener('click', async function(event) {
    let username = document.getElementById('username').value;
    if (username !== null && username !== undefined && username !== '') {
        localStorage.setItem('tempEmailForRestore', username);
    }
    window.location.href = '/restore.html';
})