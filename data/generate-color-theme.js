var fs = require('fs');
var path = require('path');
var rootPath = path.join(__dirname, '../');

var themeColor = (function () {
    var colorSet = JSON.parse(fs.readFileSync(path.join(rootPath, './data/colors.json')));
    return colorSet[process.env.COLOR_THEME || 'blue'];
})();

var cssText = [
    '$base-color-light:' + themeColor[0] + ';',
    '$base-color-mid-light:' + themeColor[1] + ';',
    '$base-color-mid-dark:' + themeColor[2] + ';',
    '$base-color-dark: ' + themeColor[3] + ';'
].join('\n');

fs.writeFileSync(path.join(rootPath, './frontend/stylesheets/modules/_color.generated.scss'), cssText);
