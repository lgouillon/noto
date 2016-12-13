//
//  EntriesManager.h
//  Noto
//
//  Created by Laura Gouillon on 11/29/16.
//  Copyright © 2016 Laura Gouillon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entry.h"

@interface EntriesManager : NSObject

// Current index of the entry that is being displayed
@property (readonly) unsigned int currentIndex;

// Creating the manager
+ (instancetype) sharedManager;

// Accessing number of entries in manager
- (NSUInteger) numberOfEntries;

// Accessing an entry – sets currentIndex appropriately
//- (Entry *) randomEntry;
- (Entry *) entryAtIndex: (NSUInteger) index;

// Inserting an entry

- (void) insertWithTitle: (NSString *) title
                   entry: (NSString *) entry;
- (void) insertWithTitle: (NSString *) title
                   entry: (NSString *) entry
                 atIndex: (NSUInteger) index;
- (void) insertWithTitle: (NSString *) title
                    mood: (NSString *) mood
                   entry: (NSString *) entry;
- (void) insertWithTitle: (NSString *) title
                    mood: (NSString *) mood
                   entry: (NSString *) entry
                location: (NSString *) city;
- (void) insertWithTitle: (NSString *) title
                    mood: (NSString *) mood
                   entry: (NSString *) entry
                trackURI: (NSString *) song
                songName: (NSString *) name
                location: (NSString *) city
                    date: (NSString *) date
                   image: (NSString *) imagePath;

// Removing a flashcard
- (void) removeEntry;
- (void) removeEntryAtIndex: (NSUInteger) index;

- (void) saveToFile;

@end
