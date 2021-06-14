require("@rails/ujs").start();
import "../styles/application.scss";
import "../src/govukFrontendAssets";
import "../src/hmrcFrontendAssets";
import govukFrontend from "govuk-frontend/govuk/all";
import hmrcFrontend from "hmrc-frontend/hmrc/all";
import initPrintLink from "../src/printLink/init";
import cookieControl from "../src/cookieControl";
import initBackLink from "../src/backLink/init";

document.body.classList.add("js-enabled");
govukFrontend.initAll();
hmrcFrontend.initAll();
initPrintLink();
cookieControl();
initBackLink();
