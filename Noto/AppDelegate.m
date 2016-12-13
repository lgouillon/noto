//
//  AppDelegate.m
//  Noto
//
//  Created by Laura Gouillon on 11/28/16.
//  Copyright © 2016 Laura Gouillon. All rights reserved.
//

#import "AppDelegate.h"
#import "SpotifyManager.h"

@interface AppDelegate ()
@property (nonatomic, strong) SPTAuth *auth;    // Use to set up the Client ID and Callback URL
@property (nonatomic, strong) SPTAudioStreamingController *player;
@property (nonatomic, strong) UIViewController *authViewController;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) SpotifyManager *spotifyManager;

@property (nonatomic, strong) NSMutableData* data;
@property (nonatomic, strong) NSMutableArray *json;
@property (nonatomic, strong) NSMutableArray *user;
@property (nonatomic, strong) NSMutableDictionary *savedTracks;
@property (nonatomic, strong) NSMutableArray *playlist;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NSThread sleepForTimeInterval:1]; //add 4 seconds longer.
    
    self.spotifyManager = [SpotifyManager sharedManager];

    self.auth = [SPTAuth defaultInstance];
    self.player = [SPTAudioStreamingController sharedInstance];
    
    // The client ID you got from the developer site
    self.auth.clientID = @"c21dedabd58d4e3980051665e035a02e";
    
    // The redirect URL as you entered it at the developer site
    self.auth.redirectURL = [NSURL URLWithString:@"noto-login://callback"];
    
    // Setting the `sessionUserDefaultsKey` enables SPTAuth to automatically store the session object for future use.
    self.auth.sessionUserDefaultsKey = @"current session";
    
    // Set the scopes you need the user to authorize. `SPTAuthStreamingScope` is required for playing audio.
    self.auth.requestedScopes = @[SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthUserLibraryReadScope, SPTAuthPlaylistModifyPublicScope];
    
    // Become the streaming controller delegate
    self.player.delegate = self;
    
    // Start up the streaming controller.
    NSError *audioStreamingInitError;
    NSAssert([self.player startWithClientId:self.auth.clientID error:&audioStreamingInitError],
             @"There was a problem starting the Spotify SDK: %@", audioStreamingInitError.description);
    
    return YES;
}

// Called to start logging in process to Spotify
- (void)startAuthenticationFlow: (LoginViewController*) lvc
{
    // Check if we could use the access token we already have
    if ([self.auth.session isValid]) {
        // Use it to log in
        [self.player loginWithAccessToken:self.auth.session.accessToken];
    } else {
        // Get the URL to the Spotify authorization portal
        NSURL *authURL = [self.auth spotifyWebAuthenticationURL];
        // Present in a SafariViewController
        self.authViewController = [[SFSafariViewController alloc] initWithURL:authURL];
        [self.window.rootViewController presentViewController:self.authViewController animated:YES completion:nil];
    }
    [lvc ShowFeedView];
}

