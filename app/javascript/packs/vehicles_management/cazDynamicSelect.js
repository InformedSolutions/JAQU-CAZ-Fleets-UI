const selectCazElements = document.getElementsByClassName('select-caz-tag');

function submitCazSelectForm(e) {
  document.getElementById(`select_zone_button_${e.target.dataset.key}`).click();
}

for (let i = 0; i < selectCazElements.length; i += 1) {
  selectCazElements[i].addEventListener('change', (e) => submitCazSelectForm(e), true);
}
