//
//  CoreDataProvider.swift
//  MBox
//
//  Created by YoonieMac on 4/19/26.
//

import Foundation
import CoreData


/// Core Data와 관련된 데이터 저장, 로드 및 삭제를 관리하는 클래스
class CoreDataProvider {
	
	// MARK: - Properties
	static let shared = CoreDataProvider() // core data provider 싱글톤 인스턴스
	let persistentContainer: NSPersistentContainer // CoreData Persistent Container
	var context: NSManagedObjectContext {
		return persistentContainer.viewContext
	}
	
	// MARK: - Init
	init() {
		// Core 모델 이름 설정
		persistentContainer = NSPersistentContainer(name: "MyMovie")
		persistentContainer.loadPersistentStores { _, error in
			if let error = error {
				fatalError("Core Data 로드 실패: \(error.localizedDescription)")
			}
		}
	}
	
	// MARK: - CRUD 메서드
	
	/// context가 변경될 때마다 저장하는 메서드
	private func saveContext() {
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				print("Context 저장 실패: \(error.localizedDescription)")
			}
		}
	}
	
	/// 영화 데이터를 Core Data에 추가 -> Create
	func addMovie(_ movie: Movie) {
		let myMovie = MyMovie(context: context)
		myMovie.title = movie.title
		myMovie.id = Int64(movie.id)
		myMovie.overview = movie.overview
		myMovie.posterPath = movie.posterPath
		myMovie.releaseDate = movie.releaseDate
		myMovie.voteAverage = movie.voteAverage
		
		saveContext()
	}
	
	// Core Data에서 모든 영화 데이터를 로드함 -> Read
	func fetchMovies() -> [MyMovie] {   // 의문 그냥 [Movie]?로 할 수 있는데 나중에 쓸 때 옵셔널 처리가 난감한 것이 있나? 혹시 받아서 ViewModel에서 [Movie]로 바꾸나?
		let fetchRequest: NSFetchRequest<MyMovie> = MyMovie.fetchRequest()
		do {
			return try context.fetch(fetchRequest)
		} catch {
			print("데이터 로드 실패: \(error.localizedDescription)")
			return []
		}
	}
	
	// update는 추후에 ViewModel 단계에서 만들 예정: 뭔가 파라미터를 여기까지 끌고오기 힘든 듯.
	
	/// CoreData에서 영화 데이터 삭제
	func deleteMovie(_ movie: MyMovie) {
		context.delete(movie)
		saveContext()
	}
	
}

// MARK: - Extension
/// CoreData 엔티티에 대한 확장변수 생성
extension MyMovie {
	
	/// TMDB 포스터 URL 생성
	var posterURL: URL? {
		guard let path = self.posterPath else {return nil}
		return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
	}
}
