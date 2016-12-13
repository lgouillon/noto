//
//  AddEntryViewController.m
//  Noto
//
//  Created by Laura Gouillon on 12/1/16.
//  Copyright © 2016 Laura Gouillon. All rights reserved.
//

#import "AddEntryViewController.h"
#import "SpotifyManager.h"


@interface AddEntryViewController () <UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

// DATE AND LOCATION
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;

// TITLE
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

// IMAGE
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UIButton *pickImageButton;

// MOOD
@property (strong, nonatomic) IBOutlet UILabel *moodLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *moodPicker;

// SPOTIFY
@property (strong, nonatomic) IBOutlet UILabel *spotifyLabel;
@property (strong, nonatomic) IBOutlet UIImageView *spotifyImage;
@property (strong, nonatomic) IBOutlet UIPickerView *spotifyPicker;

// ENTRY
@property (strong, nonatomic) IBOutlet UILabel *entryLabel;
@property (weak, nonatomic) IBOutlet UITextView *entryTextView;


// Data
@property (strong, nonatomic) NSString *locationCity;
@property (strong, nonatomic) NSString *currentDate;
@property (strong, nonatomic) NSMutableArray *moods;
@property (strong, nonatomic) NSArray *moodImages;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *songs;

@property (nonatomic, strong) SpotifyManager *spotifyManager;

@end

@implementation AddEntryViewController

// MARK: - Life cycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.spotifyManager = [SpotifyManager sharedManager];
    
    // MOODS
    self.moods = [[NSMutableArray alloc] init];
    [self.moods addObject:@"angry"];
    [self.moods addObject:@"confused"];
    [self.moods addObject:@"crying"];
    [self.moods addObject:@"excited"];
    [self.moods addObject:@"happy"];
    [self.moods addObject:@"nervous"];
    [self.moods addObject:@"neutral"];
    [self.moods addObject:@"romantic"];
    [self.moods addObject:@"sad"];
    
    NSLog(@"Moods");
    for (int i = 0; i < [self.moods count]; i++)
    {
        NSLog(@"%@", [self.moods objectAtIndex:i]);
    }
    self.moodPicker.delegate = self;
    self.moodPicker.dataSource = self;

    self.moodImages = @[[UIImage imageNamed:@"angry"],
                        [UIImage imageNamed:@"confused"],
                        [UIImage imageNamed:@"crying"],
                        [UIImage imageNamed:@"excited"],
                        [UIImage imageNamed:@"happy"],
                        [UIImage imageNamed:@"nervous"],
                        [UIImage imageNamed:@"neutral"],
                        [UIImage imageNamed:@"romantic"],
                        [UIImage imageNamed:@"sad"
                         ]];
    
    
    
    // TRACKS
    self.songs = [[NSMutableArray alloc] init];
    self.songs = self.spotifyManager.savedTracks;
    self.spotifyPicker.delegate = self;
    self.spotifyPicker.dataSource = self;
    
    // LOCATION
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer; // accuracy of user's location
    self.locationManager.distanceFilter = 1000.0f; // meters
    [self.locationManager requestAlwaysAuthorization]; // display a UIAlertViewController asking the user for permission to ALWAYS fetch their location, even when the app is in background
    [self.locationManager startUpdatingLocation];
    
    // DATE
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    self.currentDate = [dateFormatter stringFromDate:[NSDate date]];
    self.dateLabel.text = [NSString stringWithFormat:@"Date: %@",self.currentDate];
    //NSLog(@"Current date: %@", self.currentDate);
    
    //self.spotifyPicker.reloadAllComponents;
    self.saveButton.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.titleTextField becomeFirstResponder];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (pickerView.tag == 2){
    NSString *trackname = self.songs[row][@"TrackName"];
        NSString *artist = self.songs[row][@"Artist"];
        NSString *songname = [NSString stringWithFormat:@"%@ - %@",trackname,artist];
        return songname;
    } else {
        return nil;
    }
}

