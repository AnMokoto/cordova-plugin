const fs = require('fs')
const path = require('path')
const util = require('util')
const stat = util.promisify(fs.stat)

function copy2ios (from, to) {
  console.log("plist from ---> " + from + " to ---> " + to)
  fs.writeFileSync(to, fs.readFileSync(from));
}

module.exports = (ctx) => {

  if (!ctx.opts.cordova.platforms.includes('ios')) return
  console.log("------- ios_after_plugin_install start -------")

  var ConfigParser = null;
  try {
    ConfigParser = ctx.requireCordovaModule('cordova-common').ConfigParser;
  } catch(e) {
    // fallback
    ConfigParser = ctx.requireCordovaModule('cordova-lib/src/configparser/ConfigParser');
  }
  const config  = new ConfigParser(path.join(ctx.opts.projectRoot, "config.xml"))
  const projectName = config.name()

  if (!projectName) {
    console.error("projectName name could not be found!");
    return ;
  }
  // copy file
  const plist = path.join(ctx.opts.plugin.dir, 'src/ios/mtopsdk_configuration.plist')
  // Target path
  const parentPath = path.join(ctx.opts.projectRoot, 'platforms/ios')
  console.log(projectName)
  const target = path.resolve(parentPath, projectName, 'Classes/mtopsdk_configuration.plist')
  copy2ios(plist, target)
}
