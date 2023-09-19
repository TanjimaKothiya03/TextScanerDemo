//
//  ViewController.m
//  TextScanerDemo
//
//  Created by ARTOONMM0024 on 07/09/21.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <TesseractOCR/TesseractOCR.h>

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _screenshotBox.layer.borderColor = [UIColor redColor].CGColor;
    _screenshotBox.layer.borderWidth = 4.0f;
    _screenshotBox.layer.cornerRadius = 10.0f;
    
    [self setupCaptureSession];
    [self setupDevice];
    [self setupInputOutput];
    [self setupPreviewLayer];
    [self startRunningCaptureSession];

}



- (void)setupCaptureSession {
    captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
}

- (void)setupDevice {
    AVCaptureDeviceDiscoverySession *deviceDiscoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera]
                                          mediaType:AVMediaTypeVideo
                                           position:AVCaptureDevicePositionBack];
    NSArray *devices = [deviceDiscoverySession devices];
    for (AVCaptureDevice *device in devices)
      {
          if ([device position] == AVCaptureDevicePositionBack) {
              backCamera = device;
          }else  if ([device position] == AVCaptureDevicePositionFront) {
              frontCamera = device;
          }
              
      }
    currentCamera = backCamera;
}

- (void)setupInputOutput {
    @try {
        NSError *error = nil;

        AVCaptureDeviceInput *captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:currentCamera error:&error];
        [captureSession addInput:captureDeviceInput];
        photoOutput = [[AVCapturePhotoOutput alloc] init];
        AVCapturePhotoSettings* hots = [AVCapturePhotoSettings photoSettingsWithFormat:@{AVVideoCodecKey:AVVideoCodecTypeJPEG}];
        [photoOutput setPreparedPhotoSettingsArray:@[hots]  completionHandler:nil];
        [captureSession addInput:photoOutput];

    }
    @catch (NSException *exception) {
        
    } @finally {
        
    }
}

- (void)setupPreviewLayer {
    
    cameraPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    cameraPreviewLayer.videoGravity =  AVLayerVideoGravityResizeAspectFill;
    cameraPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    [cameraPreviewLayer setFrame:self.view.frame];
    [self.view.layer insertSublayer:cameraPreviewLayer atIndex:0];
}

- (void)startRunningCaptureSession {
    [captureSession startRunning];
}

- (IBAction)analyzeButtonPressed:(id)sender {
    AVCapturePhotoSettings *settings =
                [AVCapturePhotoSettings photoSettingsWithFormat:@{AVVideoCodecKey : AVVideoCodecJPEG}];
    [photoOutput capturePhotoWithSettings:settings delegate:self];
    

}


- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(NSError *)error {
    NSData *imageData = [photo fileDataRepresentation];
     image = [UIImage imageWithData:imageData];
    G8Tesseract* tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng+ita"];
    [tesseract setImage:image];
    [tesseract recognize];
    NSLog(@"%@", [tesseract recognizedText]);

    
//    [self performSegueWithIdentifier:@"showPicture" sender:nil];

}

@end
