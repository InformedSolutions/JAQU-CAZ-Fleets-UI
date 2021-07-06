function refreshContinueButtonDisability() {
  const allSelectedCheckboxesCount = document.getElementById('all_selected_checkboxes_count');
  const continueButton = document.getElementById('continue-remove-vehicles-button');

  if (continueButton != null) {
    continueButton.disabled = parseInt(allSelectedCheckboxesCount.value || 0, 10) === 0;
  }
}

function recalculateAllCheckedCheckboxesCount(target) {
  const allSelectedCheckboxesCountInput = document.getElementById('all_selected_checkboxes_count');
  let allSelectedCheckboxesCount = parseInt(allSelectedCheckboxesCountInput.value || 0, 10);

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
