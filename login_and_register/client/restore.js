window.onload = function() {
    let tempEmailForRestore = localStorage.getItem('tempEmailForRestore');
    console.log(tempEmailForRestore);
    if ( !(tempEmailForRestore === null || tempEmailForRestore === undefined) ) {
        alert('exsist');
    }
    localStorage.removeItem('tempEmailForRestore');
}
