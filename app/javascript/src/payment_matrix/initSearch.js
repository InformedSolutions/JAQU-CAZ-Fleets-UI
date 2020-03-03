import createHiddenInput from "./createHiddenInput";
import submitForm from "./submitForm";

export default function () {
    const searchForm = document.getElementById("search-form");
    const paymentForm = document.getElementById("payment-form");

    searchForm.addEventListener("submit", (event) => {
        event.preventDefault();
        paymentForm.appendChild(createHiddenInput("commit", "Search"));
        submitForm(paymentForm);
    });
}
