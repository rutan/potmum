
(function () {
    const page = require('page');
    const articleController = require('./pages/article');

    // new edit
    page('/@:name/items/new', function () {
        articleController.newAction();
    });

    // edit
    page('/@:name/items/:article_id/edit', function () {
        articleController.editAction();
    });

    // show
    page('/@:name/items/:article_id', function () {
        articleController.showAction();
    });

    // redirector
    page('/redirect', function () {
        let url = $('#js-redirect-url').attr('href');
        if (url) {
            setTimeout(() => {
                location.href = url;
            }, 3000);
        }
    });

    // simple use
    page({
        popstate: false,
        click: false
    })
})();
