//
//  ContactsTableViewCell.h
//  MailApp
//
//  Created by Katy Ho on 12/24/15.
//  Copyright © 2015 KatyHo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statisticsLabel;
@property (weak, nonatomic) IBOutlet UILabel *number;

@end
