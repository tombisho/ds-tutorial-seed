module.exports = function(casper, scenario, vp) {
  console.log('Casper    ---SCENARIO> ' + scenario.label);
  require('./clickAndHoverHelper')(casper, scenario);
  // add more helpers here...
};
