function addThirdInputBox(content) {
    if (isThirdBoxVisible === false) {
        isThirdBoxVisible = true;
        let passwordDiv = ` 
            <div>
                <label id="usernameLabel2" for="username2">${content}</label>
                <input type="text" id="username2" name="username2" required>
            </div>
        `;
        document.getElementById('username').insertAdjacentHTML('afterend', passwordDiv); // insert another input box
    }
}