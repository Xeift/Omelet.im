const code = new URLSearchParams(window.location.search).get("code");
console.log(code);
const password = document.getElementById('new-password').value;
const resetBtn = document.getElementById('reset-btn');
resetBtn.addEventListener('click', async function(event) {
    try {
        const response = await fetch(`/reset`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({ code: code, password: password })
        });
        // Parse the response as JSON
        const data = await response.json();
        console.log(data);
    }
    catch (error) {
        console.log(error);
    }
})