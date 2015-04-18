//
//  TodayViewController.m
//  PNJUWidget
//
//  Created by Cee on 17/04/2015.
//  Copyright (c) 2015 Cee. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

#import "NetworkManager.h"

@interface TodayViewController () <NCWidgetProviding>
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (weak) IBOutlet NSTextField *remainingTextField;
@property (weak) IBOutlet NSButton *controlBtn;
@property (nonatomic) BOOL isLoggedIn;
@end

@implementation TodayViewController

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult result))completionHandler {
    // Update your data and prepare for a snapshot. Call completion handler when you are done
    // with NoData if nothing has changed or NewData if there is new data since the last
    // time we called
    [self checkStatus];
    completionHandler(NCUpdateResultNewData);
}

- (id)init
{
    if (self = [super init]) {
        self.username = @"";    // Your username here
        self.password = @"";    // Your password here
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self checkStatus];
}

#pragma mark - IBActions
- (IBAction)btnPressed:(id)sender {
    if (self.isLoggedIn) {
        [[NetworkManager sharedNetworkManager] logout];
        [self.controlBtn setTitle:@"Login"];
        [self.remainingTextField setStringValue:@"未登录"];
    } else {
        [[NetworkManager sharedNetworkManager] loginWithUsername:self.username
                                            password:self.password];
        id json = [[NetworkManager sharedNetworkManager] userInfo];
        [self.remainingTextField setStringValue:[NSString stringWithFormat:@"用户名：%@ \n帐号余额：%@ 元\n登录地点：%@",
                                                 [json objectForKey:@"username"],
                                                 [json objectForKey:@"payamount"],
                                                 [json objectForKey:@"area_name"]]];
        [self.controlBtn setTitle:@"Logout"];
    }
    self.isLoggedIn = !self.isLoggedIn;
}

#pragma mark - Private Method
- (void)checkStatus
{
    if ([[NetworkManager sharedNetworkManager] checkOnline]) {
        id json = [[NetworkManager sharedNetworkManager] userInfo];
        [self.remainingTextField setStringValue:[NSString stringWithFormat:@"用户名：%@ \n帐号余额：%@ 元\n登录地点：%@",
                                                 [json objectForKey:@"username"],
                                                 [json objectForKey:@"payamount"],
                                                 [json objectForKey:@"area_name"]]];
        [self.controlBtn setTitle:@"Logout"];
        self.isLoggedIn = YES;
    } else {
        [self.controlBtn setTitle:@"Login"];
        [self.remainingTextField setStringValue:@"未登录"];
        self.isLoggedIn = NO;
    }
}

@end

