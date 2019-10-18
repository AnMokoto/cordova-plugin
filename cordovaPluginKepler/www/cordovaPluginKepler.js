const exec = require('cordova/exec')

function $Kepler () {
  /**
   * 登录
   * @param  success:
   *     {
   *         code:int,//0--登录初始化成功；1--登录初始化完成；2--登录成功
   *         openId:string,
   *         nickName:string
   *     }
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
   * @param success:
   *     {
   *         code:3,
   *         openId:string
   *     }
   * @param error:
   *     {
   *         code:int,
   *         message:string
   *     }

   * @constructor
   */
  this.Logout = function (success, error) {
    exec(success, error, 'cordovaPluginKepler', 'keplerLogout', [])
  }
  /**
   * 获取用户信息
   * @param success:
   *                - {string} userid userid
   *                - {string} nick nick
   *                - {string} avatarUrl avatarUrl
   *                - {string} openId openId
   *                - {string} openSid openSid
   *                - {string} topAccessToken topAccessToken
   *                - {string} topAuthCode topAuthCode
   *                - {string} topExpireTime topExpireTime
   *                - {string} ssoToken ssoToken
   *                - {string} havanaSsoToken havanaSsoToken
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
