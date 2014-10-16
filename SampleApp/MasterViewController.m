//
//  MasterViewController.m
//  SampleApp
//
//  Created by Markus Gasser on 16.10.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"


@implementation MasterViewController

- (void)presentDetail:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DetailViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    controller.preferredInterfaceOrientationForPresentation = [self preferredDetailOrientation];
    controller.modalPresentationStyle = [self detailPresentationStyle];
    [self presentViewController:controller animated:YES completion:nil];
}

- (UIInterfaceOrientation)preferredDetailOrientation {
    switch (self.detailOrientationSwitch.selectedSegmentIndex) {
        case 0: return UIInterfaceOrientationPortrait;
        case 1: return UIInterfaceOrientationPortraitUpsideDown;
        case 2: return UIInterfaceOrientationLandscapeLeft;
        case 3: return UIInterfaceOrientationLandscapeRight;
        
        default:
            return UIInterfaceOrientationPortrait;
    }
}

- (UIModalPresentationStyle)detailPresentationStyle {
    switch (self.presentationStyleSwitch.selectedSegmentIndex) {
        case 0: return UIModalPresentationFullScreen;
        case 1: return UIModalPresentationPageSheet;
        case 2: return UIModalPresentationFormSheet;
            
        default:
            return UIModalPresentationFullScreen;
    }
}

@end
