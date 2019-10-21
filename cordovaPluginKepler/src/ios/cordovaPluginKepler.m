/********* cordovaPluginBaichuan.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import "JDKeplerSDK.framework/Headers/KeplerApiManager.h"

typedef void (^Callback)(void);

@interface cordovaPluginKepler : CDVPlugin {
    // Member variables go here.
}
- (void)pluginInitialize；
- (void)keplerLogin:(CDVInvokedUrlCommand*)command;
- (void)keplerLogout:(CDVInvokedUrlCommand*)command;
- (void)keplerIsLogin:(CDVInvokedUrlCommand*)command;
@end


@implementation cordovaPluginKepler

- (void)pluginInitialize{
    NSString *APPKEY = [[self.commandDelegate settings] objectForKey:@"APPKEY"];
    NSString *APPSECRET = [[self.commandDelegate settings] objectForKey:@"APPSECRET"];
    [[KeplerApiManager sharedKPService] asyncInitSdk:APPKEY
                                           secretKey:APPSECRET
                                      sucessCallback:^{
                                          NSLog(@"Kepler init success");
                                      }
                                      failedCallback:^(NSError *error) {
                                          NSLog(@"Kepler init failed --> %@",error);
                                      }];
}

- (void)keplerLogin:(CDVInvokedUrlCommand*)command
{

    [self IsLogin:^{
        // 已登录
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
    } failure:^{
        // 未登录
        [[KeplerApiManager sharedKPService]
         keplerLoginWithViewController:self.viewController
         success:^{
             // 登录成功
             [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
         } failure:^(NSError* error){
             // 登录失败
             [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.description] callbackId:command.callbackId];
         }];
    }];
    [self.commandDelegate sendPluginResult:nil callbackId:command.callbackId];
}

- (void)keplerLogout:(CDVInvokedUrlCommand*)command
{
    [[KeplerApiManager sharedKPService] cancelAuth ];
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

- (void)keplerIsLogin:(CDVInvokedUrlCommand*)command
{
    [self IsLogin:^{
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
    } failure:^{

        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
    }];
}

- (void)IsLogin:(Callback)call failure:(Callback)fail
{
    [[KeplerApiManager sharedKPService] keplerLoginWithSuccess:call failure:fail];
}

@end
