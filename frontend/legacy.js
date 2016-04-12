import { default as Vue } from 'vue';
import { default as CodeMirror } from 'codemirror';
import { renderMathjax } from './libs/mathjax.js';
require('codemirror/mode/gfm/gfm');
require('codemirror/addon/edit/closetag');

module.exports = (function () {
    let Potmum = {};

    Potmum.createArtcleEditor = function (element) {
        return new Vue({
            el: element,
            data: {
                id: null,
                title: '',
                tags: [],
                body: '',
                preview_html: '',
                publish_type: 'public_item',
                tagFocus: false,
                sendingFlag: false
            },
            computed: {
                bodyField: {
                    get: function () {
                        return this.$data.body
                    },
                    set: function (text) {
                        this.$data.body = text;
                        if (this._previewID) clearTimeout(this._previewID);
                        var self = this;
                        this._previewID = setTimeout(function () {
                            self._previewID = null;
                            self.preview();
                        }, 500);
                    }
                }
            },
            ready: function () {
                this.leftAlertFlag = false;
                this.$data.id = $(this.$el).data('id');
                this.$data.tags = $(this.$el).find('.js-tags-text').val().split(/\s/).filter(function (n) {
                    return ('' + n).length > 0;
                });
                this.$data.publish_type = $(this.$el).data('publish_type');

                // codemirror
                this.code = CodeMirror.fromTextArea($(this.$el).find('.js-textarea')[0], {
                    mode: 'gfm',
                    autoCloseTags: true,
                    lineNumbers: true,
                    lineWrapping: true,
                    indentUnit: 4,
                    extraKeys: {
                        Tab: (cm) => {
                            cm.execCommand('insertSoftTab');
                        },
                        'Shift-Tab': (cm) => {
                            cm.indentSelection('subtract');
                        }
                    }
                });
                this.code.on('change', () => {
                    this.bodyField = this.code.getValue();
                });
                this.code.on('scroll', (cm) => {
                    const previewElement = $(this.$el).find('.editor-preview-field');
                    const per = cm.display.scroller.scrollTop / (cm.display.scroller.scrollHeight - cm.display.scroller.clientHeight);
                    previewElement.scrollTop((previewElement[0].scrollHeight - previewElement.height()) * per);
                });

                // assign
                this.title = $(this.$el).find('.js-title-text').val();
                this.bodyField = this.code.getValue();
            },
            methods: {
                onRemoveTag: function (e, content) {
                    this.editStart();
                    e.preventDefault();
                    var i = this.$data.tags.indexOf(content);
                    if (i != -1) {
                        this.$data.tags.$remove(i);
                    }
                },
                onBlurTag: function (e) {
                    e.preventDefault();
                    var target = $(e.target);
                    target.val(target.val() + ' ');
                    this.onInputTag(e);
                },
                onInputTag: function (e) {
                    this.editStart();
                    this.$data.tagFocus = true;
                    var target = $(e.target);
                    var contents = target.val().split(/\s|　/);
                    if (contents.length > 1) {
                        for (var i = 0; i < contents.length - 1; ++i) {
                            if (contents[i].length > 0 && this.$data.tags.length < 5 && this.$data.tags.indexOf(contents[i]) == -1) {
                                this.$data.tags.push(contents[i]);
                            }
                        }
                        target.val('');
                    } else {
                        target.css('width', (3 + target.val().length * 2) + 'em');
                    }
                },
                onRemoveLastTag: function (e) {
                    this.editStart();
                    var target = $(e.target);
                    if (this.$data.tags.length > 0 && target.val() == '') {
                        this.$data.tags.$remove(this.$data.tags.length - 1);
                    }
                },
                onClickTagForm: function (e) {
                    e.preventDefault();
                    $(this.$el).find('.js-tag-field').focus();
                },
                onClickSetSaveMode: function (e, mode) {
                    e.preventDefault();
                    this.$data.publish_type = mode;
                },
                preview: function () {
                    if (this.$data.body.length == 0) {
                        this.$data.preview_html = '';
                        return;
                    }

                    $.ajax({
                        url: this.$data.id ? '../preview.json' : '../items/preview.json',
                        type: 'post',
                        data: {
                            body: this.$data.body
                        },
                        success: (resp) => {
                            if (this.$data.preview_html.length > 0 && this.$data.preview_html != resp.data.markdown_html) {
                                this.editStart();
                            }
                            this.$data.preview_html = resp.data.markdown_html;

                            // bad method
                            setTimeout(() => {
                                renderMathjax($(this.$el).find('.markdown'));
                            }, 100);
                        }
                    });
                },
                onClickSubmit: function (e) {
                    e.preventDefault();

                    // validation
                    if (this.$data.title.length < 1 || this.$data.title.length > 64) {
                        alert('タイトルを1〜64文字で入力してください。');
                        return;
                    }
                    if (this.$data.body.length < 1 || this.$data.body.length > 100000) {
                        alert('本文を1〜100000文字で入力してください。');
                        return;
                    }

                    // send
                    var self = this;
                    self.$data.sendingFlag = true;
                    $.ajax({
                        url: this.$data.id ? '../' + this.$data.id + '.json' : '../items.json',
                        type: this.$data.id ? 'put' : 'post',
                        data: {
                            title: this.$data.title,
                            tags_text: this.$data.tags.join(' '),
                            body: this.$data.body,
                            publish_type: this.$data.publish_type
                        },
                        success: function (resp) {
                            $(window).off('beforeunload');
                            if (self.$data.publish_type != 'draft_item') {
                                location.href = resp.data.url;
                            } else {
                                location.href = (self.$data.id ? '../' : '') + '../drafts';
                            }
                        },
                        error: function (e) {
                            console.error(e);
                            self.$data.sendingFlag = false;
                            alert('エラーしたよ');
                        }
                    });
                },
                onChangePictureFile: function (e) {
                    if (e.target.files.length == 0) return;
                    this.uploadPicture(e.target.files[0]);
                },
                onDropFile: function (e) {
                    if (e.dataTransfer.files.length == 0) return;
                    e.preventDefault();
                    this.uploadPicture(e.dataTransfer.files[0]);
                },
                uploadPicture: function (file) {
                    var formData = new FormData();
                    formData.append('file', file);
                    var self = this;
                    $.ajax({
                        url: '/attachment_files.json',
                        method: 'post',
                        dataType: 'json',
                        data: formData,
                        processData: false,
                        contentType: false,
                        success: function (resp) {
                            var doc = self.code.getDoc();
                            var textarea = $(self.$el).find('.js-textarea')[0];
                            var n = textarea.selectionEnd;
                            var text = doc.getSelections()[0];
                            if (text.length == 0) text = 'img';
                            var str = `\n![${text}](${resp.data.url})\n`;
                            doc.replaceSelection(str);
                        },
                        error: function (err) {
                            console.error(err);
                            alert('エラーしたよ');
                        }
                    });
                },
                editStart: function () {
                    if (!this.leftAlertFlag) {
                        this.leftAlertFlag = true;
                        $(window).on('beforeunload', function () {
                            return "このままページを移動すると編集内容が保存されません。";
                        });
                    }
                }
            }
        });
    };

    Potmum.createCommentForm = function (element) {
        if ($(element).length == 0) return;
        return new Vue({
            el: element,
            data: {
                body: '',
                url: '',
                modePreview: false,
                preview_html: '',
                count: 2048,
                sendingFlag: false,
            },
            computed: {
                bodyField: {
                    get: function () {
                        return this.$data.body
                    },
                    set: function (text) {
                        this.$data.body = text;
                        this.$data.count = 2048 - text.length;
                    }
                }
            },
            ready: function () {
                this.$data.url = $(this.$el).data('url');
            },
            methods: {
                changeToForm: function (e) {
                    e.preventDefault();
                    this.$data.modePreview = false;
                },
                changeToPreview: function (e) {
                    e.preventDefault();
                    if (this.$data.modePreview) return;
                    this.$data.modePreview = true;

                    var self = this;
                    $.ajax({
                        url: '/comments/preview.json',
                        type: 'post',
                        data: {
                            body: this.$data.body
                        },
                        success: function (resp) {
                            self.$data.preview_html = resp.data.markdown_html;
                        },
                        error: function (e) {
                            console.error(e);
                            self.$data.preview_html = 'エラーが発生しました';
                        }
                    });
                },
                onSubmit: function (e) {
                    e.preventDefault();
                    this.$data.sendingFlag = true;
                    $.ajax({
                        url: this.$data.url,
                        type: 'post',
                        data: {
                            body: this.$data.body
                        },
                        success: function (resp) {
                            location.href = resp.data.url;
                            location.reload();
                        },
                        error: function (e) {
                            console.error(e);
                            alert('エラーが発生しました');
                            this.$data.sendingFlag = false;
                        }
                    });
                }
            }
        });
    };

    Potmum.createStockButton = function (element) {
        if ($(element).length == 0) return;
        return new Vue({
            el: element,
            data: {
                url: '',
                stocked: false
            },
            ready: function () {
                this.$data.url = $(this.$el).data('url');
                this.$data.stocked = parseInt($(this.$el).data('stocked')) != 0;
            },
            methods: {
                onClick: function (e) {
                    e.preventDefault();
                    this.$data.stocked = !this.$data.stocked;
                    $.ajax({
                        url: this.$data.url,
                        type: 'put',
                        data: {
                            stocked: this.$data.stocked ? 1 : 0
                        }
                    });
                }
            }
        });
    };

    return Potmum;
})();
