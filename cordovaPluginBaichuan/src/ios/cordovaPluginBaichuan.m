/********* cordovaPluginBaichuan.m Cordova Plugin Implementation *******/

#import <Cordova/CDVInvokedUrlCommand.h>
#import "cordovaPluginBaichuan.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <AlibabaAuthSDK/ALBBSDK.h>
#import <Toast/UIView+Toast.h>

@implementation cordovaPluginBaichuan

#pragma mark "API"
-(void)pluginInitialize {

    [[AlibcTradeSDK sharedInstance] setDebugLogOpen:YES];

    [[AlibcTradeSDK sharedInstance] setIsvVersion:@"2.2.2"];
    //    [[AlibcTradeSDK sharedInstance] setIsvAppName:@"cordova-plugin-baichuan"];

    NSString *type = [[self.commandDelegate settings] objectForKey:@"channel_type"];
    NSString *name = [[self.commandDelegate settings] objectForKey:@"channel_name"];

    if([type isEqualToString:@"0"] || type == nil){
        [[AlibcTradeSDK sharedInstance] setChannel:@"0" name:nil];
    }else{
        [[AlibcTradeSDK sharedInstance] setChannel:type name:name];
    }
    [[AlibcTradeSDK sharedInstance] asyncInitWithSuccess:^{
        [self setIsInitial:YES];
        NSLog(@"Init success.");
    }failure:^(NSError *error) {
        [self setIsInitial:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.viewController.view makeToast:[[NSString alloc] initWithFormat:@"阿里百川初始化失败%ld",error.code]
                                       duration:2.0
                                       position:CSToastPositionCenter];
        });
        NSLog(@"Init failed: 阿里百川初始化失败%@", error);
    }];

}

- (void)Login:(CDVInvokedUrlCommand *)command{

    if([self isLogin]){
        [self Session:command];
    }else{
        [[ALBBSDK sharedInstance] setAuthOption:NormalAuth];
        [self.commandDelegate runInBackground:^{

            [[ALBBSDK sharedInstance] auth:[self viewController] successCallback:^(ALBBSession *session){
                [self onLoginSuccess:command session:session];
            } failureCallback:^(ALBBSession *session, NSError *error) {
                [self onLoginFailuer:command session:session error:error];
            }];

        }];
    }

}

-(void)onLoginSuccess:(CDVInvokedUrlCommand *) command session:(ALBBSession *) session{
    [self Session:command];
}

-(void)onLoginFailuer:(CDVInvokedUrlCommand *) command session:(ALBBSession *) session error:(NSError *)error {
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.description];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)Logout:(CDVInvokedUrlCommand *)command{
    if ([self isLogin]) {
        [[ ALBBSDK sharedInstance] logoutWithCallback:^{
            NSLog(@"ALBBSDK logoutWithCallback");
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
        }];
    }
}
- (void)Session:(CDVInvokedUrlCommand *)command{
    if([self isLogin]){
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        ALBBUser *user = [[ALBBSession sharedInstance] getUser];
        dict[@"nick"] = user.nick;
        dict[@"openId"] = user.openId;
        dict[@"niopenSidck"] = user.openSid;
        dict[@"topAccessToken"] = user.topAccessToken;
        dict[@"topAuthCode"] = user.topAuthCode;
        dict[@"avatarUrl"] = user.avatarUrl;

        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                             messageAsDictionary:dict]
                                    callbackId:command.callbackId];

    }else{
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
    }
}

- (void)IsLogin:(CDVInvokedUrlCommand *)command
{
    if([self isLogin]){
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
                                    callbackId:command.callbackId];
    }else{
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR]
                                    callbackId:command.callbackId];
    }
}

-(BOOL) isLogin{
    return [[ALBBSession sharedInstance] isLogin];
}

//- (void)coolMethod:(CDVInvokedUrlCommand*)command
//{
//    CDVPluginResult* pluginResult = nil;
//    NSString* echo = [command.arguments objectAtIndex:0];
//
//    if (echo != nil && [echo length] > 0) {
//        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
//    } else {
//        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
//    }
//
//    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//}

@end
