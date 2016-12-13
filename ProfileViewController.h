//
//  ProfileViewController.h
//  Noto
//
//  Created by Laura Gouillon on 11/29/16.
//  Copyright © 2016 Laura Gouillon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *entriesMadeLabel;

+ (instancetype) sharedController;
- (void) refreshView;
@end
