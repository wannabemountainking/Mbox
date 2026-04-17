//
//  ImageLoaderView.swift
//  MBox
//
//  Created by yoonie on 4/17/26.
//

import SwiftUI


/// URL을 통해 이미지를 비동기적으로 로드해서 SwiftUI View를 표시하는 커스텀 뷰
struct ImageLoaderView: View {
    
    // MARK: - Property
    
    // 이미지 URL 문자열 저장 속성
    var urlString: String
    
    // 렌덤 이미지를 위한 정적 속성 (테스트 및 대체 이미지 용도)
    static let randomImage: String = "https://picsum.photos/600/600"
    
    // MARK: - Init
    // 레이블 없이 매개변수를 받을 수 있도록 설정
    init(_ urlString: String) {
        self.urlString = urlString
    }
    
    // MARK: - UI
    var body: some View {
        // 기본배경으로 사용하는 사각형
        Rectangle()
            .opacity(0.1) // 불투명도 0.1
        // Rectangle 위에 오버레이 해서 AsyncImage 추가
            .overlay {
                let url = URL(string: urlString)
                AsyncImage(url: url) { phase in
                    // AsyncImage의 데이터 로딩 상태에 따른 구성
                    switch phase {
                    case .empty:
                        ProgressView()
                        // 이미지 로딩 중인 경우 ProgressView 표시
                    case .success(let image):
                        // 성공적으로 이미지를 로드한 경우, 이미지를 원하는 크기로 리사이즈 하기
                        image
                            .resizable() // 이미지가 리사이즈 가능하도록 설정
                            .aspectRatio(contentMode: .fill) // 이미지 비율 유지하며 전체 영역 채우기
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(.ccDarkGray)
                    default:
                        EmptyView()
                    }
                }
            }
            .clipped() // 이미지가 Rectangle의 경계를 벗어나지 않도록 함
    }
}

#Preview {
    ImageLoaderView("https://picsum.photos/600/600")
        .cornerRadius(30)
        .padding(40)
        .padding(.vertical, 60)
}
