//
//  UIView+Ext.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 7/11/2021.
//

import UIKit

extension UIView {
    
    func applyTransform(withScale scale: CGFloat, anchorPoint: CGPoint) {
        layer.anchorPoint = anchorPoint
        let scale = scale != 0 ? scale : CGFloat.leastNonzeroMagnitude
        let xPadding = 1/scale * (anchorPoint.x - 0.5)*bounds.width
        let yPadding = 1/scale * (anchorPoint.y - 0.5)*bounds.height
        transform = CGAffineTransform(scaleX: scale, y: scale).translatedBy(x: xPadding, y: yPadding)
    }
    
    
    func applyGradient(isVertical: Bool, colorArray: [UIColor]) {
        layer.sublayers?.filter({ $0 is CAGradientLayer }).forEach({ $0.removeFromSuperlayer() })
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colorArray.map({ $0.cgColor })
        if isVertical {
            //top to bottom
            gradientLayer.locations = [0.0, 1.0]
        } else {
            //left to right
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        
        backgroundColor = .clear
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    //MARK: - Apply Gradient Colors
    
    enum Direction: Int {
        case topToBottom = 0
        case bottomToTop
        case leftToRight
        case rightToLeft
    }
    
    func applyGradient(colors: [Any]?, locations: [NSNumber]? = [0.0, 1.0], direction: Direction = .topToBottom) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.accessibilityLabel = "applied-gradient"
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors
        gradientLayer.locations = locations
        
        switch direction {
        case .topToBottom:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            
        case .bottomToTop:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
            
        case .leftToRight:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            
        case .rightToLeft:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        }
                
        if let layers = self.layer.sublayers {
            for layer in layers where layer.accessibilityLabel == "applied-gradient" {
                layer.removeFromSuperlayer()
            }
        }
        
        self.layer.addSublayer(gradientLayer)
    }
    
}


// MARK: - Add a border to one side of a view
public enum BorderSide {
    case top, bottom, left, right
}

extension UIView {
    
    public func hideKeyboard(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing(_:)))
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(UIView.endEditing(_:)))
        swipeGesture.direction = .down
        
        self.addGestureRecognizer(tapGesture)
        self.addGestureRecognizer(swipeGesture)
    }
    
    public func addBorder(side: BorderSide, color: UIColor, width: CGFloat) {
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = color
        self.addSubview(border)
        
        let topConstraint = topAnchor.constraint(equalTo: border.topAnchor)
        let rightConstraint = trailingAnchor.constraint(equalTo: border.trailingAnchor)
        let bottomConstraint = bottomAnchor.constraint(equalTo: border.bottomAnchor)
        let leftConstraint = leadingAnchor.constraint(equalTo: border.leadingAnchor)
        let heightConstraint = border.heightAnchor.constraint(equalToConstant: width)
        let widthConstraint = border.widthAnchor.constraint(equalToConstant: width)
        
        
        switch side {
        case .top:
            NSLayoutConstraint.activate([leftConstraint, topConstraint, rightConstraint, heightConstraint])
        case .right:
            NSLayoutConstraint.activate([topConstraint, rightConstraint, bottomConstraint, widthConstraint])
        case .bottom:
            NSLayoutConstraint.activate([rightConstraint, bottomConstraint, leftConstraint, heightConstraint])
        case .left:
            NSLayoutConstraint.activate([bottomConstraint, leftConstraint, topConstraint, widthConstraint])
        }
    }
}

class DashedBorderView: UIView {

    let dashedBorder = CAShapeLayer()
    
    var color: UIColor = .clear
    var lineWidth: CGFloat = 0
    var cornerRadius: CGFloat = 0

    convenience init(color: UIColor, lineWidth: CGFloat, cornerRadius: CGFloat) {
        self.init()

        self.color = color
        self.lineWidth = lineWidth
        self.cornerRadius = cornerRadius
        
        commonInit()
    }
    
