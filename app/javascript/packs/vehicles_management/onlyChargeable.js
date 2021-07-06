const form = document.getElementById('per-page-form');
const onlyChargeableButton = document.getElementById('only-chargeable');

onlyChargeableButton.addEventListener('click', () => {
  form.submit();
});
