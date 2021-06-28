const form = document.getElementById('manage-vehicles-form');
const onlyChargeableButton = document.getElementById('only-chargeable');

onlyChargeableButton.addEventListener('click', () => {
  form.submit();
});
