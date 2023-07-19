const resetBtn = document.getElementById('reset-btn');
resetBtn.addEventListener('click', async function(event) {
    try {
        const code = new URLSearchParams(window.location.search).get('code');
        console.log(`code: ${code}`);
        const password = document.getElementById('new-password').value;
        console.log(`password: ${password}`);
        const response = await fetch('/update-password', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                code: code,
                password: password 
            })
        });
        let responseStatus = response.status
        const responseData = await response.json();
        console.log(responseData);
    }
    catch (error) {
        console.log(error);
    }
})