//
//  SpotifyManager.h
//  Noto
//
//  Created by Laura Gouillon on 12/3/16.
//  Copyright © 2016 Laura Gouillon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpotifyManager : NSObject

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *userDisplayName;
@property (nonatomic, strong) NSURL *userProfileImageURL;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *userURI;
@property (nonatomic, strong) NSMutableArray *savedTracks;


// Creating the manager
+ (instancetype) sharedManager;

-(void)parseUserJSON: (NSMutableArray*) json;
-(void)parsePlaylistJSON: (NSDictionary*) json;

@end
