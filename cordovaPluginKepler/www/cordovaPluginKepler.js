const exec = require('cordova/exec')

function $Kepler() {
  /**
   * 登录
   * @param  success: ignore
   * @param  error:
   *     {
   *         code:int,
   *         message:string
   *     }
   * @constructor
   */
  this.Login = function (success, error) {
    exec(success, error, 'cordovaPluginKepler', 'keplerLogin', [])
  }

  /**
   * 登出
   * @param success: ignore

   * @param error: ignore
   * @constructor
   */
  this.Logout = function (success, error) {
    exec(success, error, 'cordovaPluginKepler', 'keplerLogout', [])
  }
  /**
   * 获取用户信息
   * @param success:

   * @param error
   * @constructor
   */
  this.Session = function (success, error) {
    exec(success, error, 'cordovaPluginKepler', 'keplerSession', [])
  }
}

const kepler = new $Kepler()
module.exports = kepler
//
// exports.coolMethod = function (arg0, success, error) {
//   exec(success, error, 'cordovaPluginKepler', 'coolMethod', [arg0]);
// };
