//
//  ViewController.m
//  Noto
//
//  Created by Laura Gouillon on 11/28/16.
//  Copyright © 2016 Laura Gouillon. All rights reserved.
//

#import "FeedTableViewController.h"
#import "EntriesManager.h"
#import "AddEntryViewController.h"
#import "AppDelegate.h"
#import "EntryDetailViewController.h"
#import "ProfileViewController.h"


@interface FeedTableViewController ()

@property (nonatomic, strong) EntriesManager *entriesManager;
@property (strong, nonatomic) IBOutlet UITableView *feedTableView;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) ProfileViewController *profileViewController;

@end

@implementation FeedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.entriesManager = [EntriesManager sharedManager];
    self.profileViewController = [ProfileViewController sharedController];
    
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.tableView.editing) {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the entry from the manager
        [self.entriesManager removeEntryAtIndex:indexPath.row];
        
        // Perform the animation that deletes cell
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self.entriesManager saveToFile];
        NSLog(@"The entries array is now length %lu", (unsigned long)[self.entriesManager numberOfEntries]);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.entriesManager numberOfEntries];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"EntryCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Entry *entry = [self.entriesManager entryAtIndex:indexPath.row];
    
    cell.textLabel.text = entry.title;
    cell.detailTextLabel.text = entry.entry;
    cell.imageView.image = [UIImage imageNamed:entry.mood];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"ShowEntrySegue" sender:self];
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
    
    if ([[segue identifier] isEqualToString:@"ShowEntrySegue"])
    {
        // Send info about the index number of the cell chosen
        NSLog(@"preparing for show entry segue");
        
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            EntryDetailViewController *destViewController = segue.destinationViewController;
        destViewController.index = indexPath.row;
        
    } else {
        
        // Add a new entry
        AddEntryViewController *aevc = (AddEntryViewController *)segue.destinationViewController;
        
        aevc.completionHandler = ^(NSString *title, NSString* mood, NSString *entry, NSString *trackURI, NSString *songName, NSString *city, NSString *currentDate, UIImage *image){
            
            if (title != nil && mood != nil && entry != nil && trackURI != nil && songName != nil && city != nil && currentDate != nil && image != nil)
            {
                // Process the image into a url
                NSData *pngData = UIImagePNGRepresentation(image);
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
                NSString *appendPath = [NSString stringWithFormat:@"%@-%@-image.png", currentDate, title];
                NSLog(@"Append Path: %@", appendPath);
                NSString *filePath = [documentsPath stringByAppendingPathComponent:appendPath]; //Add the file name
                NSLog(@"File Path: %@", filePath);
                [pngData writeToFile:filePath atomically:YES]; //Write the file
                
                [self.entriesManager insertWithTitle:title
                                                mood:mood
                                               entry:entry
                                                trackURI:trackURI
                                            songName:songName
                                            location:city
                                                date:currentDate
                                               image:filePath];
                [self.feedTableView reloadData];
            }
            
            [self.entriesManager saveToFile];
            [self.profileViewController refreshView];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            NSLog(@"Im inside the feed table view controller, and I received the title (%@) and mood (%@) and entry (%@) in the city (%@)", title, mood, entry, city);
        };
        
        aevc.onCancelHandler = ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        
        NSLog(@"Prepare for segue to add entry view controller");
    }
}

@end
