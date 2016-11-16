import { renderMathjax } from '../libs/mathjax.js';
import { default as Potmum } from '../legacy';

function newAction() {
    Potmum.createArtcleEditor('.js-article-editor')
}

function editAction() {
    Potmum.createArtcleEditor('.js-article-editor')
}

function showAction() {
    Potmum.createCommentForm('.js-comment-form');
    Potmum.createCheckButton('.js-like-button');
    Potmum.createCheckButton('.js-stock-button');

    renderMathjax($('.markdown'));
}

export default {
    newAction: newAction,
    editAction: editAction,
    showAction: showAction
}
