/*
    WebViewJavaScriptBridge
*/

function setupWebViewJavascriptBridge(callback) {
    if (window.WebViewJavascriptBridge) { return callback(WebViewJavascriptBridge); }
    if (window.WVJBCallbacks) { return window.WVJBCallbacks.push(callback); }
    window.WVJBCallbacks = [callback];
    var WVJBIframe = document.createElement('iframe');
    WVJBIframe.style.display = 'none';
    WVJBIframe.src = 'wvjbscheme://__BRIDGE_LOADED__';
    document.documentElement.appendChild(WVJBIframe);
    setTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0)
}

setupWebViewJavascriptBridge(function(bridge) {

    /* Initialize your app here */
    $(".img-responsive").each(function() {
        $(this).unbind().bind('click', function() {
            bridge.callHandler('imgCallback', $(this).attr('src'), function(response) {
                console.log('JS received: ', response);
            });
        });
    });
})