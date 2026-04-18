//
//  MBoxHeroCell.swift
//  MBox
//
//  Created by YoonieMac on 4/18/26.
//

import SwiftUI


/// 영화 대표 콘텐츠를 표시하는 Hero Cell 컴포넌트
/// 대표 이미지와 제목을 표시하고, 버튼을 통해 상세페이지로 이동 동작 실행
struct MBoxHeroCell: View {
	
	// MARK: - Properties
	var imageName: String = "" // 이미지 URL 또는 이름
	var title: String = "테스트용 무비입니다" // 제목
	var onBackgroundPressed: (() -> Void)? = nil // 배경클릭 액션을 담을 클로져
	var onDetailPressed: (() -> Void)? = nil // "Detail" 버튼 클릭 액션을 담을 클로져
	
    var body: some View {
		ZStack(alignment: .bottom) {
			// background
			ImageLoaderView(imageName)
				.opacity(0.3) // 배경 이미지 투명도
			VStack(spacing: 15) {
				// 제목
				Text(title)
					.font(.system(size: 50, weight: .medium))
				
				//버튼 영역
				HStack(spacing: 15) {
					Button(action: {
						onDetailPressed?()
					}, label: {
						HStack {
							Image(systemName: "info.circle.fill")
							Text("Detail")
						}
						.frame(maxWidth: .infinity)
						.foregroundStyle(.ccWhite)
					})
					.tint(.ccDarkRed)
					.buttonStyle(.borderedProminent)
					.padding(.horizontal)
				} //:HSTACK
				.font(.title2)
			} //:VSTACK
			.padding(25)
			.background(
				LinearGradient(
					colors: [
						.black.opacity(0),  // 투명도 적용된 그라데인션
						.black.opacity(0.5),
						.black.opacity(0.8)
					],
					startPoint: .top,
					endPoint: .bottom
				)
			)
			//Content
		} //:ZSTACK
		.foregroundStyle(.ccWhite)
		.cornerRadius(10)
		.aspectRatio(0.8, contentMode: .fit) // cell의 비율 설정
		.onTapGesture {
			onBackgroundPressed?() // 배경 클릭 동작 실행
		}
    }//:body
}

#Preview {
	MBoxHeroCell(imageName: ImageLoaderView.randomImage)
		.padding(40)
}
