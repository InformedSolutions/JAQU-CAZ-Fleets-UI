import createHiddenInput from "./createHiddenInput";
import submitForm from "./submitForm";

export default function () {
  const searchButton = document.getElementById("search-form-submit");
  const searchInput = document.getElementById("vrn-search");
  const clearButton = document.getElementById("clear-search-link");
  const form = document.getElementById("payment-form");

  searchButton.addEventListener("click", (e) => submitForm(e, form));

  if (!isIE11) {
    searchInput.addEventListener(
      "keydown",
      (e) => e.code === "Enter" && submitForm(e, form)
    );
  } else {
    searchInput.addEventListener(
      "keydown",
      (e) => e.keyCode === 13 && submitForm(e, form)
    );
  }

  clearButton && initClearButton(clearButton, form);
}

function initClearButton(clearButton, form) {
  clearButton.addEventListener("click", (e) => {
    e.preventDefault();
    form.appendChild(createHiddenInput("payment[vrn_search]", ""));
    form.appendChild(createHiddenInput("commit", "Clear search"));
    document.getElementById("vrn-search").value = "";
    form.submit();
  });
}

const isIE11 = !!window.MSInputMethodContext && !!document.documentMode;
