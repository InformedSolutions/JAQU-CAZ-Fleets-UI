export default function () {
  recalculateContinueButtonDisability();
  attachRecalculationToCheckboxes();
}

function attachRecalculationToCheckboxes() {
  var allCheckboxes = document.getElementsByClassName('govuk-checkboxes__input');

  for(var checkbox of allCheckboxes) {
    checkbox.addEventListener('click', recalculateContinueButtonDisability);
  }
}

function recalculateContinueButtonDisability() {
  var allCheckboxes = document.getElementsByClassName('govuk-checkboxes__input');
  var selectedCheckboxesCount = countCheckedCheckboxes(allCheckboxes);
  var continueButton = document.getElementById('continue-matrix-button');

  if (continueButton != null) {
    continueButton.disabled = selectedCheckboxesCount === 0;
  }
}

function countCheckedCheckboxes(checkboxes) {
  var checkedCheckboxesCount = 0;
  for(var checkbox of checkboxes) {
    if (checkbox.checked) checkedCheckboxesCount++;
  }
  return checkedCheckboxesCount;
}
