export default function backLink() {
  const link = document.getElementById('js-back-link');
  if (link) {
    link.style.display = 'inline-block';
    link.addEventListener('click', (event) => {
      event.preventDefault();
      window.history.back();
    }, false);
  }
}
