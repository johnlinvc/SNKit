struct snkit {

    var text = "Hello, World!"
}

#if os(iOS)
  import UIKit
#elseif os(OSX)
  import Foundation
#endif

public typealias SNResponse = String

#if os(iOS)
open class SNViewController : UIViewController {
}
#elseif os(OSX)
open class SNViewController {
    open var view:SNView!
    open func loadView() {
        self.view = SNView(frame: .zero)
    }
    open func viewDidLoad() {}
    open func viewWillAppear() {}
    public init() {}

    //extra methods
    open func respondToActions(_ actions:[String]) {
        loadView()
        viewDidLoad()
        viewWillAppear()
        view.respondToActions(actions)
    }
    public func renderHTML() -> SNResponse{
        return self.view.renderHTML()
    }
}
#endif

#if os(iOS)
open class SNWindow : UIWindow {
}
#elseif os(OSX)
open class SNWindow {

    open var rootViewController : SNViewController?

    //extra methods

    let bootstrapLink = "<link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css\" integrity=\"sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u\" crossorigin=\"anonymous\">"

    open func renderHeader() -> String{
        return bootstrapLink
    }
    open func dispatch(query: [String:String]) -> String {
        var actions:[String] = []
        for k in query.values {
            actions.append(k)
        }
        self.rootViewController?.respondToActions(actions)
        let body = self.rootViewController?.renderHTML() ?? ""
        print(body)
        let response = "<html><head>\(renderHeader())</head><body>\(body)</body></html>"
        return response
    }

    open func restore_session(fromParams params:[String:String]) {
        print(params)
    }

    public init() {
    }
}
#endif


#if os(iOS)
#elseif os(OSX)
open class SNColor {
    public static let blue = SNColor(red: 0, green: 0, blue: 1, alpha: 1)
    let red : CGFloat
    let green : CGFloat
    let blue : CGFloat
    let alpha : CGFloat
    public init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    //TODO support alpha by invert it?
    public var cssValue : String {
        let hexConverter : (CGFloat) -> String = {
            floatVal in
            let scaledVal = Int(floatVal*255)
            let hexVal = String(scaledVal, radix: 16, uppercase: true)
            return hexVal.characters.count == 1 ? "0\(hexVal)" : hexVal
        }
        let content = [red, green, blue].map(hexConverter).joined()
        return "#\(content)"
    }
}
#endif

#if os(iOS)
open class SNView : UIView {
}
#elseif os(OSX)
open class SNView {
    var _subviews : [SNView] = []
    public var subviews : [SNView] {
        return _subviews
    }

    public var cssAttributes:[String : String] = [ : ]

    public var backgroundColor = SNColor(red: 0, green: 0, blue: 0, alpha: 0) {
        didSet {
            cssAttributes["background-color"] = backgroundColor.cssValue
        }
    }

    public required init(frame: CGRect) {
        cssAttributes["position"] = "absolute"
        cssAttributes["left"] = "\( frame.origin.x)"
        cssAttributes["top"] = "\( frame.origin.y)"
        cssAttributes["width"] = "\( frame.size.width)"
        cssAttributes["height"] = "\( frame.size.height)"
    }

    open func cssString() -> String{
        return cssAttributes.map {
            "\($0): \($1)"
        }.joined(separator:";")
    }

    public func addSubview(_ view: SNView){
        self._subviews.append(view)
    }

    //extra methods

    open func respondToActions(_ actions:[String]) {
        subviews.forEach {
            $0.respondToActions(actions)
        }
    }

    open func renderHTML() -> SNResponse {
        let response = subviews.map {
            $0.renderHTML()
        }.joined(separator: "\n")
        return response
    }
}
#endif

#if os(iOS)
open class SNLabel : UILabel {
}
#elseif os(OSX)
open class SNLabel : SNView {
    public required init(frame: CGRect) {
        super.init(frame: frame)
        self.cssAttributes["font-size"] = "17px"
    }
    open var text = ""

    //extra methods
    open override func renderHTML() -> SNResponse {
        return SNResponse("<div style=\"\(cssString())\">\(text)</div>")
    }
}
#endif

#if os(iOS)
open class SNButton : UILabel {
}
#elseif os(OSX)
public struct SNControlState : OptionSet {
    public let rawValue: UInt
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    public static let normal = SNControlState(rawValue: 1)
}

public struct SNControlEvents : OptionSet {
    public let rawValue: UInt
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    public static let touchUpInside = SNControlEvents(rawValue: 1)
}

open class SNButton : SNView {
    public required init(frame: CGRect) {
        super.init(frame: frame)
        self.cssAttributes["font-size"] = "17px"
        self.cssAttributes["font-align"] = "center"
        self.cssAttributes["color"] = "#FFFFFF"
    }
    var normalTitle = "Button"
    open func setTitle(_ title: String, for state: SNControlState) {
        self.normalTitle = title
    }

    open var target:AnyObject?
    open var action: Selector?
    open var actionStr : String {
        guard let action = action else {return ""}
        return NSStringFromSelector(action)
    }

    open func addTarget(_ target: AnyObject?, action: Selector, for controlEvents: SNControlEvents) {
        self.target = target
        self.action = action
    }

    //extra methods
    open func onClickString() -> String { return "location.search = 'action=\(actionStr)'" }

    open override func respondToActions(_ actions:[String]) {
        if actions.contains(actionStr) {
            let _ = target?.perform(action!)
        }
    }
    open override func renderHTML() -> SNResponse {
        return SNResponse("<button class=\"btn btn-default\" style=\"\(cssString())\" onclick=\"\(onClickString())\">\(normalTitle)</button>")
    }
}
#endif
