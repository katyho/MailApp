//
//  MessageViewController.m
//  MailApp
//
//  Created by Katy Ho on 12/25/15.
//  Copyright © 2015 KatyHo. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"

#import "SVProgressHUD.h"
#import "Constants.h"
#import "CIOExtensions.h"
#import "Messages.h"

#define kSectionNumber      1
#define kMessageReuseId     @"MessageCell"

@interface MessageViewController ()

@property(nonatomic, strong)NSArray *messages;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"responseDict %@", self.selectedContact.email);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.title = @"Messages";
    [self fetchMessages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kSectionNumber;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableViewCell *cell = (MessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kMessageReuseId forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell) {
        Messages *message = [self.messages objectAtIndex:indexPath.row];
        
        cell.dateLabel.text = message.date;
        cell.subjectTextView.text = message.subject;
        [cell.contentView.layer setBorderColor:[UIColor blackColor].CGColor];
        [cell.contentView.layer setBorderWidth:0.1f];
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 71.0f;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)fetchMessages {
    [SVProgressHUD show];
    CIOMessagesRequest *messagesRequest = [[CIOV2Client sharedInstance] getMessages];
    
    // set messageRequest parameters
    messagesRequest.limit = 20;
    messagesRequest.email = self.selectedContact.email;
    
    [messagesRequest executeWithSuccess:^(NSArray * _Nonnull responseArray) {
        [SVProgressHUD dismiss];
        self.messages = [Messages messagesArrayForResponse:responseArray];
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"failed %@", error);
    }];
}

@end
