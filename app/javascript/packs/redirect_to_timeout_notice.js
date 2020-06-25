
const redirectToTimeoutNoticeData = document.getElementById("redirect_to_timeout_notice_data");
const timeoutTimeInMinutes = redirectToTimeoutNoticeData.getAttribute("timeout_time");
const logoutNoticePath = redirectToTimeoutNoticeData.getAttribute("logout_notice_path");
const redirectTimeInMinutes = timeoutTimeInMinutes - 1;
const timeOffset = 1000 * 60 * redirectTimeInMinutes;

setTimeout(function(path) {
  window.location.replace(path);
}, timeOffset, logoutNoticePath);
