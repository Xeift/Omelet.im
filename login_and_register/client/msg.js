function getProtectRes() { // send protected requests
    fetch('/protected-resource', {
        method: 'GET',
        headers: {
            'Authorization': localStorage.getItem('token') // get jwt
        }
    })
    .then(response => response.json())
    .then(data => {
        document.getElementById('moring').innerHTML = data.decodedToken.id +'<br>'+ data.decodedToken.username; // display protected data
    })
    .catch(error => {
        console.error('錯誤', error);
    });
}

