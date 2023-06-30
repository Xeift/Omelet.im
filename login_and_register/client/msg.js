function getProtectRes() { // send protected requests
    fetch('/protected-resource', {
        method: 'GET',
        headers: {
            'Authorization': localStorage.getItem('token') // get jwt
        }
    })
    .then(response => response.json())
    .then(data => {
        document.getElementById('moring').innerHTML = data.decodedToken.id + data.decodedToken.username; // display protected data
    })
    .catch(error => {
        console.error('请求发生错误:', error);
    });
}

