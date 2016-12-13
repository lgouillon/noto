//
//  Entry.m
//  Noto
//
//  Created by Laura Gouillon on 11/30/16.
//  Copyright © 2016 Laura Gouillon. All rights reserved.
//

#import "Entry.h"

@implementation Entry

// Initializing the flashcard
- (instancetype) initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        _title = title;
        _entry = @"No entry submitted";
        _mood = @"romantic";
        _trackURI = @"spotify:track:4BOpAjQcA23B23hxHKORAZ";
        _songName = @"For You - WILD";
        _location = @"Mars";
        _date = @"XX-XX-XXXX";
        _image = @"nil";
    }
    return self;
}

- (instancetype) initWithTitle:(NSString *)title entry:(NSString *)entry
{
    self = [super init];
    if (self) {
        _title = title;
        _entry = entry;
        _mood = @"romantic";
        _trackURI = @"spotify:track:4BOpAjQcA23B23hxHKORAZ";
        _songName = @"For You - WILD";
        _location = @"Mars";
        _date = @"XX-XX-XXXX";
        _image = @"nil";
    }
    return self;
}

- (instancetype) initWithTitle: (NSString *) title
                          mood: (NSString *) mood
                         entry: (NSString *) entry
{
    self = [super init];
    if (self) {
        _title = title;
        _mood = mood;
        _entry = entry;
        _trackURI = @"spotify:track:4BOpAjQcA23B23hxHKORAZ";
        _songName = @"For You - WILD";
        _location = @"Mars";
        _date = @"XX-XX-XXXX";
        _image = @"nil";
    }
    return self;
}

- (instancetype) initWithTitle: (NSString *) title
                          mood: (NSString *) mood
                         entry: (NSString *) entry
                      location: (NSString *) city
{
    self = [super init];
    if (self) {
        _title = title;
        _mood = mood;
        _entry = entry;
        _trackURI = @"spotify:track:4BOpAjQcA23B23hxHKORAZ";
        _songName = @"For You - WILD";
        _location = city;
        _date = @"XX-XX-XXXX";
        _image = @"nil";
 
    }
    return self;
}

// Full init method with everything
- (instancetype) initWithTitle: (NSString *) title
                          mood: (NSString *) mood
                         entry: (NSString *) entry
                      trackURI: (NSString *) song
                      songName: (NSString *) name
                      location: (NSString *) city
                          date: (NSString *) date
                         image: (NSString *) imagePath
{
    self = [super init];
    if (self) {
        _title = title;
        _mood = mood;
        _entry = entry;
        _trackURI = song;
        _songName = name;
        _location = city;
        _date = date;
        _image = imagePath;
    }
    return self;
}

@end
