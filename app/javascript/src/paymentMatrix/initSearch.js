import createHiddenInput from './createHiddenInput';
import submitForm from './submitForm';

const isIE11 = !!window.MSInputMethodContext && !!document.documentMode;

function submitSearch(e, form) {
  form.appendChild(createHiddenInput('commit', 'Search'));
  submitForm(e, form);
}

function submitClear(e, form) {
  document.getElementById('vrn-search').value = '';
  form.appendChild(createHiddenInput('commit', 'Clear search'));
  submitForm(e, form);
}

function initClearButton(clearButton, form) {
  clearButton.addEventListener('click', (e) => submitClear(e, form));
}

export default function initSearch() {
  const searchButton = document.getElementById('search-form-submit');
  const searchInput = document.getElementById('vrn-search');
  const clearButton = document.getElementById('clear-search-link');
  const form = document.getElementById('payment-form');

  searchButton.addEventListener('click', (e) => submitSearch(e, form));

  if (!isIE11) {
    searchInput.addEventListener(
      'keydown',
      (e) => e.code === 'Enter' && submitSearch(e, form),
    );
  } else {
    searchInput.addEventListener(
      'keydown',
      (e) => e.keyCode === 13 && submitSearch(e, form),
    );
  }

  /* eslint-disable no-unused-expressions */
  clearButton && initClearButton(clearButton, form);
}
