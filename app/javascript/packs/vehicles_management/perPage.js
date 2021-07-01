const form = document.getElementById('manage-vehicles-form');
const perPageButton = document.getElementById('per-page-dropdown');

perPageButton.addEventListener('change', () => {
  form.submit();
});
