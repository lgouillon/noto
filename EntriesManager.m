//
//  EntriesManager.m
//  Noto
//
//  Created by Laura Gouillon on 11/29/16.
//  Copyright © 2016 Laura Gouillon. All rights reserved.
//

#import "EntriesManager.h"
#import "Entry.h"

@interface EntriesManager()

// Located in .m to make it private
@property (strong, nonatomic) NSMutableArray *entries;
@property (strong, nonatomic) NSString *filepath;
@property (strong, nonatomic) NSString *fileName;

@end

@implementation EntriesManager

-(instancetype) init
{
    self = [super init];
    if (self) {
        _entries = [[NSMutableArray alloc] init];
        _currentIndex = 0;
        
        // Accessing the documents folder
        NSArray *matchedPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectoryPath = matchedPaths[0];
        
        _fileName = @"entries.plist";
        _filepath = [NSString stringWithFormat:@"%@/%@", documentsDirectoryPath, _fileName];
        
        NSLog(@"%@", documentsDirectoryPath);
        NSLog(@"%@", _filepath);
        
        NSArray *tempArray = [NSArray arrayWithContentsOfFile:_filepath];
        
        if (tempArray)
        {
            NSLog(@"Load array of dictionaries!");
            for (id tempDict in tempArray) {
                //NSLog(@"key = %@, value = %@", key, [tempDict objectForKey:key]);
                Entry* tempEntry = [[Entry alloc]
                                    initWithTitle:  [tempDict objectForKey:@"Title"]
                                    mood:           [tempDict objectForKey:@"Mood"]
                                    entry:          [tempDict objectForKey:@"Entry"]
                                    trackURI:       [tempDict objectForKey:@"TrackURI"]
                                    songName:       [tempDict objectForKey:@"Song"]
                                    location:       [tempDict objectForKey:@"Location"]
                                    date:           [tempDict objectForKey:@"Date"]
                                    image:          [tempDict objectForKey:@"Image"]];
                [_entries addObject:tempEntry];
            }
            [tempArray writeToFile:_filepath atomically:YES];
        }
        else // Nothing in our file or no file
        {
            // Create 5 flashcards
            Entry* entry1 = [[Entry alloc] initWithTitle:@"Today was a great day" mood:@"happy" entry:@"I ate healthy raspberries and talked to old friends. I will not forget today. I stayed in and watched a new show called Terrace House on Netflix. I am addicted. Japanese reality show (sort of), addicting!"];
            Entry* entry2 = [[Entry alloc] initWithTitle:@"My cat died" mood:@"sad" entry:@"I haven't seen my cat in so long, and today I heard from my family that it died. I am so sad..." ];
            Entry* entry3 = [[Entry alloc] initWithTitle:@"Finals have got the worst of me" mood:@"nervous" entry:@"Why is it that stressful situations make people like me overeat? I tried to buy healthy food so that I could snack on non-carbs, but I still find ways to eat junk food....I should work out more."];
            Entry* entry4 = [[Entry alloc] initWithTitle:@"It's almost winter break!" mood:@"excited" entry:@"I haven't seen my family in France for over a year! I can't wait to go back for a few weeks and to visit the south of France more. It'll be so cold, I'll need to bring all the sweaters I own!"];
            Entry* entry5 = [[Entry alloc] initWithTitle:@"Interviews are hard" mood:@"crying" entry:@"I resent technical interviews, they make me question my competence. But I'm glad that I at least enjoy PM interviews, those are my jam. They require you to be creative yet also technical, and that I can handle."];
            
            // Add the flashcards to our NSMutableArray
            [_entries addObject:entry1];
            [_entries addObject:entry2];
            [_entries addObject:entry3];
            [_entries addObject:entry4];
            [_entries addObject:entry5];
        }
        
        // Serializing the NSArray -> plist, writing it to the filepath
        [self saveToFile];
    }
    return self;
}

// Creating the model
+ (instancetype) sharedManager {
    static EntriesManager* em = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // code to be executed once - thread safe version
        em = [[self alloc] init];
    });
    return em;
}

// Accessing number of flashcards in model
- (NSUInteger) numberOfEntries {
    return [_entries count];
}

- (Entry *) entryAtIndex: (NSUInteger) index {
    _currentIndex = index;
    return [_entries objectAtIndex:_currentIndex];
}


// Inserting an Entry
- (void) insertWithTitle: (NSString *) title
                   entry: (NSString *) entry
{
    Entry* newEntry = [[Entry alloc] initWithTitle:title entry:entry];
    [_entries addObject:newEntry];
}

- (void) insertWithTitle: (NSString *) title
                   entry: (NSString *) entry
                 atIndex: (NSUInteger) index
{
    if (index <= [_entries count])
    {
        Entry* newEntry = [[Entry alloc] initWithTitle:title entry:entry];
        [_entries insertObject:newEntry atIndex:(index)];
    }
}

- (void) insertWithTitle: (NSString *) title
                    mood: (NSString *) mood
                   entry: (NSString *) entry
{
    Entry* newEntry = [[Entry alloc] initWithTitle:title mood:mood entry:entry];
    [_entries addObject:newEntry];
}

- (void) insertWithTitle: (NSString *) title
                    mood: (NSString *) mood
                   entry: (NSString *) entry
                location: (NSString *) city
{
    Entry* newEntry = [[Entry alloc] initWithTitle:title mood:mood entry:entry location:city];
    [_entries addObject:newEntry];
}

- (void) insertWithTitle: (NSString *) title
                    mood: (NSString *) mood
                   entry: (NSString *) entry
                trackURI: (NSString *) song
                songName: (NSString *) name
                location: (NSString *) city
                    date: (NSString *) date
                   image: (NSString *) imagePath
{
    Entry* newEntry = [[Entry alloc] initWithTitle:title mood:mood entry:entry trackURI:song songName:name location:city date:date image:imagePath];
    [_entries addObject:newEntry];
}

// Removing an entry
- (void) removeEntry {
    [_entries removeLastObject];
}

- (void) removeEntryAtIndex: (NSUInteger) index {
    if (index < [_entries count]) {
        [_entries removeObjectAtIndex:index];
    }
}

- (void) saveToFile {
    NSMutableArray *entriesArray = [[NSMutableArray alloc] init];
    //NSMutableDictionary *entriesDictionary = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < [_entries count]; i++) {
        Entry* entry = [_entries objectAtIndex:i];
        NSMutableDictionary *entryDictionary = [[NSMutableDictionary alloc] init];
        [entryDictionary setObject:[NSString stringWithFormat:@"%d",i] forKey:@"Index"];
        [entryDictionary setObject:entry.title forKey:@"Title"];
        [entryDictionary setObject:entry.mood forKey:@"Mood"];
        [entryDictionary setObject:entry.entry forKey:@"Entry"];
        [entryDictionary setObject:entry.date forKey:@"Date"];
        [entryDictionary setObject:entry.location forKey:@"Location"];
        [entryDictionary setObject:entry.trackURI forKey:@"TrackURI"];
        [entryDictionary setObject:entry.songName forKey:@"Song"];
        [entryDictionary setObject:entry.image forKey:@"Image"];
        [entriesArray addObject:entryDictionary];
    }
    
    [entriesArray writeToFile:_filepath atomically:YES];
}


@end
