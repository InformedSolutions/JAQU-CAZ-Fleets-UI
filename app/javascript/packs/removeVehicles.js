/* eslint-disable func-names */
import initSearch from '../src/removeVehicles/initSearch';
import initPaginationButtons from '../src/removeVehicles/initPaginationButtons';
import preventContinue from '../src/removeVehicles/emptyMatrixContinuePrevention';
import initPerPage from '../src/removeVehicles/perPage';

window.addEventListener('DOMContentLoaded', () => {
  preventContinue();
  initSearch();
  initPaginationButtons();
  initPerPage();
});
