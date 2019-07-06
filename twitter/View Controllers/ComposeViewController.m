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
@property (weak, nonatomic) IBOutlet UILabel *countView;

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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // Set the max character limit
    int characterLimit = 140;
    
    // Construct what the new text would be if we allowed the user's latest edit
    NSString *newText = [self.composerText.text stringByReplacingCharactersInRange:range withString:text];
    
    // Update Character Count Label
    int restChars = characterLimit - newText.length;
    self.countView.text = [NSString stringWithFormat:@"%d",restChars];
    
    // The new text should be allowed? True/False
    if (newText.length < characterLimit) {
        return true;
    } else {
        return false;
    }
}

@end
