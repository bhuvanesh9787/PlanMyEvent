document.addEventListener('DOMContentLoaded', function () {
    const phoneFields = document.querySelectorAll('input[name="phone"]');
    phoneFields.forEach(function (f) {
        f.addEventListener('blur', function () {
            if (!/^\d{10}$/.test(f.value.trim())) showError(f, 'Phone must be exactly 10 digits.');
            else clearError(f);
        });
    });

    const cardField = document.getElementById('cardNum');
    if (cardField) {
        cardField.addEventListener('blur', function () {
            const digits = cardField.value.replace(/\s/g, '');
            if (!/^\d{16}$/.test(digits)) showError(cardField, 'Card number must be 16 digits.');
            else clearError(cardField);
        });
    }

    const cvvField = document.querySelector('input[name="cvv"]');
    if (cvvField) {
        cvvField.addEventListener('blur', function () {
            if (!/^\d{3}$/.test(cvvField.value)) showError(cvvField, 'CVV must be 3 digits.');
            else clearError(cvvField);
        });
    }

    const expiryField = document.querySelector('input[name="expiry"]');
    if (expiryField) {
        expiryField.addEventListener('blur', function () {
            const val = expiryField.value;
            if (!/^\d{2}\/\d{2}$/.test(val)) { showError(expiryField, 'Enter expiry as MM/YY.'); return; }
            const parts = val.split('/');
            const month = parseInt(parts[0], 10);
            const year  = parseInt('20' + parts[1], 10);
            const now   = new Date();
            if (month < 1 || month > 12 || year < now.getFullYear() ||
               (year === now.getFullYear() && month < now.getMonth() + 1)) {
                showError(expiryField, 'Card is expired or date is invalid.');
            } else clearError(expiryField);
        });
    }

    function showError(field, msg) {
        clearError(field);
        const err = document.createElement('span');
        err.className = 'field-error';
        err.textContent = msg;
        field.parentNode.appendChild(err);
        field.style.borderColor = '#e74c3c';
    }
    function clearError(field) {
        const ex = field.parentNode.querySelector('.field-error');
        if (ex) ex.remove();
        field.style.borderColor = '';
    }
});

function formatCard(input) {
    let val = input.value.replace(/\D/g, '').substring(0, 16);
    input.value = val.replace(/(.{4})/g, '$1 ').trim();
}