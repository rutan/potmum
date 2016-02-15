export function renderMathjax(jqueryElement) {
    jqueryElement.find('[data-lang="math"]').each(function (_, element) {
        $(element).html('$' + $(element).find('pre').html() + '$');
    });
    MathJax.Hub.Configured();
    MathJax.Hub.Queue(['Typeset', MathJax.Hub, jqueryElement.get()]);
}
