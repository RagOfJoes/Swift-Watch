//
//  FloatingTabBarView.swift
//  Swift Watch
//
//  Created by Victor Ragojos on 7/24/20.
//  Copyright © 2020 Victor Ragojos. All rights reserved.
//

import UIKit

protocol FloatingTabBarViewDelegate: AnyObject {
    func did(selectIndex: Int)
}

/**
 A Floating Tab Bar View
 
 Initialize by defining an Array of Image Names and a (optional) background Color
 */
class FloatingTabBarView: UIView {
    weak var delegate: FloatingTabBarViewDelegate?
    
    var buttons: [UIButton] = []
    
    init(items: [String], backgroundColor bgColor: UIColor?, shouldBlur: Bool = true) {
        super.init(frame: .zero)
        var _bgColor: UIColor!
        if bgColor == nil {
            if #available(iOS 13, *) {
                _bgColor = .systemBackground
            } else {
                if #available(iOS 12, *), self.traitCollection.userInterfaceStyle == .dark {
                    _bgColor = .black
                } else {
                    _bgColor = .white
                }
            }
        } else {
            _bgColor = bgColor
        }
        
        backgroundColor = _bgColor
        
        setupStackView(with: items, shouldBlur: shouldBlur)
        updateUI(selectedIndex: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let cornerRadius: CGFloat = 20
        // Rounded Corners
        layer.cornerRadius = cornerRadius
    }
    
    private func setupStackView(with items: [String], shouldBlur: Bool) {
        for (index, item) in items.enumerated() {
            let normalImage = UIImage(named: item)?.withRenderingMode(.alwaysTemplate) ?? UIImage()
            let selectedImage = UIImage(named: "\(item).fill")?.withRenderingMode(.alwaysTemplate) ?? normalImage
            
            let button: UIButton = UIButton.createButton(normalImage: normalImage, selectedImage: selectedImage, index: index)
            button.addTarget(self, action: #selector(changeTab(_:)), for: .touchUpInside)
            buttons.append(button)
        }
        
        let stackView = UIStackView(arrangedSubviews: buttons)
        
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        
        if shouldBlur {
            backgroundColor = self.backgroundColor?.withAlphaComponent(0.2)
            
            var blurEffect: UIBlurEffect!
            
            if #available(iOS 10.0, *) {
                blurEffect = UIBlurEffect(style: .dark)
            } else {
                blurEffect = UIBlurEffect(style: .light)
            }
            
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.frame = self.bounds
            blurView.roundCorners(.allCorners, radius: 20)
            blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            insertSubview(blurView, at: 0)
        }
    }
    
    @objc private func changeTab(_ sender: UIButton) {
        delegate?.did(selectIndex: sender.tag)
        updateUI(selectedIndex: sender.tag)
    }
    
    private func updateUI(selectedIndex: Int) {
        for (index, button) in buttons.enumerated() {
            if index == selectedIndex {
                button.alpha = 1.0
                button.isSelected = true
                button.tintColor = .systemOrange
            } else {
                button.alpha = 0.4
                button.isSelected = false
                button.tintColor = .systemOrange
            }
        }
    }
    
    func hideTabBar(_ hide: Bool) {
        if isHidden == hide { return }
        
        let duration: TimeInterval = 0.2
        
        isHidden = false
        UIView.animate(withDuration: duration, animations: {
            self.alpha = hide ? 0.0 : 1.0
            self.transform = hide ? CGAffineTransform(scaleX: 0.1, y: 0.1) : .identity
        }, completion: { (true) in
            self.isHidden = hide
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
