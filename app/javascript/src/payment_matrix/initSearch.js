import createHiddenInput from "./createHiddenInput";
import submitForm from "./submitForm";

export default function () {
    const searchForm = document.getElementById("search-form");
    const initClearButton = document.getElementById("clear-search-link");
    const paymentForm = document.getElementById("payment-form");

    searchForm.addEventListener("submit", (event) => {
        event.preventDefault();
        paymentForm.appendChild(createHiddenInput("commit", "Search"));
        submitForm(paymentForm);
    });

    initClearButton.addEventListener("click", (event) => {
      event.preventDefault();
      paymentForm.appendChild(createHiddenInput("commit", "Clear search"));
      document.getElementById("vrn-search").value = "";
      submitForm(paymentForm);
    });
}
