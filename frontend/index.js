import jQuery from 'jquery';
import page from 'page';
import { default as articleController } from './pages/article';

(function () {
    window.$ = window.jQuery = jQuery;

    // new edit
    page('/@:name/items/new', () => {
        articleController.newAction();
    });

    // edit
    page('/@:name/items/:article_id/edit', () => {
        articleController.editAction();
    });

    // show
    page('/@:name/items/:article_id', () => {
        articleController.showAction();
    });

    // redirector
    page('/redirect', () => {
        const url = $('#js-redirect-url').attr('href');
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
