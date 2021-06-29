/* eslint-disable func-names */
import initSearch from '../src/paymentMatrix/initSearch';
import initPaginationButton from '../src/paymentMatrix/initPaginationButton';
import preventContinue from '../src/paymentMatrix/emptyMatrixContinuePrevention';

window.addEventListener('DOMContentLoaded', () => {
  preventContinue();
  initSearch();
});

window.addPage = function (page) {
  initPaginationButton(page);
};
