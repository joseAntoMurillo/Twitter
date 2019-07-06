//
//  profileView.m
//  twitter
//
//  Created by josemurillo on 7/5/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "profileView.h"

@interface profileView ()

@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UILabel *userView;

@end

@implementation profileView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadData];
}

- (void) reloadData {
    
}

@end
