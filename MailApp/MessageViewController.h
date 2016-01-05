//
//  MessageViewController.h
//  MailApp
//
//  Created by Katy Ho on 12/25/15.
//  Copyright © 2015 KatyHo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contacts.h"

@interface MessageViewController : UITableViewController
@property (nonatomic, strong) Contacts *selectedContact;

@end
