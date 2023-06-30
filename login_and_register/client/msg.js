function getProtectRes() {
    console.log('succ');
    // 获取受保护的资源
    fetch('/protected-resource', {
        method: 'GET',
        headers: {
            'Authorization': localStorage.getItem('token')
        }
    })
    .then(response => response.json())
    .then(data => {
        console.log(data)
        document.getElementById('moring').innerHTML = data.decodedToken.id + data.decodedToken.username;
    })
    .catch(error => {
        console.error('请求发生错误:', error);
    });
}

