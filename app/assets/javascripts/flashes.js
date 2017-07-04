$(document).ready(function() {
    $(window).bind('rails:flash', function(e, params) {
        new PNotify({
            //title: params.type,
            text: params.message,
            addclass: 'flash_notices',
            icon: 'fa fa-bell-o',
            type: params.type,
            nonblock: {
                nonblock: true
            }
        });
    });
});