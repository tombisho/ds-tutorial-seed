/* Quick guide to BackstopJS commands

  backstop reference --configPath=backstop.js --scenariosSet=scenarios --host=http://site.dev
  backstop test  --configPath=backstop.js --scenariosSet=scenarios --host=http://site.dev

*/

var args = require('minimist')(process.argv.slice(2)); // grabs the process arguments
var scenariosSet = require('./' + args.scenariosSet);
var scenarios = [
  {
    "label": "Home Page",
    "url": args.host + "/",
    "delay": 200,
    "selectorExpansion": true,
    "misMatchThreshold": 0.001,
    "requireSameDimensions": true
  }
];
if (scenariosSet) {
  scenariosSet.forEach(function (scenario) {
    var defaultSetting = {
      "label": scenario.label,
      "url": args.host + scenario.path,
      "delay": 600,
      "misMatchThreshold": 0.001,
      "requireSameDimensions": true
    };

    if (scenario.delay) {
      defaultSetting.delay = scenario.delay;
    }
    if (scenario.removeSelectors) {
      defaultSetting = Object.assign(defaultSetting, {"removeSelectors": scenario.removeSelectors});
    }
    if (scenario.clickSelector) {
      defaultSetting = Object.assign(defaultSetting, {"clickSelector": scenario.clickSelector});
    }
    if (scenario.clicksSelectors) {
      defaultSetting = Object.assign(defaultSetting, {
        "clicksSelectors": scenario.clicksSelectors,
        "onReadyScript": "helperClickSelectorScript.js"
      });
    }
    if (scenario.selectors) {
      defaultSetting = Object.assign(defaultSetting, {
        "selectors": scenario.selectors,
        "selectorExpansion": false
      });
      if (scenario.onReadyScript) {
        defaultSetting = Object.assign(defaultSetting, {
          "onReadyScript": scenario.onReadyScript
        });
    };
    }
    scenarios.push(defaultSetting);
  });
}

// BackstopJS configuration
module.exports =
  {
    "id": "SnapShot Obiba Mica Drupal Tests",
    "viewports": [
      {
        "label": "tablet",
        "width": 1400,
        "height": 100
      }
    ],
    "onBeforeScript": "chromy/onBefore.js",
    "onReadyScript": "chromy/onReady.js",
    "scenarios": scenarios,
    "paths": {
      "bitmaps_reference": "backstop_data/bitmaps_reference",
      "bitmaps_test": "backstop_data/bitmaps_test",
      "engine_scripts": "engine_scripts",
      "html_report": "backstop_data/html_report",
      "ci_report": "backstop_data/ci_report"
    },
    "report": ["browser"],
    "engine": "chrome",
    "asyncCaptureLimit": 5,
    "asyncCompareLimit": 50,
    "debug": false,
    "debugWindow": false
  };
