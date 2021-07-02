export default function initPerPage() {
  const form = document.getElementById('remove-vehicles-form');
  const perPageButton = document.getElementById('per-page-dropdown');

  if (perPageButton) {
    perPageButton.addEventListener('change', () => {
      form.submit();
    });
  }
}
