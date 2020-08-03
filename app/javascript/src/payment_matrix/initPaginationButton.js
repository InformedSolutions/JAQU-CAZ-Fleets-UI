import createHiddenInput from "./createHiddenInput";
import submitForm from "./submitForm";

export default function (direction) {
    const paymentForm = document.getElementById('payment-form');
    const paginationButton = document.getElementById(`pagination-${direction}-link`);

    if(paginationButton){
        paginationButton.addEventListener("click", (event) => {
            event.preventDefault();
            paymentForm.appendChild(createHiddenInput("commit", capitalize(direction)));
            submitForm(paymentForm);
        });
    }
}

function capitalize(string) {
    return string[0].toUpperCase() + string.slice(1);
}
