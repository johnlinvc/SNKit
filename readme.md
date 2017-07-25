# Swift Native Kit
Write native(JS+HTML+CSS) web Apps using UIKit

Render on both iOS and Web

![Works on both iOS and Web](https://user-images.githubusercontent.com/529248/28554412-ec7e7ae4-712b-11e7-908e-fb57d66911ad.png)

with following code that acts like UIKit

```swift
class ViewController : SNViewController {
    var label:SNLabel!
    override func viewDidLoad() {
        label = SNLabel(frame:CGRect(x: 100, y: 100, width: 100, height: 100))
        label.text = "hello SNKit"
        self.view.addSubview(label!)
        let button = SNButton(frame:CGRect(x: 200, y: 200, width: 140, height: 40))
        button.setTitle("Magic Button", for: .normal)
        button.backgroundColor = SNColor.blue
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(ViewController.buttonPushed), for: .touchUpInside)
    }

    @objc
    func buttonPushed() {
        label.text = "Someone pushed the button"
    }
}
```


see https://github.com/johnlinvc/hello_snkit for sample
