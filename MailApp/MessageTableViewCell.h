//
//  MessageTableViewCell.h
//  MailApp
//
//  Created by Katy Ho on 12/25/15.
//  Copyright © 2015 KatyHo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *subjectTextView;

@end
