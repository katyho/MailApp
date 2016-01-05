//
//  ContactsViewController.h
//  MailApp
//
//  Created by Katy Ho on 12/24/15.
//  Copyright © 2015 KatyHo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ContactsViewController : UITableViewController

@property(nonatomic, strong)NSDate *selectedFromDate;
@property(nonatomic, strong)NSDate *selectedToDate;

@end