- (UIView *) pickerView: (UIPickerView *) pickerView
             viewForRow: (NSInteger) row
           forComponent: (NSInteger) component
            reusingView: (UIView *) view
{
    
    NSLog(@"%li", (long)pickerView.tag);
    if ([pickerView isEqual:self.moodPicker]) {
        UIImage *image = self.moodImages[row];
        UIImageView *imageView = [[UIImageView alloc]
                                  initWithImage:image];
        return imageView;
    }
    else {
        NSString *trackname = self.songs[row][@"TrackName"];
        NSString *artist = self.songs[row][@"Artist"];
        NSString *songname = [NSString stringWithFormat:@"%@ - %@",trackname,artist];
        UILabel *label = [[UILabel alloc] init];
        label.center = CGPointMake(self.view.bounds.size.width/2, 10);
                          //initWithFrame:CGRectMake(self.frame.origin., 0, 400.0f, 20.0f)];//self.view.bounds.size.width, 20.0f)];
        label.text = songname;
        
        return label;
    }
}

- (NSInteger) numberOfComponentsInPickerView:
(UIPickerView *) pickerView
{
    if ([pickerView isEqual:self.moodPicker]) {
        return 1;
    } else if ([pickerView isEqual:self.spotifyPicker]) {
        return 1;
    } else {
        return 0;
    }
}
- (NSInteger) pickerView: (UIPickerView *) pickerView
 numberOfRowsInComponent: (NSInteger) component
{
    if ([pickerView isEqual:self.moodPicker]){
        return [self.moodImages count];
    } else if ([pickerView isEqual:self.spotifyPicker]){
        //NSLog(@"Songs length: %lu", [self.songs count]);
        return [self.songs count];
    } else{
        return 0;
    }
}

// MARK: - Actions

- (IBAction)saveDidTapped:(UIBarButtonItem *)sender {
    NSInteger rowMood = [self.moodPicker selectedRowInComponent:0];
    NSInteger rowSpotify = [self.spotifyPicker selectedRowInComponent:0];
    
    NSLog(@"Mood row chosen: %ld", rowMood);
    NSLog(@"Mood spotify chosen: %ld", rowSpotify);
    
    NSString *trackname = self.songs[rowSpotify][@"TrackName"];
    NSString *artist = self.songs[rowSpotify][@"Artist"];
    NSString *songname = [NSString stringWithFormat:@"%@ - %@",trackname,artist];
    NSString *trackuri = self.songs[rowSpotify][@"TrackURI"];
    
    //NSLog(@"Title is %@, mood is %@, entry is %@, track uri", self.titleTextField.text, [self.moods objectAtIndex:rowMood], self.entryTextView.text);
    
    if (self.completionHandler){
        self.completionHandler(
                               self.titleTextField.text,
                               [self.moods objectAtIndex:rowMood],
                               self.entryTextView.text,
                               trackuri,
                               songname,
                               self.locationCity,
                               self.currentDate,
                               self.image.image);
    }
}

- (IBAction)cancelDidTapped:(UIBarButtonItem *)sender {
    
    if (self.onCancelHandler){
        self.onCancelHandler();
    }
}

- (void) touchesBegan: (NSSet *)touches
            withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.titleTextField isFirstResponder] &&
        [touch view] != self.titleTextField) {
        [self.titleTextField resignFirstResponder];
    }
    else if ([self.entryTextView isFirstResponder] &&
             [touch view] != self.entryTextView) {
        [self.entryTextView resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

// MARK: - UITextFieldDelegate methods

/*
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.entryTextView becomeFirstResponder];
    return YES;
}*/

// This will be called every time the user types on the text field
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *latestTitleText = [self.titleTextField.text stringByReplacingCharactersInRange:range withString:string];
    
    // Determine if we should enable the save button
    [self updateSaveButtonStatusWithTitle:latestTitleText andEntry:self.entryTextView.text];
    
    return YES;
}

// MARK : - UITextViewDelegate

// This will be called every time the user types on the text view
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSString *latestEntrytext = [self.entryTextView.text stringByReplacingCharactersInRange:range withString:text];
    
    // Determine if we should enable the save button
    [self updateSaveButtonStatusWithTitle:self.titleTextField.text andEntry:latestEntrytext];
    
    return YES;
}

- (void)updateSaveButtonStatusWithTitle:(NSString *)title andEntry:(NSString *)entry{
    self.saveButton.enabled = (title.length > 0 && entry.length > 0);
}

// MARK : - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [self.locationManager stopUpdatingLocation];
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       self.locationCity = placemarks.count ? [placemarks.firstObject locality] : @"Not Found";
                       self.locationLabel.text = [NSString stringWithFormat:@"Location: %@", self.locationCity];
                   }];
}

- (IBAction)pickImage:(UIButton *)sender {
    NSLog(@"Picking image");
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:ipc animated:YES completion:nil];
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    
    self.image.image = originalImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
