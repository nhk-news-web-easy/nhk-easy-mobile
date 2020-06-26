function callHandler(handlerName, args) {
    if (window.flutter_inappwebview.callHandler) {
        window.flutter_inappwebview.callHandler(handlerName, ...args);
    } else {
        window.flutter_inappwebview._callHandler(handlerName, setTimeout(function () { }), JSON.stringify(args))
    }
}

document.querySelectorAll('.dicWin')
    .forEach(word => {
        word.addEventListener('click', (event) => {
            callHandler('lookup', [word.id])
        })
    })