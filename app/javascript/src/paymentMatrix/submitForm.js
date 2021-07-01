import createHiddenInput from './createHiddenInput';

function disableButtons() {
  document.querySelectorAll('input[type=submit],input[type=button]')
    .forEach((button) => {
      const btn = button;
      btn.disabled = true;
    });

  document.querySelectorAll('li.moj-pagination__item').forEach((li) => {
    li.classList.add('is-disabled');
  });
}

export default function submitForm(e, form) {
  e.preventDefault();
  disableButtons();

  const searchInput = document.getElementById('vrn-search');
  form.appendChild(createHiddenInput('payment[vrn_search]', searchInput.value));
  form.submit();
}
