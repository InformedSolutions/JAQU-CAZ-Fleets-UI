import submitForm from './submitForm';

function addPageNumber(page) {
  const input = document.createElement('input');
  input.type = 'hidden';
  input.name = 'commit';
  input.value = page;
  return input;
}

function addEventListeners(page) {
  const form = document.getElementById('payment-form');
  const paginationButtonActive = document.getElementById(`pagination-button-${page}`);
  if (paginationButtonActive) {
    paginationButtonActive.addEventListener('click', (e) => {
      form.appendChild(addPageNumber(page));
      submitForm(e, form);
    });
  }

  const paginationButtonPrevious = document.getElementById('pagination-button-previous');
  if (paginationButtonPrevious) {
    paginationButtonPrevious.addEventListener('click', (e) => {
      form.appendChild(addPageNumber(page));
      submitForm(e, form);
    });
  }

  const paginationButtonNext = document.getElementById('pagination-button-next');
  if (paginationButtonNext) {
    paginationButtonNext.addEventListener('click', (e) => {
      form.appendChild(addPageNumber(page));
      submitForm(e, form);
    });
  }
}

export default function initPaginationButtons() {
  const allPageNumberButtons = document.getElementsByClassName('moj-pagination__link page-number');
  Array.prototype.forEach.call(allPageNumberButtons, (btn) => {
    const urlParams = new URLSearchParams(btn.href.split('?')[1]);
    const page = urlParams.get('page');
    btn.addEventListener('click', () => {
      addEventListeners(page);
    });
  });
}
