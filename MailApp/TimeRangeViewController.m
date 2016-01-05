//
//  TimeRangeViewController.m
//  MailApp
//
//  Created by Katy Ho on 12/25/15.
//  Copyright © 2015 KatyHo. All rights reserved.
//

#import "TimeRangeViewController.h"
#import "Constants.h"
#import "ContactsViewController.h"

#define kSegueToContacts        @"showContactsController"

@interface TimeRangeViewController ()
{
    NSDate *selectedFromDate;
    NSDate *selectedToDate;
}

@end

@implementation TimeRangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    self.title = @"Select Time Range"; 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)getTimeRange:(id)sender {
    selectedFromDate = [_fromDate date];
    selectedToDate = [_toDate date];
    [self performSegueWithIdentifier:kSegueToContacts sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:kSegueToContacts]) {
        ContactsViewController *vc = segue.destinationViewController;
        vc.selectedFromDate = selectedFromDate;
        vc.selectedToDate = selectedToDate; 
        
    }
}


@end
