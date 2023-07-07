window.onload = function() {
    let tempEmailForRestore = localStorage.getItem('tempEmailForRestore');
    console.log(tempEmailForRestore);
    if ( !(tempEmailForRestore === null || tempEmailForRestore === undefined) ) {
        document.getElementById('email').value = tempEmailForRestore;
    }
    localStorage.removeItem('tempEmailForRestore');
}
