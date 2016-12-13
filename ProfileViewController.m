//
//  ProfileViewController.m
//  Noto
//
//  Created by Laura Gouillon on 11/29/16.
//  Copyright © 2016 Laura Gouillon. All rights reserved.
//

#import "ProfileViewController.h"
#import "EntriesManager.h"
#import "SpotifyManager.h"

@interface ProfileViewController ()

@property (nonatomic, strong) EntriesManager *entriesManager;
@property (nonatomic, strong) SpotifyManager *spotifyManager;

@end

@implementation ProfileViewController

// Creating the model
+ (instancetype) sharedController {
    static ProfileViewController* pvc = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // code to be executed once - thread safe version
        pvc = [[self alloc] init];
    });
    return pvc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.entriesManager = [EntriesManager sharedManager];
    self.spotifyManager = [SpotifyManager sharedManager];
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:self.spotifyManager.userProfileImageURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            UIImage *img = [[UIImage alloc] initWithData:data];
            self.imageView.image = img;
        }else{
            NSLog(@"%@",connectionError);
        }
    }];
    self.nameLabel.text = [self.spotifyManager userDisplayName];
    self.entriesMadeLabel.text = [NSString stringWithFormat:@"Entries made: %ld", [self.entriesManager numberOfEntries]];
}

-(void)viewDidAppear {
    self.entriesMadeLabel.text = [NSString stringWithFormat:@"Entries made: %ld", [self.entriesManager numberOfEntries]];
}

- (void) refreshView {
    self.entriesMadeLabel.text = [NSString stringWithFormat:@"Entries made: %ld", [self.entriesManager numberOfEntries]];
    NSLog(@"Refresh view for %ld entries", [self.entriesManager numberOfEntries]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
