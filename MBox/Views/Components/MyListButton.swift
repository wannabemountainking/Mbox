//
//  MyListButton.swift
//  MBox
//
//  Created by YoonieMac on 4/19/26.
//

import SwiftUI

/// My List 버튼 컴포넌트, 사용자가 영화 데이터를 My List에 추가 제거할 수 있도록 제공
struct MyListButton: View {
	
//	@State private var inMyList: Bool = false // My List에 추가된 상탱인지 나타내는 상태
	var inMyList: Bool = false  // 값을 넘겨받을 예정
	var onButtonPressed: (() -> Void)? = nil // 버튼 클릭 시 실행할 클로져
	
 
    var body: some View {
		VStack(spacing: 10) {
			// 버튼 아이콘 에니메이션 포함 (체크 마크 또는 플러스)
			ZStack {
				Image(systemName: "checkmark") // 체크 아이콘
					.opacity(inMyList ? 1 : 0) // My List 에 추가된 상태일 때 표시
					.rotationEffect(Angle(degrees: inMyList ? 0 : 180)) // 에니메이션 회전
				
				Image(systemName: "plus") // 플러스 아이콘
					.opacity(inMyList ? 0 : 1) // MyList 에 추가되지 않은 상태일 때 표시
					.rotationEffect(Angle(degrees: inMyList ? -180 : 0)) // 에니메이션 회전
			} //:ZSTACK
			.font(.title)
			
			Text("My List")
				.font(.caption)
				.foregroundStyle(.ccLightGray)
			
		} //:VSTACK
		.foregroundStyle(.ccWhite) // 텍스트 색상
		.padding()
		.background(Color.ccBlack) // 배경색
		.animation(.spring, value: inMyList) // My List 상태 변경 시 에니메이션 적용
		.onTapGesture {

			onButtonPressed?()
		}
    }//:body
}

#Preview {
	ZStack {
		// Background Color
		Color.ccBlack
			.ignoresSafeArea()
		// Content
		MyListButton()
	} //:ZSTACK
}
