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
   * 获取用户状态
   * @param success: 已登录

   * @param error 未登录
   * @constructor
   */
  this.IsLogin = function (success, error) {
    exec(success, error, 'cordovaPluginKepler', 'keplerIsLogin', [])
  }
}

const kepler = new $Kepler()
module.exports = kepler
//
// exports.coolMethod = function (arg0, success, error) {
//   exec(success, error, 'cordovaPluginKepler', 'coolMethod', [arg0]);
// };
