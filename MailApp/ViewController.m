//
//  ViewController.m
//  MailApp
//
//  Created by Katy Ho on 12/24/15.
//  Copyright © 2015 KatyHo. All rights reserved.
//

#import "ViewController.h"
#import "CIOExtensions.h"
#import "Constants.h"
#import "SVProgressHUD.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [SVProgressHUD show];
    [[[CIOV2Client sharedInstance] getContacts] executeWithSuccess:^(NSDictionary * _Nonnull responseDict) {
        [SVProgressHUD dismiss];
        NSLog(@"resonse object %@", responseDict);
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"error %@", error);
    }];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
