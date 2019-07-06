//
//  ComposeViewController.m
//  twitter
//
//  Created by josemurillo on 7/2/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
#import "Tweet.h"

@interface ComposeViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *composerText;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.composerText.delegate = self;
}

- (IBAction)tweetButton:(id)sender {
    [[APIManager shared] postStatusWithText:self.composerText.text completion:^(Tweet *tweet, NSError *error) {
        if (tweet) {
            [self.delegate didTweet:tweet];
            [self dismissViewControllerAnimated:YES completion:nil];
    
        } else {
            NSLog(@"failed to post tweet, %@", error.localizedDescription);
        }
    }];
}

- (IBAction)closeButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
