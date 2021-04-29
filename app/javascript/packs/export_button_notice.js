// Reveals download in progress message
const btn = document.getElementById("csv-export");
btn.addEventListener("click", () => {
  const message = document.getElementById("csv-export__notice");
  message.style.display = "block";
  btn.className = "govuk-button govuk-button--secondary govuk-button--disabled";
  setTimeout(() => {
    btn.className = "govuk-button govuk-button--secondary";
    message.style.display = "none";
  }, 5000);
});
