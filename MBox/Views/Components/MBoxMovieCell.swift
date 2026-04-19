//
//  MBoxMovieCell.swift
//  MBox
//
//  Created by YoonieMac on 4/19/26.
//

import SwiftUI


/// 영화 목록에서 개별 영화를 표시하는 작은 셀 컴포넌트
/// 포스터 이미지와 제목을 표시함
struct MBoxMovieCell: View {
	// MARK: - Properties
	var width: CGFloat = 90 // 셀의 가로 크기
	var height: CGFloat = 140 // 셀의 세로 크기
	var imageName: String = ImageLoaderView.randomImage // 포스터 이미지 URL 기본 랜덤 이미지
	var title: String = "Movie Title" // 영화 제목 (옵셔널)
	
	
    var body: some View {
		ZStack(alignment: .bottom) {
			// 배경 이미지
			ImageLoaderView(imageName)
			// contents
			VStack(spacing: 0) {
				Text(title)
					.font(.footnote)
					.lineLimit(1)
					.padding(5)
			} //:VSTACK
			.frame(maxWidth: .infinity)
			.background(
				LinearGradient(
					colors: [.ccBlack.opacity(0.5), .ccBlack.opacity(0.3)],
					startPoint: .bottom,
					endPoint: .top
				)
			)

		} //:ZSTACK
		.clipShape(.rect(cornerRadius: 5))
		.frame(width: width, height: height)
		.foregroundStyle(.ccWhite)
    }
}

#Preview {
    MBoxMovieCell()
}
