/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#import "HTMICDVPlugin.h"
#import "HTMICDVPlugin+Private.h"
#import "HTMICDVPlugin+Resources.h"
#import "HTMICDVViewController.h"
#include <objc/message.h>

@implementation UIView (org_apache_cordova_UIView_Extension)

@dynamic scrollView;

- (UIScrollView*)scrollView
{
    SEL scrollViewSelector = NSSelectorFromString(@"scrollView");

    if ([self respondsToSelector:scrollViewSelector]) {
        return ((id (*)(id, SEL))objc_msgSend)(self, scrollViewSelector);
    }

    return nil;
}

@end

NSString* const HTMICDVPageDidLoadNotification = @"HTMICDVPageDidLoadNotification";
NSString* const HTMICDVPluginHandleOpenURLNotification = @"HTMICDVPluginHandleOpenURLNotification";
NSString* const HTMICDVPluginResetNotification = @"HTMICDVPluginResetNotification";
NSString* const HTMICDVLocalNotification = @"HTMICDVLocalNotification";
NSString* const HTMICDVRemoteNotification = @"HTMICDVRemoteNotification";
NSString* const HTMICDVRemoteNotificationError = @"HTMICDVRemoteNotificationError";
NSString* const HTMICDVViewWillAppearNotification = @"HTMICDVViewWillAppearNotification";
NSString* const HTMICDVViewDidAppearNotification = @"HTMICDVViewDidAppearNotification";
NSString* const HTMICDVViewWillDisappearNotification = @"HTMICDVViewWillDisappearNotification";
NSString* const HTMICDVViewDidDisappearNotification = @"HTMICDVViewDidDisappearNotification";
NSString* const HTMICDVViewWillLayoutSubviewsNotification = @"HTMICDVViewWillLayoutSubviewsNotification";
NSString* const HTMICDVViewDidLayoutSubviewsNotification = @"HTMICDVViewDidLayoutSubviewsNotification";
NSString* const HTMICDVViewWillTransitionToSizeNotification = @"HTMICDVViewWillTransitionToSizeNotification";

@interface HTMICDVPlugin ()

@property (readwrite, assign) BOOL hasPendingOperation;
@property (nonatomic, readwrite, weak) id <HTMICDVWebViewEngineProtocol> webViewEngine;

@end

@implementation HTMICDVPlugin
@synthesize webViewEngine, viewController, commandDelegate, hasPendingOperation;
@dynamic webView;

// Do not override these methods. Use pluginInitialize instead.
- (instancetype)initWithWebViewEngine:(id <HTMICDVWebViewEngineProtocol>)theWebViewEngine
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppTerminate) name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOpenURL:) name:HTMICDVPluginHandleOpenURLNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReset) name:HTMICDVPluginResetNotification object:theWebViewEngine.engineWebView];

        self.webViewEngine = theWebViewEngine;
    }
    return self;
}

- (void)pluginInitialize
{
    // You can listen to more app notifications, see:
    // http://developer.apple.com/library/ios/#DOCUMENTATION/UIKit/Reference/UIApplication_Class/Reference/Reference.html#//apple_ref/doc/uid/TP40006728-CH3-DontLinkElementID_4

    // NOTE: if you want to use these, make sure you uncomment the corresponding notification handler

    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPause) name:UIApplicationDidEnterBackgroundNotification object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onResume) name:UIApplicationWillEnterForegroundNotification object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOrientationWillChange) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOrientationDidChange) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];

    // Added in 2.3.0
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLocalNotification:) name:HTMICDVLocalNotification object:nil];

    // Added in 2.5.0
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageDidLoad:) name:HTMICDVPageDidLoadNotification object:self.webView];
    //Added in 4.3.0
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillAppear:) name:HTMICDVViewWillAppearNotification object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidAppear:) name:HTMICDVViewDidAppearNotification object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillDisappear:) name:HTMICDVViewWillDisappearNotification object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidDisappear:) name:HTMICDVViewDidDisappearNotification object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillLayoutSubviews:) name:HTMICDVViewWillLayoutSubviewsNotification object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidLayoutSubviews:) name:HTMICDVViewDidLayoutSubviewsNotification object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillTransitionToSize:) name:HTMICDVViewWillTransitionToSizeNotification object:nil];
}

- (void)dispose
{
    viewController = nil;
    commandDelegate = nil;
}

- (UIView*)webView
{
    if (self.webViewEngine != nil) {
        return self.webViewEngine.engineWebView;
    }

    return nil;
}

/*
// NOTE: for onPause and onResume, calls into JavaScript must not call or trigger any blocking UI, like alerts
- (void) onPause {}
- (void) onResume {}
- (void) onOrientationWillChange {}
- (void) onOrientationDidChange {}
*/

/* NOTE: calls into JavaScript must not call or trigger any blocking UI, like alerts */
- (void)handleOpenURL:(NSNotification*)notification
{
    // override to handle urls sent to your app
    // register your url schemes in your App-Info.plist

    NSURL* url = [notification object];

    if ([url isKindOfClass:[NSURL class]]) {
        /* Do your thing! */
    }
}

/* NOTE: calls into JavaScript must not call or trigger any blocking UI, like alerts */
- (void)onAppTerminate
{
    // override this if you need to do any cleanup on app exit
}

- (void)onMemoryWarning
{
    // override to remove caches, etc
}

- (void)onReset
{
    // Override to cancel any long-running requests when the WebView navigates or refreshes.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];   // this will remove all notification unless added using addObserverForName:object:queue:usingBlock:
}

- (id)appDelegate
{
    return [[UIApplication sharedApplication] delegate];
}

// default implementation does nothing, ideally, we are not registered for notification if we aren't going to do anything.
// - (void)didReceiveLocalNotification:(NSNotification *)notification
// {
//    // UILocalNotification* localNotification = [notification object]; // get the payload as a LocalNotification
// }

@end