   private func commonInit() {
       dashedBorder.strokeColor = self.color.cgColor
       dashedBorder.lineDashPattern = [6, 4]
       dashedBorder.frame = self.bounds
       dashedBorder.fillColor = nil
       dashedBorder.lineWidth = self.lineWidth
       self.layer.addSublayer(dashedBorder)
   }

   override func layoutSublayers(of layer: CALayer) {
       super.layoutSublayers(of: layer)
       
       dashedBorder.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.cornerRadius).cgPath
       dashedBorder.frame = self.bounds
       
       commonInit()
   }
    
}

enum SectionType {
    case light
    case black
    case customLight(height: Int, width: Int)
    case customBlack(height: Int, width: Int)
    
    var image: UIImage? {
        switch self {
        case .light:
            return UIImage(named: "AddResume")?.imageWithSize(CGSize(width: 35, height: 35))
        case .black:
            return UIImage(named: "Add-Resume-black-small")?.imageWithSize(CGSize(width: 35, height: 35))
        case .customLight(height: let height, width: let width):
            return UIImage(named: "AddResume")?.imageWithSize(CGSize(width: height, height: width))
        case .customBlack(height: let height, width: let width):
            return UIImage(named: "Add-Resume-black-small")?.imageWithSize(CGSize(width: height, height: width))
        }
    }
}

class AddNewSection: UIView {
    
    var title: String = ""
    var color: UIColor = .clear
    var lineWidth: CGFloat = 0
    var cornerRadius: CGFloat = 0
    var icon: SectionType?

    lazy var centerText: UILabel = {
        let label = UILabel()
        let attributed = NSAttributedString(string: title, attributes: [
            .font : UIFont(name: Theme.nunitoSansBold, size: 15) as Any,
            .foregroundColor: self.color
        ])
        label.attributedText = attributed
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = self.icon?.image?.withRenderingMode(.alwaysOriginal)

        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.image = image
            button.configuration = config
        } else {
            button.setImage(image, for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
        }
        
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var globalView: DashedBorderView = {
        let _view = DashedBorderView(color: self.color, lineWidth: self.lineWidth, cornerRadius: self.cornerRadius)
        _view.translatesAutoresizingMaskIntoConstraints = false
        return _view
    }()
    
    let separatorView: UIView = {
        let _view = UIView()
        _view.translatesAutoresizingMaskIntoConstraints = false
        return _view
    }()
    
    convenience init(title: String, color: UIColor, lineWidth: CGFloat = 1, cornerRadius: CGFloat = 8, icon: SectionType = .light) {
        self.init()
        self.title = title
        self.color = color
        self.lineWidth = lineWidth
        self.cornerRadius = cornerRadius
        self.icon = icon
    }

    override func layoutSubviews() {
        super.layoutSubviews()
                        
        if #available(iOS 15.0, *) {
            var config = addButton.configuration
            config?.image = self.icon?.image
            addButton.configuration = config
        } else {
            addButton.setImage(self.icon?.image, for: .normal)
            addButton.imageEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
        }
        
        
        addSubview(globalView)
        addSubview(separatorView)
        globalView.addSubview(addButton)
        globalView.addSubview(centerText)

        let globalViewLayout: NSLayoutConstraint = globalView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        globalViewLayout.priority = UILayoutPriority(250)
        
        NSLayoutConstraint.activate([
            globalView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            globalView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            globalView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            globalViewLayout,
            
            addButton.centerXAnchor.constraint(equalTo: globalView.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: globalView.centerYAnchor, constant: -10),
            addButton.heightAnchor.constraint(lessThanOrEqualToConstant: 25),
            addButton.widthAnchor.constraint(lessThanOrEqualToConstant: 25),

            centerText.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 10),
            centerText.centerXAnchor.constraint(equalTo: addButton.centerXAnchor),
            centerText.heightAnchor.constraint(equalToConstant: 20),
            
            separatorView.topAnchor.constraint(equalTo: globalView.bottomAnchor, constant: 0),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            separatorView.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),

        ])
    }
}
