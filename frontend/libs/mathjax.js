export function renderMathjax(jqueryElement) {
    jqueryElement.find('[data-lang="math"]').each(function (_, element) {
        const elem = $(element);
        const html = '$$\n' + elem.find('code').html() + '\n$$';
        elem.before($('<div class="math-box"></div>').text(html));
        elem.remove();
    });
    MathJax.Hub.Configured();
    MathJax.Hub.Queue(['Typeset', MathJax.Hub, jqueryElement.get()]);
}
