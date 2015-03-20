//
//  ReportViewController.h
//  TreeHacks
//
//  Created by Divyahans Gupta on 2/3/15.
//  Copyright (c) 2015 divyahansg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <XLForm/XLForm.h>
#import "XLFormViewController.h"

@interface ReportViewController : XLFormViewController


@property (strong, nonatomic) XLFormRowDescriptor * name;
@property (strong) XLFormRowDescriptor * email;
@property (strong) XLFormRowDescriptor * seatNumber;
@property (strong) XLFormRowDescriptor * type;
@property (strong) XLFormRowDescriptor * des;

@end
