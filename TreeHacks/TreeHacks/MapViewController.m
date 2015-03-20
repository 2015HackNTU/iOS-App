//
//  MapViewController.m
//  TreeHacks
//
//  Created by Divyahans Gupta on 2/18/15.
//  Copyright (c) 2015 divyahansg. All rights reserved.
//

#import "MapViewController.h"

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "ColorScheme.h"
#import <Masonry/Masonry.h>

#import "IDMPhotoBrowser.h"

@interface MapViewController ()
@property (strong, nonatomic) NSMutableArray *photos;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationController.navigationBar.barTintColor = [ColorScheme redColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    UILabel *titleLabel = [UILabel new];
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                 NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Regular" size:22.0],
                                 NSKernAttributeName: @2};
    titleLabel.attributedText = [[NSAttributedString alloc] initWithString:@"MAPS" attributes:attributes];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    

    UIButton *open = [[UIButton alloc] init];
    [open setTitle:@"TAP ANYWHERE TO VIEW" forState:UIControlStateNormal];
    [open.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:24]];
    [open setBackgroundColor:[ColorScheme orangeColor]];
    [open.titleLabel setNumberOfLines:0];
    [open.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [open setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:open];
    [open sizeToFit];

    [open mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0).with.offset(0);;
        make.right.equalTo(@0).with.offset(0);;
        make.width.equalTo(self.view);
        make.height.equalTo(@50);
        make.centerY.equalTo(open.superview);
    }];

    
    self.photos = [NSMutableArray new];
    PFQuery *query = [PFQuery queryWithClassName:@"Maps"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for(PFObject *obj in objects) {
                PFFile *file = [obj objectForKey:@"file"];
                NSURL *url = [NSURL URLWithString:[file url]];
                IDMPhoto *photo = [IDMPhoto photoWithURL:url];
                NSString *caption = [obj objectForKey:@"name"];
                if(caption != nil && caption.length > 0) {
                    [photo setCaption:caption];
                }
                [self.photos addObject:photo];
            }
        } else {
        }
    }];
    
    
    [open addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(select:)];
    [self.view addGestureRecognizer:singleFingerTap];
    
}

-(void) select:(id)sender
{
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:self.photos];
    browser.useWhiteBackgroundColor = YES;
    browser.displayActionButton = NO;
    browser.displayCounterLabel= YES;
    browser.forceHideStatusBar = YES;
    [self presentViewController:browser animated:NO completion:nil];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
