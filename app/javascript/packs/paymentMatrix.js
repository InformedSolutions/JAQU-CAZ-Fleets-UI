/* eslint-disable func-names */
import initSearch from '../src/paymentMatrix/initSearch';
import initPaginationButtons from '../src/paymentMatrix/initPaginationButtons';
import preventContinue from '../src/paymentMatrix/emptyMatrixContinuePrevention';

window.addEventListener('DOMContentLoaded', () => {
  preventContinue();
  initSearch();
  initPaginationButtons();
});
