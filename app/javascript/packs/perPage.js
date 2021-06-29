const form = document.getElementById('per-page-form');
const perPageButton = document.getElementById('per-page-dropdown');

perPageButton.addEventListener('change', () => {
  form.submit();
});
