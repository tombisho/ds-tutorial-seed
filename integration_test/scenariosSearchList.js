function filterSelectorClick(label){
  return 'div.list-table > div.tab-content > div:nth-of-type(1) > div.btn > label:nth-of-type( ' + label + ')';
}

function resultTableSelectorClick(li){
  return 'ul[test-ref=search-counts] > li:nth-child(' + li + ') > a';
}

var delayClick = 4000;
var delayLoadPage = 600;
var scenarios = [];

scenarios = [
  {
    "label": "Search page list variable",
    "path": "/mica/repository#/search",
    "removeSelectors": [".navbar-fixed-top", "#fullSearch"],
    "delay": delayLoadPage
  },
  {
    "label": "Search page list datasets",
    "path": "/mica/repository#/search",
    "clickSelector": resultTableSelectorClick(2),
    "removeSelectors": [".navbar-fixed-top", "#fullSearch"],
    "delay": delayClick
  },
  {
    "label": "Search page list studies",
    "path": "/mica/repository#/search",
    "clickSelector": resultTableSelectorClick(3),
    "removeSelectors": [".navbar-fixed-top", "#fullSearch"],
    "delay": delayClick
  },
  {
    "label": "Search page list networks",
    "path": "/mica/repository#/search",
    "clickSelector": resultTableSelectorClick(4),
    "removeSelectors": [".navbar-fixed-top", "#fullSearch"],
    "delay": delayClick
  },
  {
    "label": "Search page list return to variable",
    "path": "/mica/repository#/search",
    "clicksSelectors": [resultTableSelectorClick(4), resultTableSelectorClick(1)],
    "removeSelectors": [".navbar-fixed-top", "#fullSearch"]
  },
  {
    "label": "Search page list variables Filter individual",
    "path": "/mica/repository#/search",
    "clickSelector": filterSelectorClick(2),
    "removeSelectors": [".navbar-fixed-top", "#fullSearch"],
    "delay": delayLoadPage
  },
  {
    "label": "Search page list variables Filter Harmonization",
    "path": "/mica/repository#/search",
    "clickSelector": filterSelectorClick(3),
    "removeSelectors": [".navbar-fixed-top", "#fullSearch"],
    "delay": delayLoadPage
  },
  {
    "label": "Search page list variables Filter Harmonization then filter all",
    "path": "/mica/repository#/search",
    "clicksSelectors": [filterSelectorClick(3), filterSelectorClick(1)],
    "removeSelectors": [".navbar-fixed-top", "#fullSearch"]
  }
];

module.exports = scenarios;