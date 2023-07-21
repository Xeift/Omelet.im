let isThirdBoxVisible = false;
let isEmailCodeBoxVisible = false;

let registerButton = document.getElementById('register-btn');
registerButton.addEventListener('click', async function(event) {
    let hintMsg = document.getElementById('hint-msg');
    let username = document.getElementById('username').value;
    let usernamePost;
    let emailPost;
    let password = document.getElementById('password').value;


    if (isEmailFormatValid(username)) { // id:username = email, id:username2 = username
        document.getElementById('usernameLabel').innerText = 'email';
        addThirdInputBox('使用者名稱');
        hintMsg.innerText = '請輸入使用者名稱';
        usernamePost = document.getElementById('username2').value;
        emailPost = document.getElementById('username').value;
    }
    else { // id:username = username, id:username2 = email
        document.getElementById('usernameLabel').innerText = '使用者名稱';
        addThirdInputBox('email');
        hintMsg.innerText = '請輸入email';
        usernamePost = document.getElementById('username').value;
        emailPost = document.getElementById('username2').value;
    }


    if (isThirdBoxVisible) {
        //TODO:
        console.log('visible');
        console.log(`使用者名稱：${usernamePost} email：${emailPost} 密碼：${password}`);
        let emptyHintMsg = '請輸入';
        if (isInputEmpty(usernamePost)) { emptyHintMsg = emptyHintMsg + '使用者名稱 ';console.log('a'); }
        if (isInputEmpty(emailPost)) { emptyHintMsg = emptyHintMsg + 'email ';console.log('b'); }
        if (isInputEmpty(password)) { emptyHintMsg = emptyHintMsg + '密碼 ';console.log('c'); }
        console.log(`empthint: ${emptyHintMsg}`);
        console.log(`isInputEmpty(password): ${isInputEmpty(password)} password:[${password}]`);
        if (emptyHintMsg !== '請輸入') { hintMsg.innerHTML = emptyHintMsg; console.log('change!'); }
    }    

    // else {
    //     try {
    //         if (isThirdBoxVisible) {
    //             if (isEmailFormatValid(username)) {
    //                 let response = await fetch('/api/auth/register', {
    //                     method: 'POST',
    //                     headers: {
    //                         'Content-Type': 'application/json'
    //                     },
    //                     body: JSON.stringify({
    //                         username: username,
    //                         password: password
    //                     })
    //                 });
    //                 let responseStatus = response.status
    //                 let responseData = await response.json();
            
    //                 if (responseStatus === 200) {
    //                     let token = responseData.token;
    //                     localStorage.setItem('token', token);
    //                     hintMsg.innerHTML = '登入成功';
    //                     window.location.href = '/msg';
    //                 }
    //                 else if (responseStatus === 401) {
    //                     let isUserExsists = responseData.data.isUserExsists;
    //                     console.log(isUserExsists);
    //                     hintMsg.innerHTML = isUserExsists ? '帳號或密碼錯誤，可重置密碼' : '帳號不存在，可註冊';
    //                 }
    //                 else if (responseStatus === 500) {
    //                     hintMsg.innerHTML = responseData.message;
    //                 }
    //             }
    //             else {
    //                 hintMsg.innerHTML = '';
    //             }
    //         }
    //     }
    //     catch (err) {
    //         hintMsg.innerHTML = `前端發生例外錯誤： ${err.message}`;
    //     }
    // }



})