// Handle auth callback
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options
{
    // If the incoming url is what we expect we handle it
    if ([self.auth canHandleURL:url]) {
        // Close the authentication window
        [self.authViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        self.authViewController = nil;
        // Parse the incoming url to a session object
        [self.auth handleAuthCallbackWithTriggeredAuthURL:url callback:^(NSError *error, SPTSession *session) {
            if (session) {
                // login to the player
                [self.player loginWithAccessToken:self.auth.session.accessToken];
            }
        }];
        return YES;
    }
    return NO;
}

- (void)audioStreamingDidLogin:(SPTAudioStreamingController *)audioStreaming {
    
    // Requesting User
    NSURLRequest *requestUser = [SPTUser createRequestForCurrentUserWithAccessToken:self.auth.session.accessToken error:nil];
    [NSURLConnection sendAsynchronousRequest:requestUser queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        self.user = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (!self.user) {
            NSLog(@"Error parsing user");
        } else {
            //NSLog(@"Async JSON USER: %@", self.user); UNCOMMENT to see user JSON received
            [self.spotifyManager parseUserJSON:self.user];
        }
    }];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userDidLogin" object:self userInfo:nil];
    
    // Getting user's saved tracks
    NSURLRequest *requestSavedTracks = [SPTYourMusic createRequestForCurrentUsersSavedTracksWithAccessToken:self.auth.session.accessToken error:nil];
    [NSURLConnection sendAsynchronousRequest:requestSavedTracks queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        self.savedTracks = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (!self.savedTracks) {
            NSLog(@"Error parsing saved Tracks");
        } else {
            [self.spotifyManager parsePlaylistJSON:self.savedTracks];
            //NSLog(@"Async JSON SAVED TRACKS: %@", self.savedTracks); UNCOMMENT to see user's saved tracks
        }
    }];
    
    
    // Getting the first two pages of a playlists for a user
    /*NSURLRequest *playlistrequest = [SPTPlaylistList createRequestForGettingPlaylistsForUser:@"possan" withAccessToken:self.auth.session.accessToken error:nil];
    [[SPTRequest sharedHandler] performRequest:playlistrequest callback:^(NSError *error, NSURLResponse *response, NSData *data) {
        if (error != nil) { NSLog(@"Error getting playlist: %@", error); }
        SPTPlaylistList *playlists = [SPTPlaylistList playlistListFromData:data withResponse:response error:nil];
        NSLog(@"Got laura's playlists, first page: %@", playlists);
        NSURLRequest *playlistrequest2 = [playlists createRequestForNextPageWithAccessToken:self.auth.session.accessToken error:nil];
        [[SPTRequest sharedHandler] performRequest:playlistrequest2 callback:^(NSError *error2, NSURLResponse *response2, NSData *data2) {
            if (error2 != nil) { NSLog(@"Error getting playlist: %@", error); }
            SPTPlaylistList *playlists2 = [SPTPlaylistList playlistListFromData:data2 withResponse:response2 error:nil];
            NSLog(@"Got laura's playlists, second page: %@", playlists2);
        }];
    }];*/
    
    
    // Create Playlist
    /*NSURLRequest *requestPlaylist = [SPTPlaylistList createRequestForCreatingPlaylistWithName:@"LALALA"
     forUser:@"1219700505"
     withPublicFlag:YES
     accessToken:self.auth.session.accessToken
     error:nil];
    
    [NSURLConnection sendAsynchronousRequest:requestPlaylist queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        self.playlist = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (!self.playlist) {
            NSLog(@"Error parsing playlist");
        } else {
            //NSLog(@"Async JSON PLAYLIST: %@", self.playlist); //UNCOMMENT to see playlist created
        }
    }];*/
    
    
    // Browsing new releases in country
    /*NSURLRequest *request = [SPTBrowse createRequestForNewReleasesInCountry:@"US" limit:10 offset:0 accessToken:self.auth.session.accessToken error:nil];
    
    //__block NSDictionary *json;
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               self.json = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:nil];
                               if (!self.json) {
                                   NSLog(@"Error parsing JSON");
                               } else {
                                   //NSLog(@"Async JSON: %@", self.json); UNCOMMENT TO SEE RESULT OF HTTP REQUEST
                               }
                               
                               //NSLog(@"%@",[[JSONarray objectAtIndex:i]objectForKey:@"id"]);
                               //NSLog(@"%@",[[JSONarray objectAtIndex:i]objectForKey:@"name"]);
                               
                           }];*/
}

- (void)playSong:(NSString *) trackURI
{
    NSLog(@"Trying to play song: %@", trackURI);
    // "Innocence by SVDKO, spotify:track:4cf8d3h8m5LzIlDlDarDcA
    [self.player playSpotifyURI:trackURI startingWithIndex:0 startingWithPosition:0 callback:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Play song failed to play: %@", error);
            return;
        }
    }];
}

-(void)playPause:(id)sender {
    [self.player setIsPlaying:!self.player.playbackState.isPlaying callback:nil];
}

// This method is used to receive the data which we get using post method.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data {
    /*NSLog(@"Did receive data");
    [self.data appendData:data];*/
}

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
}

// This method is used to process the data after connection has made successfully.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    /*SPTListPage *sptData = [SPTListPage listPageFromData:self.data withResponse:nil expectingPartialChildren:NO rootObjectKey:nil error:nil];
    NSLog(@"Total list length: %i",sptData.totalListLength);
    NSArray *items = sptData.items;
    NSLog(@"Items: %i", items.count);*/
}


@end
