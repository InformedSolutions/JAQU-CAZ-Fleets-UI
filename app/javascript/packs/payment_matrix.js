import initSearch from "../src/payment_matrix/initSearch";
import initPaginationButton from "../src/payment_matrix/initPaginationButton";

window.addEventListener("DOMContentLoaded", () => {
    initSearch();
    ["next", "previous"].forEach((direction) => initPaginationButton(direction));
});
