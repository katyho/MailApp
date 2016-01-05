//
//  ContactsViewController.m
//  MailApp
//
//  Created by Katy Ho on 12/24/15.
//  Copyright © 2015 KatyHo. All rights reserved.
//

#import "ContactsViewController.h"
#import "CIOExtensions.h"
#import "SVProgressHUD.h"
#import "Constants.h"
#import "Contacts.h"

#import "ContactsTableViewCell.h"
#import "MessageViewController.h"

#define kCellReuseId                @"ContactsCell"
#define kContactSortBy              @"received_count"
#define kContactLimit               10
#define kSectionNumber              1
#define kSegueToMessage             @"showMessageController"

@interface ContactsViewController ()
{
    Contacts *selectedContact;   // save the contact the user selects
    int number;                  // for numbering the contacts from 1-10
}

@property(nonatomic, strong)NSArray *contacts;

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.title = @"Top 10 Contacts";
    if (!_contacts) {
        number = 0;
        [self fetchContacts];
    }
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
    return self.contacts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactsTableViewCell *cell = (ContactsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellReuseId forIndexPath:indexPath];
    if (cell) {
        
        Contacts *contact = [self.contacts objectAtIndex:indexPath.row];
        NSLog(@"contact %@", contact);
                
        number++;
        cell.nameLabel.text = [NSString isNullOrEmpty:contact.name] ? @"N/A" : contact.name;
        cell.emailLabel.text = [NSString isNullOrEmpty:contact.email] ? @"N/A" : contact.email;
        cell.statisticsLabel.text = [NSString stringWithFormat:@"%.02f", contact.statistic];
        cell.number.text = [NSString stringWithFormat:@"%i", number];
        [cell.contentView.layer setBorderColor:[UIColor blackColor].CGColor];
        [cell.contentView.layer setBorderWidth:1.0f];
        
    }
    
    
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 71.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedContact = self.contacts[indexPath.row];
    if (selectedContact)
        [self performSegueWithIdentifier:kSegueToMessage sender:self];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:kSegueToMessage]) {
        MessageViewController *vc = segue.destinationViewController;
        vc.selectedContact = selectedContact;

    }
}


- (void)fetchContacts {
    [SVProgressHUD show];
    CIOContactsRequest *contactRequest = [[CIOV2Client sharedInstance] getContacts];
    // contactRequest parameters
    contactRequest.sort_by = kContactSortBy;
    contactRequest.limit = kContactLimit;
    contactRequest.active_after = self.selectedFromDate;
    contactRequest.active_before = self.selectedToDate;
    
    [contactRequest executeWithSuccess:^(NSDictionary * _Nonnull responseDict) {
        [SVProgressHUD dismiss];
        self.contacts = [Contacts contactsArrayForResponse:responseDict];
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error %@", error);
        [SVProgressHUD dismiss];
    }];

}

@end
