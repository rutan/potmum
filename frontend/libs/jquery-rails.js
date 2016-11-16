import jQuery from 'jquery';

export default function () {
    const $ = window.$ = window.jQuery = jQuery;

    $('[data-method]').each((_, element) => {
        const el = $(element);
        el.on('click', (e) => {
            e.preventDefault();
            const form = document.createElement('form');
            form.action = el.attr('href');
            form.method = 'post';

            const csrfTokenInput = document.createElement('input');
            csrfTokenInput.setAttribute('type', 'hidden');
            csrfTokenInput.setAttribute('name', 'authenticity_token');
            csrfTokenInput.setAttribute('value', $('meta[name="csrf-token"]').attr('content'));
            form.appendChild(csrfTokenInput);

            const methodInput = document.createElement('input');
            methodInput.setAttribute('type', 'hidden');
            methodInput.setAttribute('name', '_method');
            methodInput.setAttribute('value', el.data('method'));
            form.appendChild(methodInput);

            document.body.appendChild(form);
            form.submit();
        });
    });
}
