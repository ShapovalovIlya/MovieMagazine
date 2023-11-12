//
//  CredentialField.swift
//  
//
//  Created by Илья Шаповалов on 12.11.2023.
//

import Cocoa

public final class CredentialField: NSTextField {
    public var isCredentialValid = true {
        didSet { needsDisplay = true }
    }
    
    public enum FieldType: Int {
        case login = 200
        case password = 201
    }
    
    //MARK: - init(_:)
    public init(
        _ placeholder: String,
        type: FieldType
    ) {
        super.init(frame: .zero)
        
        setupCell(ofType: type)
        
        wantsLayer = true
        layer?.borderWidth = 1
        layer?.cornerRadius = 10
        placeholderString = placeholder
        tag = type.rawValue
        bezelStyle = .roundedBezel
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - updateLayer
    public override func updateLayer() {
        layer?.borderColor = isCredentialValid
        ? NSColor.lightGray.cgColor
        : NSColor.red.cgColor
    }
    
    private func setupCell(ofType type: FieldType) {
        switch type {
        case .login:
            cell = NSTextFieldCell()
        case .password:
            let secureCell = NSSecureTextFieldCell()
            secureCell.echosBullets = false
            cell = secureCell
        }
        cell?.alignment = .center
        cell?.isEditable = true
        cell?.isBezeled = true
    }
}
