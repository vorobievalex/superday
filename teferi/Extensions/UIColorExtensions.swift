import UIKit

extension UIColor
{
    //MARK: Initializers
    convenience init(r: Int, g: Int, b: Int, a : CGFloat = 1.0)
    {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }
    
    convenience init(hex: Int)
    {
        self.init(r: (hex >> 16) & 0xff, g: (hex >> 8) & 0xff, b: hex & 0xff)
    }
    
    convenience init(hexString: String)
    {
        let hex = hexString.hasPrefix("#") ? String(hexString.dropFirst()) : hexString
        var hexInt : UInt32 = 0
        Scanner(string: hex).scanHexInt32(&hexInt)
        
        self.init(hex: Int(hexInt))
    }
    
    var hexString : String
    {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(format:"#%02X%02X%02X", Int(r * 0xff), Int(g * 0xff), Int(b * 0xff))
    }
}

extension UIColor
{
    static let familyGreen: UIColor = UIColor(r: 40, g: 201, b: 128)
    static let almostBlack: UIColor =  UIColor(r: 4, g: 4, b: 6)
    static let normalGray: UIColor = UIColor(r: 144, g: 146, b: 147)
    static let lightBlue: UIColor = UIColor(hex: 0xE6F8FC)
    static let lightBlue2: UIColor = UIColor(hex: 0xD1F2F9)
    
    // Categories
    static let commute: UIColor = UIColor(hex: 0x63d5eeff)
    static let family: UIColor = UIColor(hex: 0x28c980ff)
    static let fitness: UIColor = UIColor(hex: 0x5896ffff)
    static let food: UIColor = UIColor(hex: 0xff6453ff)
    static let friends: UIColor = UIColor(hex: 0x86ddc1ff)
    static let hobby: UIColor = UIColor(hex: 0x7045ffff)
    static let household: UIColor = UIColor(hex: 0x9e579dff)
    static let kids: UIColor = UIColor(hex: 0x00bb9aff)
    static let leisure: UIColor = UIColor(hex: 0xba5effff)
    static let school: UIColor = UIColor(hex: 0xfe8d03ff)
    static let shopping: UIColor = UIColor(hex: 0xdc8fffff)
    static let sleep: UIColor = UIColor(hex: 0xb4c3e7ff)
    static let unknown: UIColor = UIColor(hex: 0xcecdcdff)
    static let work: UIColor = UIColor(hex: 0xffc31bff)
}
