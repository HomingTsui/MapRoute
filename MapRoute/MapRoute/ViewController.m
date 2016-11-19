//
//  ViewController.m
//  MapRoute
//
//  Created by Kent on 2016/11/19.
//  Copyright © 2016年 Ming. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

/*
 ShangHai People Square:
    latitude        31.229564 N
    longitude       121.47438 E
 
 ShangHai Train Station:
    latitude        31.15     N
    longitude       121.272   E
 */

@interface ViewController () <MKMapViewDelegate>

// Map View
@property (nonatomic,weak) MKMapView *mapView;

@end

@implementation ViewController

- (MKMapView *)mapView {
    if (!_mapView) {
        MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
        mapView.delegate = self;
        [self.view addSubview:mapView];
        
        CLLocationCoordinate2D coordinate2D = {31.229564,121.47438};
        MKCoordinateSpan span = {.01,.01};
        
        MKCoordinateRegion region = MKCoordinateRegionMake(coordinate2D, span);
        [mapView setRegion:region];
        
        _mapView = mapView;
    }
    return _mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self mapView];
    
    [self drawLine];
    
}

- (void)drawLine {
    
    CLLocationCoordinate2D start = {31.229564,121.47438};
    CLLocationCoordinate2D end = {31.15,121.272};

    MKPlacemark *startPlace = [[MKPlacemark alloc] initWithCoordinate:start addressDictionary:nil];
    MKPlacemark *endPlace = [[MKPlacemark alloc] initWithCoordinate:end addressDictionary:nil];
    
    MKMapItem *startItem = [[MKMapItem alloc] initWithPlacemark:startPlace];
    MKMapItem *endItem = [[MKMapItem alloc] initWithPlacemark:endPlace];
    
    MKDirectionsRequest *dirRequest = [[MKDirectionsRequest alloc] init];
    dirRequest.source = startItem;
    dirRequest.destination = endItem;
    
    MKDirections *direction = [[MKDirections alloc] initWithRequest:dirRequest];
    
    __block NSInteger sumDistance = 0;
    
    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            
            MKRoute *route = response.routes[0];
            
            for (MKRouteStep *step in route.steps) {
                
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                annotation.coordinate = step.polyline.coordinate;
                annotation.title = step.polyline.title;
                annotation.subtitle = step.polyline.subtitle;
                
                [self.mapView addAnnotation:annotation];
                
                [self.mapView addOverlay:step.polyline];
                
                sumDistance += step.distance;
                
            }
            
            NSLog(@"Distance: %ld",sumDistance);
            
        }
        
    }];
    
}

-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        
        MKPolylineRenderer *polylineRender = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        polylineRender.strokeColor = [UIColor greenColor];
        polylineRender.lineWidth = 5;
        return polylineRender;
        
    }
    return nil;
}

@end


























































