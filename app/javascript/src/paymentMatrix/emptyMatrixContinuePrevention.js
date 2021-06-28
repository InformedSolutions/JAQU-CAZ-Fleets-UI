function refreshContinueButtonDisability() {
  const allSelectedCheckboxesCount = document.getElementById('allSelectedCheckboxesCount');
  const continueButton = document.getElementById('continue-matrix-button');

  if (continueButton != null) {
    continueButton.disabled = parseInt(allSelectedCheckboxesCount.value, 10) === 0;
  }
}

function recalculateAllCheckedCheckboxesCount(target) {
  const allSelectedCheckboxesCountInput = document.getElementById('allSelectedCheckboxesCount');
  let allSelectedCheckboxesCount = parseInt(allSelectedCheckboxesCountInput.value, 10);

  if (target.checked) {
    allSelectedCheckboxesCount += 1;
  } else {
    allSelectedCheckboxesCount -= 1;
  }

  allSelectedCheckboxesCountInput.value = allSelectedCheckboxesCount;
  refreshContinueButtonDisability();
}

function attachRecalculationToCheckboxes() {
  const allCheckboxes = document.getElementsByClassName('govuk-checkboxes__input');

  Array.prototype.forEach.call(allCheckboxes, (checkbox) => {
    checkbox.addEventListener('click', (e) => { recalculateAllCheckedCheckboxesCount(e.target); });
  });
}

export default function emptyMatrixContinuePrevention() {
  refreshContinueButtonDisability();
  attachRecalculationToCheckboxes();
}
