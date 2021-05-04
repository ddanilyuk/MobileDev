//
//  ImagePicker.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 04.05.2021.
//

import Foundation
import AVFoundation
import Photos
import UIKit

final class ImagePicker: NSObject {
    
    enum PickerType {
        
        case image
        
        var mediaTypes: [String] {
            switch self {
            case .image:
                return ["public.image"]
            }
        }
        
        var cameraCaptureMode: UIImagePickerController.CameraCaptureMode {
            
            switch self {
            case .image:
                return .photo
            }
        }
    }
    
    enum Result {
        case success(originalImage: UIImage, editedImage: UIImage?, name: String?, picker: UIImagePickerController)
        case noValue
        case denied(errorMessage: String)
        case remove
        case cancel
    }
    
    enum ErrorType: Error {
        case denied(errorMessage: String)
    }
    
    typealias Completion = (_ result: Result) -> Void
    
    fileprivate var completion: Completion?
    fileprivate var type: PickerType = .image
    
    private let phImageManager = PHImageManager.default()
    
    init(type: PickerType = .image) {
        super.init()
        
        self.type = type
    }
    
    func setType(type: PickerType) -> ImagePicker {
        
        self.type = type
        
        return self
    }
    
    func presentInViewController(_ viewController: UIViewController,
                                 isEditable: Bool,
                                 sourceType: UIImagePickerController.SourceType,
                                 completion: @escaping Completion) {
        
        self.completion = completion
        
        let presentImagePickerClosure = { [unowned self] (sourceType: UIImagePickerController.SourceType) in
            do {
                try self.presentImagePickerInViewController(viewController, isEditable: isEditable, source: sourceType)
            } catch let error as ImagePicker.ErrorType {
                
                switch error {
                case .denied(let errorMessage):
                    self.completion?(Result.denied(errorMessage: errorMessage))
                    AlertManager.showSettingsAlert()
                    self.completion = nil
                }
                
            } catch _ {
                self.completion?(Result.cancel)
                self.completion = nil
            }
        }
        
        presentImagePickerClosure(sourceType)
    }
    
    fileprivate func presentImagePickerInViewController(_ viewController: UIViewController, isEditable: Bool, source: UIImagePickerController.SourceType) throws {
        
        guard source == .photoLibrary || (source == .camera && UIImagePickerController.isSourceTypeAvailable(.camera))  else {
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = isEditable
        imagePicker.sourceType = source
        imagePicker.mediaTypes = type.mediaTypes
        
        switch source {
        case .camera:
            
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            
            guard status != .restricted && status != .denied  else {
                throw ErrorType.denied(errorMessage: NSLocalizedString("DISABLED_CAMERA_ACCESS_MESSAGE", comment: ""))
            }
            
            imagePicker.showsCameraControls = true
            imagePicker.cameraCaptureMode = type.cameraCaptureMode
            imagePicker.cameraDevice = .rear
            imagePicker.modalPresentationStyle = .overFullScreen
            viewController.present(imagePicker, animated: true, completion: nil)
            
        case .photoLibrary, .savedPhotosAlbum:
            
            switch PHPhotoLibrary.authorizationStatus() {
            case .authorized, .limited:
                viewController.present(imagePicker, animated: true, completion: nil)
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { status in
                    guard status != .restricted && status != .denied  else {
                        return
                    }
                    DispatchQueue.main.async {
                        viewController.present(imagePicker, animated: true, completion: nil)
                    }
                }
            case .denied, .restricted:
                throw ErrorType.denied(errorMessage: NSLocalizedString("DISABLED_CAMERA_ACCESS_MESSAGE", comment: ""))
            @unknown default:
                fatalError("Please check new authorization status and setup proper flow for him")
            }
        @unknown default:
            break
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        switch type {
        case .image:
            if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                
                let name = (info[UIImagePickerController.InfoKey.imageURL] as? URL)?.lastPathComponent ?? "image.jpeg"
                completion?(.success(originalImage: originalImage, editedImage: info[UIImagePickerController.InfoKey.editedImage] as? UIImage, name: name, picker: picker))
                completion = nil
            } else {
                completion?(.noValue)
                completion = nil
                picker.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        completion?(Result.cancel)
        completion = nil
        picker.dismiss(animated: true, completion: nil)
    }
}
