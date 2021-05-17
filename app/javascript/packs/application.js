// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start();

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import "../styles/application.scss";
import "../src/govukFrontendAssets";
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
