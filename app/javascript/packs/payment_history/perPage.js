const form = document.getElementById("payment-history-form");
const perPageButton = document.getElementById("per-page-dropdown");

perPageButton.addEventListener("change", (e) => {
  form.submit();
});
