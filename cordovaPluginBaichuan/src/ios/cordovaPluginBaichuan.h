//
//  cordovaPluginBaichuan.h
//  Baichuan
//
//  Created by Moo on 2019/10/19.
//

#import <Cordova/CDV.h>

@interface cordovaPluginBaichuan : CDVPlugin{
NSString *APPKEY;
}
// Member variables go here.
@property (atomic,assign) BOOL isInitial;
/** 登录 */
- (void)Login:(CDVInvokedUrlCommand*)command;
/** 注销 */
- (void)Logout:(CDVInvokedUrlCommand*)command;
/** 获取用户信息 */
- (void)Session:(CDVInvokedUrlCommand*)command;
/** 是否已登录 */
- (void) IsLogin:(CDVInvokedUrlCommand *) command;


@end
