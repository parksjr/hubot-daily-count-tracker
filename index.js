var fs = require('fs');
var path = require('path');

module.exports = function(robot, scripts) {
  var i, len, ref, results, script, scriptsPath;
  scriptsPath = path.resolve(__dirname, 'src');
  if (fs.existsSync(scriptsPath)) {
    ref = fs.readdirSync(scriptsPath).sort();
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      script = ref[i];
      if ((scripts != null) && indexOf.call(scripts, '*') < 0) {
        if (indexOf.call(scripts, script) >= 0) {
          results.push(robot.loadFile(scriptsPath, script));
        } else {
          results.push(void 0);
        }
      } else {
        results.push(robot.loadFile(scriptsPath, script));
      }
    }
    return results;
  }
};