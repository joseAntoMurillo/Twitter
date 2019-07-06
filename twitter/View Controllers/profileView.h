//
//  profileView.h
//  twitter
//
//  Created by josemurillo on 7/5/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface profileView : UIViewController

@property (nonatomic, strong) User *user;

@end

NS_ASSUME_NONNULL_END
