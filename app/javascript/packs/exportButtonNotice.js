// Reveals download in progress message
const btn = document.getElementById('csv-export');
btn.addEventListener('click', () => {
  const message = document.getElementById('csv-export__notice');
  message.className = 'not-hidden';
  btn.className = 'govuk-button govuk-button--secondary govuk-button--disabled';
  setTimeout(() => {
    btn.className = 'govuk-button govuk-button--secondary';
    message.className = 'hidden';
  }, 5000);
});
