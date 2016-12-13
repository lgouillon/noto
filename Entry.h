//
//  Entry.h
//  Noto
//
//  Created by Laura Gouillon on 11/30/16.
//  Copyright © 2016 Laura Gouillon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Entry : NSObject

@property (readonly) NSString *title;
@property (readonly) NSString *mood;
@property (readonly) NSString *entry;
@property (readonly) NSString *trackURI; // Some song format for song chosen
@property (readonly) NSString *songName;
@property (readonly) NSString *location; // Figure out how to use Core Location to get timestamp and location
@property (readonly) NSString *date;
@property (readonly) NSString *image;

// Initializing the flashcard
- (instancetype) initWithTitle: (NSString *) title;
- (instancetype) initWithTitle: (NSString *) title
                       entry: (NSString *) entry;
- (instancetype) initWithTitle: (NSString *) title
                          mood: (NSString *) mood
                         entry: (NSString *) entry;
- (instancetype) initWithTitle: (NSString *) title
                          mood: (NSString *) mood
                         entry: (NSString *) entry
                      location: (NSString *) city;
- (instancetype) initWithTitle: (NSString *) title
                          mood: (NSString *) mood
                         entry: (NSString *) entry
                      trackURI: (NSString *) song
                      songName: (NSString *) name
                      location: (NSString *) city
                          date: (NSString *) date
                         image: (NSString *) image;
@end
