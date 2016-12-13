//
//  EntryDetailViewController.m
//  Noto
//
//  Created by Laura Gouillon on 12/3/16.
//  Copyright © 2016 Laura Gouillon. All rights reserved.
//

#import "EntryDetailViewController.h"
#import "EntriesManager.h"
#import "AppDelegate.h"

@interface EntryDetailViewController ()

@property (nonatomic, strong) EntriesManager *entriesManager;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *entryTitle;
@property (strong, nonatomic) IBOutlet UILabel *dateAndLocation;
@property (strong, nonatomic) IBOutlet UIImageView *mood;
@property (strong, nonatomic) IBOutlet UILabel *song;
@property (strong, nonatomic) IBOutlet UILabel *entry;
@property (strong, nonatomic) IBOutlet UIButton *playPauseButton;
@property (nonatomic) BOOL isPlaying;

@property (strong, nonatomic) AppDelegate *appDelegate;

@end

@implementation EntryDetailViewController

@synthesize index;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.entriesManager = [EntriesManager sharedManager];
    [self updateElements];
    
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.appDelegate playSong:[self.entriesManager entryAtIndex:index].trackURI];
    self.isPlaying = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateElements {
    Entry* entry = [self.entriesManager entryAtIndex:index];
    self.entryTitle.text = entry.title;
    self.dateAndLocation.text = [NSString stringWithFormat:@"%@ and %@", entry.date, entry.location];
    self.mood.image = [UIImage imageNamed:entry.mood];
    self.song.text = entry.songName;
    self.entry.text = entry.entry;
    if ([entry.image isEqual:@"nil"]) {
        self.image.image = [UIImage imageNamed:@"diary"];//[UIImage imageNamed:entry.image];
    } else {
        self.image.image = [UIImage imageWithContentsOfFile:entry.image];
    }
    self.image.clipsToBounds = true;
}

- (IBAction)BackButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.isPlaying == YES) {
         [self.appDelegate playPause:self];
    }
    NSLog(@"Going back");
}

- (IBAction)playPausePressed:(id)sender {
    [self.appDelegate playPause:self];
    if (self.isPlaying == YES) {
        self.isPlaying = NO;
        [self.playPauseButton setImage:[UIImage imageNamed:@"play-button-120x120"] forState:UIControlStateNormal];
    } else {
        self.isPlaying = YES;
        [self.playPauseButton setImage:[UIImage imageNamed:@"pause-button-120x120"] forState:UIControlStateNormal];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
