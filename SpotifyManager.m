//
//  SpotifyManager.m
//  Noto
//
//  Created by Laura Gouillon on 12/3/16.
//  Copyright © 2016 Laura Gouillon. All rights reserved.
//

#import "SpotifyManager.h"
#import <SpotifyMetadata/SPTUser.h>
#import <SpotifyMetadata/SPTImage.h>

@interface SpotifyManager()
@property (nonatomic, strong) NSMutableArray *json;
@property (nonatomic, strong) NSMutableArray *userArray;
@property (nonatomic, strong) NSMutableArray *playlist;

@property (nonatomic, strong) SPTUser *user;

@end

@implementation SpotifyManager

// Creating the model
+ (instancetype) sharedManager {
    static SpotifyManager* sm = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // code to be executed once - thread safe version
        sm = [[self alloc] init];
    });
    return sm;
}

-(void) parseUserJSON: (NSMutableArray*) json {
    // parse the json and save values to
    
    self.user = [SPTUser userFromDecodedJSON:json error:nil];
    NSLog(@"After loading SPTUser, user uri is %@", self.user.uri);
    
    self.userID = @"1219700505";
    self.userDisplayName = self.user.displayName; //@"Laura Gouillon";
    
    // Need to figure out how to download this photo or display from URL
    self.userProfileImageURL = self.user.largestImage.imageURL; //@"https://scontent.xx.fbcdn.net/v/t1.0-1/p200x200/14264138_1136604036389199_1827605634941946162_n.jpg?oh=1228a80501c572411e8427f39ac8b38c&oe=58AFB1C8";
    
    self.userURI = self.user.uri.absoluteString; //@"spotify:user:1219700505";
}

-(void) parsePlaylistJSON: (NSMutableDictionary*) json {
    self.savedTracks = [[NSMutableArray alloc] init];
    
    id items = json[@"items"];
    for (int i = 0; i < 5; i++) {
        id track = items[i][@"track"];
        NSString *artist = track[@"artists"][0][@"name"];
        NSString *trackname =  track[@"name"];
        NSString *trackuri =  track[@"uri"];
        NSLog(@"Next TRACK");
        NSLog(@"Artist: %@", artist);
        NSLog(@"Track Name: %@", trackname);
        NSLog(@"Track URI: %@\n", trackuri);
        
        NSMutableDictionary *trackDict = [[NSMutableDictionary alloc] init];
        trackDict[@"Artist"] = artist;
        trackDict[@"TrackName"] = trackname;
        trackDict[@"TrackURI"] = trackuri;
        [self.savedTracks addObject:trackDict];
    }
}

@end
