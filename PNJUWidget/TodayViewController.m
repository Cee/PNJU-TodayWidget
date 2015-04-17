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
@property (nonatomic, strong) NetworkManager *sharedNetworkManager;
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
    // time we called you
    completionHandler(NCUpdateResultNoData);
}

- (instancetype)init
{
    if (self = [super init]) {
        _sharedNetworkManager = [NetworkManager sharedNetworkManager];
        self.username = @"";    // Your username here
        self.password = @"";    // Your password here
        self.isLoggedIn = NO;
        [self.controlBtn setTitle:@"Login"];
        [self.remainingTextField setStringValue:@"未登录"];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)btnPressed:(id)sender {
    if (self.isLoggedIn) {
        [self.sharedNetworkManager logout];
        [self.controlBtn setTitle:@"Login"];
        [self.remainingTextField setStringValue:@"未登录"];
    } else {
        NSString *responseStr = [self.sharedNetworkManager loginWithUsername:self.username password:self.password];
        NSData *data = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        json = [json objectForKey:@"userinfo"];
        NSLog(@"%@", [json objectForKey:@"payamount"]);
        [self.remainingTextField setStringValue:[NSString stringWithFormat:@"用户名：%@ \n帐号余额：%@ 元\n登录地点：%@", [json objectForKey:@"username"], [json objectForKey:@"payamount"], [json objectForKey:@"area_name"]]];
        [self.controlBtn setTitle:@"Logout"];
    }
    self.isLoggedIn = !self.isLoggedIn;
}
@end

