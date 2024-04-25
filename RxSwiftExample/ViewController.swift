//
//  ViewController.swift
//  RxSwiftExample
//
//  Created by 장효원 on 4/22/24.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createEx1()
        createColdObservableEx()
        createHotObservableEx()
        
        createPublishSubjectEx()
        createBehaviorSubjectEx()
        createReplaySubjectEx()
        createAsyncSubjectEx1()
        createAsyncSubjectEx2()
        
        create_merge_Operator()
        create_concat_Operator()
        create_combineLatest_Operator()
        create_zip_Operator()
        create_amb_Operator()
    }

    private func createEx1() {
        let observable = Observable.of("Hello", "RxSwift")
        
        observable
            .subscribe(
                onNext:{ value in
                    print("Next: ", value)
                }, onError: { error in
                    print("Error: ", error)
                }, onCompleted: {
                    print("Completed")
                }, onDisposed: {
                    print("Disposed")
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func createColdObservableEx() {
        let observable = Observable<Int>.create { observer in
            observer.onNext(1)
            observer.onNext(2)
            observer.onNext(3)
            observer.onCompleted()
            return Disposables.create()
        }

        observable.subscribe { event in
            print("Cold Observer 1: \(event)")
        }
        .disposed(by: disposeBag)

        observable.subscribe { event in
            print("Cold Observer 2: \(event)")
        }
        .disposed(by: disposeBag)
    }
    
    private func createHotObservableEx() {
        let observable = PublishSubject<Int>()

        observable.subscribe { event in
            print("Hot Observer 1: \(event)")
        }
        .disposed(by: disposeBag)

        observable.onNext(1)
        observable.onNext(2)

        observable.subscribe { event in
            print("Hot Observer 2: \(event)")
        }
        .disposed(by: disposeBag)

        observable.onNext(3)
        observable.onCompleted()
    }

    private func createPublishSubjectEx() {
        let subject = PublishSubject<String>()

        subject.onNext("You can't see this message")
        
        subject.subscribe(onNext: { response in
            print("PublishSubject: \(response)")
        })
        .disposed(by: disposeBag)

        subject.onNext("PublishSubject response 1")
        subject.onNext("PublishSubject response 2")
    }
    
    private func createBehaviorSubjectEx() {
        let subject = BehaviorSubject(value: "BehaviorSubject Init")
        
        subject.onNext("You can see this message")
        
        subject.subscribe(onNext: { response in
            print("PublishSubject: \(response)")
        })
        .disposed(by: disposeBag)
        
        subject.onNext("response 1")
        subject.onNext("response 2")
    }
    
    private func createReplaySubjectEx() {
        let subject = ReplaySubject<String>.create(bufferSize: 2)

        subject.onNext("Event 1")
        subject.onNext("Event 2")
        subject.onNext("Event 3")

        subject.subscribe(onNext: { response in
            print("ReplaySubject: \(response)")
        })
        .disposed(by: disposeBag)
    }
    
    private func createAsyncSubjectEx1() {
        let subject = AsyncSubject<String>()
        
        subject.onNext("Event 1")
        
        subject.subscribe(onNext: { response in
            print("ReplaySubject Ex1 : \(response)")
        }).disposed(by: disposeBag)
        
        subject.onNext("Event 2")
        subject.onNext("Event 3")
        
        subject.onCompleted()
    }
    
    private func createAsyncSubjectEx2() {
        let subject = AsyncSubject<String>()
        
        subject.onNext("Event 1")
        
        subject.subscribe(onNext: { response in
            print("ReplaySubject Ex2: \(response)")
        }).disposed(by: disposeBag)
        
        subject.onCompleted()
    }
    
    private func create_merge_Operator() {
        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<String>()
        
        let observables = Observable.of(subject1, subject2)
        
        observables.merge()
            .subscribe(onNext: {
                print("merge : \($0)")
            })
            .disposed(by: disposeBag)
        
        subject1.onNext("subject1")
        subject2.onNext("subject2")
        subject1.onNext("subject1-1")
        subject2.onNext("subject2-1")
        subject1.onNext("subject1-2")
        subject2.onNext("subject2-2")
    }
    
    private func create_concat_Operator() {
        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<String>()
        
        subject1.concat(subject2)
            .subscribe(onNext: {
                print("concat response : \($0)")
            })
            .disposed(by: disposeBag)
        
        subject1.onNext("subject1")
        subject2.onNext("subject2")
        subject1.onNext("subject1-1")
        subject2.onNext("subject2-1")
        subject1.onNext("subject1-2")
        
        subject1.onCompleted()
        subject2.onNext("subject2-2")
    }
    
    private func create_combineLatest_Operator() {
        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<String>()
        
        Observable.combineLatest(subject1, subject2) { value1, value2 in
            return "\(value1) + \(value2)"
        }.subscribe(onNext: {
            print("combineLatest : \($0)")
        })
        .disposed(by: disposeBag)
        
        subject1.onNext("subject1")
        subject2.onNext("subject2")
        subject1.onNext("subject1-1")
        subject2.onNext("subject2-1")
        subject1.onNext("subject1-2")
        subject1.onNext("subject1-3")
        subject2.onNext("subject2-2")
    }

    private func create_zip_Operator() {
        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<String>()
        
        Observable.zip(subject1, subject2) { value1, value2 in
                return "\(value1) - \(value2)"
            }
            .subscribe(onNext: {
                print("zip : \($0)")
            })
            .disposed(by: disposeBag)
        
        subject1.onNext("subject1")
        subject2.onNext("subject2")
        subject1.onNext("subject1-1")
        subject2.onNext("subject2-1")
        subject1.onNext("subject1-2")
    }
    
    private func create_amb_Operator() {
        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<String>()
        
        subject1.amb(subject2)
            .subscribe(onNext: {
                print("amb response : \($0)")
            })
            .disposed(by: disposeBag)
        
        subject1.onNext("amb subject1")
        subject2.onNext("amb subject2")
        subject1.onNext("amb subject1")
        subject2.onNext("amb subject2")
    }
}

