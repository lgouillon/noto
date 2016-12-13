//
//  AddEntryViewController.h
//  Noto
//
//  Created by Laura Gouillon on 12/1/16.
//  Copyright © 2016 Laura Gouillon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


typedef void(^CompletionHandler)(NSString *title, NSString *mood, NSString *entry, NSString *trackURI, NSString *songName, NSString *city, NSString *currentDate, UIImage *image);
typedef void(^OnCancel)();

@interface AddEntryViewController : UIViewController

@property (copy, nonatomic) CompletionHandler completionHandler;
@property (copy, nonatomic) OnCancel onCancelHandler;

@end
