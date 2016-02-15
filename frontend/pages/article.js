const Potmum = require('../legacy');
const renderMathjax = require('../libs/mathjax.js').renderMathjax;

export function newAction() {
    Potmum.createArtcleEditor('.js-article-editor')
}

export function editAction() {
    Potmum.createArtcleEditor('.js-article-editor')
}

export function showAction() {
    Potmum.createCommentForm('.js-comment-form');
    Potmum.createStockButton('.js-stock-button');

    renderMathjax($('.markdown'));
}
