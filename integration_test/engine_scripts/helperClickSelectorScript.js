module.exports = function (chromy, scenario) {
  var slectorsClicks = scenario.clicksSelectors
  slectorsClicks.forEach(function(selectorClick){
    chromy
      //.sleep(msec)
      .wait(selectorClick)
      .click(selectorClick);
  });

  var postInteractionWait = scenario.postInteractionWait;

  if (postInteractionWait) {
    chromy.wait(postInteractionWait);
  }
};
