//
//  ViewController.swift
//  ImageMetadata
//
//  Created by 박민서 on 11/25/23.
//

import UIKit
//1. import PhotosUI
import PhotosUI

class ViewController: UIViewController {
    lazy var picker: PHPickerViewController = {
        //2. Create PHPickerConfiguration
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 3
        configuration.filter = .any(of: [.images, .livePhotos])
        //3. Initialize PHPicker
        let picker = PHPickerViewController(configuration: configuration)
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        picker.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        present(picker, animated: true, completion: nil)
    }
}

//4. conform PHPickerViewControllerDelegate
extension ViewController: PHPickerViewControllerDelegate {
    
    //사용자가 사진을 선택했을 때 불리는 메서드
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        guard !results.isEmpty else {   // 사용자가 ‘취소’ 버튼을 눌렀을 때
            // dismiss 수행하면 된다.
            return
        }
        
        let imageResult = results[0] // 추가한 이미지 리스트 중 첫번째
        
        // UIImage 타입으로 해당 이미지 파일을 로드할 수 있는지 여부를 체크.
        guard imageResult.itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
        
        // hasItemConformingToTypeIdentifier - 특정 데이터 타입에 대해 가능한지 확인해주는 역할 - 파일 자체의 데이터 타입을 구분
        if imageResult.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
            // 파일의 데이터 타입에 맞춰 data return
            imageResult.itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, error in
                guard let data = data,
                      // CGImageSourceCreateWithData로 CGImage로 변환
                      let cgImageSource = CGImageSourceCreateWithData(data as CFData, nil),
                      // CGImageSourceCopyPropertiesAtIndex로 cgImageSource딕셔너리에서 정보를 가져온다
                      let properties = CGImageSourceCopyPropertiesAtIndex(cgImageSource, 0, nil) as? Dictionary<String, Any>,
                      // 이때 CGImageSourceCopyPropertiesAtIndex는 CFDictionary로 반환하는데, { "{Exif}": {width: 480, ... }, "{TIFF}": {pixel: 480, ...} } 와 같은 JSON 떡칠이라 딕셔너리로 타입캐스팅
                      let exif = properties["{Exif}"], // Exif 값을 끌고 오는데, Any 타입으로 갖고와진다.
                      let dictionary = exif as? Dictionary<String, Any> // 딕셔너리로 타입 캐스팅
                else {
                    return
                }
                imageResult.itemProvider.loadObject(ofClass: UIImage.self) { (selectedImage: NSItemProviderReading?, error: Error?) in
                    // 선택한 Image를 Load해 수행할 명령
                    print("cgImageSource: ", cgImageSource)
                    print("properties: ", properties)
                    print("exif: ", exif)
                    print("dictionary: ", dictionary)
                }
            }
        }
    }
}
