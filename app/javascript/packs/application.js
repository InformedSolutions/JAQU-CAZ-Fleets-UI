import '../styles/application.scss';
import '../src/govukFrontendAssets';
import '../src/hmrcFrontendAssets';
import govukFrontend from 'govuk-frontend/govuk/all';
import hmrcFrontend from 'hmrc-frontend/hmrc/all';
import printLink from '../src/printLink/init';
import cookieControl from '../src/cookieControl';
import backLink from '../src/backLink';

require('@rails/ujs').start();

document.body.classList.add('js-enabled');
govukFrontend.initAll();
hmrcFrontend.initAll();
printLink();
cookieControl();
backLink();
