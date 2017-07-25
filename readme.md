# Swift Native Kit
Write native(JS+HTML+CSS) web Apps using UIKit

```swift
class ViewController : SNViewController {
    var label:SNLabel!
    override func viewDidLoad() {
        label = SNLabel(frame:CGRect(x: 100, y: 100, width: 100, height: 100))
        label!.text = "hello SNKit"
        self.view.addSubview(label!)
        let button = SNButton(frame:CGRect(x: 200, y: 200, width: 120, height: 40))
        button.setTitle("Magic Button", forState: .Normal)
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(ViewController.buttonPushed), forControlEvents: .TouchUpInside)
    }

    @objc
    func buttonPushed() {
        label.text = "Someone pushed the button"
    }
}
```

renders following Webpage

see https://github.com/johnlinvc/hello_snkit for sample
