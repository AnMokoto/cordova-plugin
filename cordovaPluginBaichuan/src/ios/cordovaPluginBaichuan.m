/********* cordovaPluginBaichuan.m Cordova Plugin Implementation *******/

#import <Cordova/CDVInvokedUrlCommand.h>
#import "cordovaPluginBaichuan.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <AlibabaAuthSDK/ALBBSDK.h>

@implementation cordovaPluginBaichuan

-(void)pluginInitialize {
    [[AlibcTradeSDK sharedInstance] setDebugLogOpen:NO];
    NSString *type = [[self.commandDelegate settings] objectForKey:@"CHANNEL_TYPE"];
    NSString *name = [[self.commandDelegate settings] objectForKey:@"CHANNEL_NAME"];
    if(type!=nil && name !=nil){
        [[AlibcTradeSDK sharedInstance] setChannel:type name:name];
    }
    [[AlibcTradeSDK sharedInstance] asyncInitWithSuccess:^{
        NSLog(@"Init success.");
    }failure:^(NSError *error) {
        NSLog(@"Init failed: %@", error.description);
    }];
}

- (void)Login:(CDVInvokedUrlCommand *)command{

    if([[ALBBSession sharedInstance] isLogin]){
        [self Session:command];
    }else{
        [[ALBBSDK sharedInstance] setAuthOption:NormalAuth];
        [[ALBBSDK sharedInstance] auth:[self viewController] successCallback:^(ALBBSession *session){
            [self onLoginSuccess:command session:session];
        } failureCallback:^(ALBBSession *session, NSError *error) {
            [self onLoginFailuer:command session:session error:error];
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
    if ([[ALBBSession sharedInstance] isLogin]) {
        [[ ALBBSDK sharedInstance] logout];
    }
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}
- (void)Session:(CDVInvokedUrlCommand *)command{
    ALBBSession *session = [ALBBSession sharedInstance];
    if([session isLogin]){
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[[session getUser] ALBBUserDescription] ]
                                    callbackId:command.callbackId];

    }else{
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
    }
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
