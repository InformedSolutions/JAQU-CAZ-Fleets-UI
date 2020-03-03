import createHiddenInput from "./createHiddenInput";

export default function(form){
    const vrnSearch = document.getElementById("vrn-search");
    form.appendChild(createHiddenInput("payment[vrn_search]", vrnSearch.value));
    disableButtons();
    form.submit();
}

function disableButtons() {
    document.querySelectorAll("input[type=submit]").forEach(button => {
        button.disabled = true;
    });
    document.querySelectorAll("li.moj-pagination__item").forEach(li => {
        li.classList.add("isDisabled");
    })
}
