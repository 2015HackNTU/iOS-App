//
//  ReportViewController.m
//  TreeHacks
//
//  Created by Divyahans Gupta on 2/3/15.
//  Copyright (c) 2015 divyahansg. All rights reserved.
//

#import "ReportViewController.h"
#import "ColorScheme.h"

#import <Parse/Parse.h>

@interface ReportViewController ()


@end

@implementation ReportViewController
- (id)init
{
    self = [super init];
    if (self){
        XLFormDescriptor * form;
        
        form = [XLFormDescriptor formDescriptorWithTitle:@"Report"];
        
        XLFormSectionDescriptor * contact = [XLFormSectionDescriptor formSectionWithTitle:@"Contact"];
        [form addFormSection:contact];
        
        self.name = [XLFormRowDescriptor formRowDescriptorWithTag:@"name" rowType:XLFormRowDescriptorTypeName title:@"Name"];
        [self.name.cellConfigAtConfigure setObject:@"Optional." forKey:@"textField.placeholder"];
        [self.name.cellConfig setObject:[UIFont fontWithName:@"AvenirNext-Regular" size:16.0] forKey:@"textField.font"];
        [self.name.cellConfig setObject:[UIFont fontWithName:@"AvenirNext-Regular" size:16.0] forKey:@"textLabel.font"];
        [contact addFormRow:self.name];
        
        self.email = [XLFormRowDescriptor formRowDescriptorWithTag:@"email" rowType:XLFormRowDescriptorTypeEmail title:@"Email"];
        [self.email.cellConfigAtConfigure setObject:@"Optional." forKey:@"textField.placeholder"];
        [self.email.cellConfig setObject:[UIFont fontWithName:@"AvenirNext-Regular" size:16.0] forKey:@"textField.font"];
        [self.email.cellConfig setObject:[UIFont fontWithName:@"AvenirNext-Regular" size:16.0] forKey:@"textLabel.font"];
        [contact addFormRow:self.email afterRow:self.name];
        
        self.seatNumber = [XLFormRowDescriptor formRowDescriptorWithTag:@"seatNumber" rowType:XLFormRowDescriptorTypeText title:@"Location"];
        [self.seatNumber.cellConfigAtConfigure setObject:@"Specify seat number." forKey:@"textField.placeholder"];
        [self.seatNumber.cellConfig setObject:[UIFont fontWithName:@"AvenirNext-Regular" size:16.0] forKey:@"textField.font"];
        [self.seatNumber.cellConfig setObject:[UIFont fontWithName:@"AvenirNext-Regular" size:16.0] forKey:@"textLabel.font"];
        [contact addFormRow:self.seatNumber];
        
        XLFormSectionDescriptor * issue = [XLFormSectionDescriptor formSectionWithTitle:@"Issue"];
        [form addFormSection:issue];
        
        self.type = [XLFormRowDescriptor formRowDescriptorWithTag:@"type" rowType:XLFormRowDescriptorTypeSelectorActionSheet title:@"Category"];
        self.type.selectorOptions = @[@"Logistics", @"Food", @"Discrimination", @"Other"];
        [self.type.cellConfig setObject:[UIFont fontWithName:@"AvenirNext-Regular" size:16.0] forKey:@"textLabel.font"];
        [issue addFormRow:self.type];

        self.des = [XLFormRowDescriptor formRowDescriptorWithTag:@"description" rowType:XLFormRowDescriptorTypeTextView title:@"Description"];
        [self.des.cellConfig setObject:[UIFont fontWithName:@"AvenirNext-Regular" size:16.0] forKey:@"textView.font"];
        [self.des.cellConfig setObject:[UIFont fontWithName:@"AvenirNext-Regular" size:16.0] forKey:@"label.font"];
        [issue addFormRow:self.des];
        
        self.form = form;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.barTintColor = [ColorScheme redColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    UILabel *titleLabel = [UILabel new];
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                 NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Regular" size:22.0],
                                 NSKernAttributeName: @2};
    titleLabel.attributedText = [[NSAttributedString alloc] initWithString:@"REPORT" attributes:attributes];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(submit:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    NSDictionary *textAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Regular" size:16.0]
                                     };
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:textAttributes forState:UIControlStateNormal];

}

- (void) submit:(id)sender
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing field." message:@"" delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:nil, nil];
    
    if(self.type.value == nil) {
        alert.message = @"Missing category field";
        [alert show];
        return;
    }
    if(self.des.value == nil) {
        alert.message = @"Missing description field";
        [alert show];
        return;
    }
    
    PFObject *report = [PFObject objectWithClassName:@"Ticket"];
    if(self.name.value != nil) {
        report[@"name"] = self.name.value;
    }
    if(self.email.value != nil) {
        report[@"email"] = self.email.value;
    }
    if(self.seatNumber.value != nil) {
        report[@"location"] = self.seatNumber.value;
    }
    if(self.type.value != nil) {
        report[@"category"] = self.type.value;
    }
    if(self.des.value != nil) {
        report[@"description"] = self.des.value;
    }
    [report saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {

            alert.title = @"Report sent.";
            alert.message = @"Thanks for your feedback!";

            self.des.value = nil; [self reloadFormRow:self.des];
            
            [self.form.formSections enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                XLFormSectionDescriptor* sectionDescriptor = (XLFormSectionDescriptor*)obj;
                [sectionDescriptor.formRows enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    XLFormRowDescriptor* row = (XLFormRowDescriptor*)obj;
                    row.value = nil;
                    [self reloadFormRow:row];
                }];
            }];
            
            [alert show];
        } else {
            alert.title = @"Error";
            alert.message = @"Report not sent.";
            [alert show];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
