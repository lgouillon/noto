//
//  AppDelegate.h
//  Noto
//
//  Created by Laura Gouillon on 11/28/16.
//  Copyright © 2016 Laura Gouillon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpotifyAuthentication/SpotifyAuthentication.h>
#import <SpotifyAudioPlayback/SpotifyAudioPlayback.h>
#import <SpotifyMetadata/SPTBrowse.h>
#import <SpotifyMetadata/SPTYourMusic.h>
#import <SpotifyMetadata/SPTUser.h>
#import <SpotifyMetadata/SPTPlaylistList.h>
#import <SafariServices/SafariServices.h>

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "LoginViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, SPTAudioStreamingDelegate>


@property (strong, nonatomic) UIWindow *window;

- (void)startAuthenticationFlow: (LoginViewController*) lvc;
- (void)playSong: (NSString*) trackURI;
- (void)playPause: (id) sender;

@end

