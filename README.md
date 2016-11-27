# QPPhotoAlbum
IOS in the local picture library package, the camera calls the package library, package album selector UIImagePickerController

# Example Usage

```
#import "ViewController.h"
#import "QPPhotoAlbum.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) QPPhotoAlbum      *photoAlbum;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 实例化QPPhotoAlbum
    _photoAlbum = [[QPPhotoAlbum alloc] init];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePhotoClick:(id)sender {
    
    // 调用getPhotoAlbumOrTakeAPhotoWithController方法
    [_photoAlbum getPhotoAlbumOrTakeAPhotoWithController:self andWithBlock:^(UIImage *image) {
        self.imageView.image = image;
    }];
}

@end
```



# Cocoapods
Add pod ```'QPPhotoAlbum', '~> 1.0.0'``` to your Podfile Run ```pod install``` or ```pod update```

# Contributing
- If you need help, open an issue.
- If you found a bug, open an issue.
- If you have a new demand, also open an issue.

# MIT License
QPPhotoAlbum is available under the MIT license. See the LICENSE file for more info.
