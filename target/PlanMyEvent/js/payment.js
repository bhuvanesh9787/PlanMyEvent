function showTab(tab) {
    document.getElementById('card-section').style.display = tab === 'card' ? 'block' : 'none';
    document.getElementById('qr-section').style.display   = tab === 'qr'   ? 'block' : 'none';
    document.querySelectorAll('.tab').forEach(function (t) { t.classList.remove('active'); });
    event.target.classList.add('active');
}