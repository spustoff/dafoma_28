//
//  CourseViewModel.swift
//  EduWise Most
//
//  Created by Вячеслав on 8/25/25.
//

import Foundation
import Combine

class CourseViewModel: ObservableObject {
    @Published var courses: [Course] = []
    @Published var popularCourses: [Course] = []
    @Published var userCourses: [Course] = []
    @Published var currentCourse: Course?
    @Published var currentLesson: Lesson?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var searchResults: [Course] = []
    @Published var searchText: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    private let courseService: CourseService
    
    init(courseService: CourseService = CourseService()) {
        self.courseService = courseService
        setupSearchBinding()
        loadCourses()
    }
    
    func loadCourses() {
        isLoading = true
        errorMessage = nil
        
        courseService.getAllCourses()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] courses in
                    self?.courses = courses
                    self?.popularCourses = courses.filter { $0.isPopular }
                }
            )
            .store(in: &cancellables)
    }
    
    func loadUserCourses(userId: UUID) {
        courseService.getUserCourses(userId: userId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] courses in
                    self?.userCourses = courses
                }
            )
            .store(in: &cancellables)
    }
    
    func enrollInCourse(_ course: Course, userId: UUID) {
        isLoading = true
        
        courseService.enrollInCourse(courseId: course.id, userId: userId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] _ in
                    self?.loadUserCourses(userId: userId)
                }
            )
            .store(in: &cancellables)
    }
    
    func startLesson(_ lesson: Lesson, in course: Course) {
        currentCourse = course
        currentLesson = lesson
    }
    
    func completeLesson(_ lesson: Lesson, in course: Course, userId: UUID) {
        guard let courseIndex = courses.firstIndex(where: { $0.id == course.id }),
              let lessonIndex = courses[courseIndex].lessons.firstIndex(where: { $0.id == lesson.id }) else {
            return
        }
        
        courses[courseIndex].lessons[lessonIndex].isCompleted = true
        courses[courseIndex].lessons[lessonIndex].completedAt = Date()
        
        // Update user courses as well
        if let userCourseIndex = userCourses.firstIndex(where: { $0.id == course.id }),
           let userLessonIndex = userCourses[userCourseIndex].lessons.firstIndex(where: { $0.id == lesson.id }) {
            userCourses[userCourseIndex].lessons[userLessonIndex].isCompleted = true
            userCourses[userCourseIndex].lessons[userLessonIndex].completedAt = Date()
        }
        
        // Save progress to service
        courseService.updateLessonProgress(lessonId: lesson.id, userId: userId, isCompleted: true)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)
    }
    
    func filterCourses(by language: Language? = nil, skill: FinancialSkill? = nil, difficulty: DifficultyLevel? = nil) {
        var filtered = courses
        
        if let language = language {
            filtered = filtered.filter { $0.language == language }
        }
        
        if let skill = skill {
            filtered = filtered.filter { $0.financialSkill == skill }
        }
        
        if let difficulty = difficulty {
            filtered = filtered.filter { $0.difficulty == difficulty }
        }
        
        searchResults = filtered
    }
    
    private func setupSearchBinding() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.performSearch(searchText)
            }
            .store(in: &cancellables)
    }
    
    private func performSearch(_ searchText: String) {
        if searchText.isEmpty {
            searchResults = courses
        } else {
            searchResults = courses.filter { course in
                course.title.localizedCaseInsensitiveContains(searchText) ||
                course.description.localizedCaseInsensitiveContains(searchText) ||
                course.language.displayName.localizedCaseInsensitiveContains(searchText) ||
                course.financialSkill.displayName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}
