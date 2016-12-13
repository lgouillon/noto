//
//  LoginViewController.m
//  Noto
//
//  Created by Laura Gouillon on 11/29/16.
//  Copyright © 2016 Laura Gouillon. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "FeedTableViewController.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UIButton *SpotifyLoginButton;
@property (strong, nonatomic) AppDelegate *appDelegate;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"diary.png"]];
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //[self.appDelegate playLoginPageMusic];
    
    // Subscribe to message
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowFeedView) name:@"userDidLogin" object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)LoginWithSpotify:(id)sender {
    NSLog(@"Login with Spotify");
    [self.appDelegate startAuthenticationFlow: self];
}

-(void)ShowFeedView {
    NSLog(@"Show Feed View");
    [self performSegueWithIdentifier:@"ShowFeedSegue" sender:self];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}


@end
