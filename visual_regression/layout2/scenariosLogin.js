
var pagePath = "/user/login";

var scenarios = [
  {
    "label": "User Login",
    "path": pagePath,
    "delay": 'searchLoad',
    "credential": {
      "login": "user1",
      "password": "password"
    }
  }
];

module.exports = scenarios;
