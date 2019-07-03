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

@interface ComposeViewController ()

@property (weak, nonatomic) IBOutlet UITextView *composerText;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)tweetButton:(id)sender {
    [[APIManager shared] postStatusWithText:self.composerText.text completion:^(Tweet *tweet, NSError *error) {
        if (tweet) {
            [self.delegate didTweet:tweet];
            [self dismissViewControllerAnimated:true completion:nil];
    
        } else {
            NSLog(@"failed to post tweet, %@", error.localizedDescription);
        }
    }];
}

- (IBAction)closeButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
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
